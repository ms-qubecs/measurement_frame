`default_nettype none

module ctrl_upl_parser
  (
   input wire clk,
   input wire reset,

   input wire UPLIn_Request,
   input wire UPLIn_Enable,
   input wire [127:0] UPLIn_Data,
   output reg UPLIn_Ack,

   output reg UPLOut_Request,
   output reg UPLOut_Enable,
   output reg [127:0] UPLOut_Data,
   input wire UPLOut_Ack,

   output reg all_reset_kick,

   output reg dummy_sender_reset,
   output reg dummy_sender_kick,

   output reg [31:0] memory_addr,
   output reg [127:0] memory_dout,
   output reg memory_we,
   input wire [127:0] memory_din,
   
   output reg [15:0] frontend_id,
   output reg [15:0] frontend_num,
   output reg [15:0] round_num,
   output reg [15:0] qubit_id,
   output reg [15:0] field_len,
   output reg [15:0] round_unit,

   output reg [47:0] target_dest_mac
   );

    enum logic[7:0] {IDLE,
		     RECV_DATA0,
		     RECV_DATA1,
		     RECV_DATA2,
		     WAIT_ACK,
		     SEND_DATA0,
		     SEND_DATA1} state;

    logic [31:0] fpga_ip;
    logic [31:0] host_ip;
    logic [15:0] fpga_port;
    logic [15:0] host_port;
    logic [31:0] packet_len;

    enum logic[7:0] {CTRL_NONE,
		     CTRL_SENDER_RESET,
		     CTRL_MEM_WRITE,
		     CTRL_MEM_READ,
		     CTRL_SET_CONFIG,
		     CTRL_SET_MAC,
		     CTRL_SENDER_KICK,
		     CTRL_STOP_TIMER,
		     CTRL_GET_RESULT
		     } ctrl_mode;

    logic [63:0] internal_counter;
    logic reset_internal_counter;
    logic stop_internal_counter;

    always @(posedge clk) begin
	if(reset == 1) begin
	    internal_counter <= 0;
	end else if(reset_internal_counter == 1) begin
	    internal_counter <= 0;
	end else begin
	    if(stop_internal_counter == 0) begin
		internal_counter <= internal_counter + 1;
	    end
	end
    end

    always @(posedge clk) begin
	if (reset == 1) begin
	    state <= IDLE;

	    UPLIn_Ack <= 0;
	    UPLOut_Request <= 0;
	    UPLOut_Enable <= 0;
	    UPLOut_Data <= 128'd0;

	    // ctrl state vlaues
	    all_reset_kick <= 0;

	    dummy_sender_reset <= 0;
	    dummy_sender_kick <= 0;

	    memory_addr <= 0;
	    memory_dout <= 0;
	    memory_we <= 0;

	    ctrl_mode <= CTRL_NONE;

	    frontend_id <= 0;
	    frontend_num <= 0;
	    round_num <= 0;
	    qubit_id <= 0;
	    field_len <= 0;
	    round_unit <= 0;

	    target_dest_mac <= 0;

	    reset_internal_counter <= 1;
	    stop_internal_counter <= 0;

	end else begin
	    case(state)
		IDLE: begin
		    if(UPLIn_Enable == 1) begin
			UPLIn_Ack <= 0;
			state <= RECV_DATA0;
			fpga_ip    <= UPLIn_Data[127:96];
			host_ip    <= UPLIn_Data[95:64];
			fpga_port  <= UPLIn_Data[63:48];
			host_port  <= UPLIn_Data[47:32];
			packet_len <= UPLIn_Data[31:0];
		    end else begin
			UPLIn_Ack <= 1;
		    end
		    UPLOut_Request <= 0;
		    UPLOut_Enable <= 0;
		    UPLOut_Data <= 128'd0;
		    all_reset_kick <= 0;
		    dummy_sender_reset <= 0;
		    dummy_sender_kick <= 0;
		    //memory_addr <= 0;
		    //memory_dout <= 0;
		    memory_we <= 0;
		    ctrl_mode <= CTRL_NONE;

		    reset_internal_counter <= 0; // increment internal counter
		end
		RECV_DATA0: begin
		    if(UPLIn_Data[127:104] == 24'hE00000) begin
			all_reset_kick <= 1;
			state <= IDLE;
		    end else if(UPLIn_Data[127:104] == 24'hE10000) begin
			dummy_sender_reset <= 1;
			ctrl_mode <= CTRL_SENDER_RESET;
			state <= RECV_DATA1;
		    end else if(UPLIn_Data[127:104] == 24'hE10001) begin
			memory_addr <= UPLIn_Data[95:64];
			if(UPLIn_Data[32] == 1) begin
			    ctrl_mode <= CTRL_MEM_WRITE;
			end else begin
			    ctrl_mode <= CTRL_MEM_READ;
			end
			state <= RECV_DATA1;
		    end else if(UPLIn_Data[127:104] == 24'hE10002) begin
			ctrl_mode <= CTRL_SET_CONFIG;
			state <= RECV_DATA1;
		    end else if(UPLIn_Data[127:104] == 24'hE10003) begin
			ctrl_mode <= CTRL_SET_MAC;
			state <= RECV_DATA1;
		    end else if(UPLIn_Data[127:104] == 24'hE10004) begin
			dummy_sender_kick <= 1;
			reset_internal_counter <= 1; // reset internal counter before sending packet
			stop_internal_counter <= 0; // deassert stopping internal counter before sending packet
			ctrl_mode <= CTRL_SENDER_KICK;
			state <= RECV_DATA1;
		    end else if(UPLIn_Data[127:104] == 24'hE10005) begin // stop timer
			stop_internal_counter <= 1; // assert stopping internal counter until next dummy sender kick
			ctrl_mode <= CTRL_STOP_TIMER;
			state <= RECV_DATA1;
		    end else if(UPLIn_Data[127:104] == 24'hE10006) begin // get result
			ctrl_mode <= CTRL_GET_RESULT;
			state <= RECV_DATA1;
		    end else begin
			ctrl_mode <= CTRL_NONE;
			state <= RECV_DATA1;
		    end
		    
		end
		RECV_DATA1: begin
		    memory_dout <= UPLIn_Data;
		    if(ctrl_mode == CTRL_MEM_WRITE) begin
			memory_we <= 1;
		    end else begin
			memory_we <= 0;
		    end
		    if(ctrl_mode == CTRL_SET_CONFIG) begin
			frontend_id <= UPLIn_Data[127:112];
			frontend_num <= UPLIn_Data[111:96];
			round_num <= UPLIn_Data[95:80];
			qubit_id <= UPLIn_Data[79:64];
			field_len <= UPLIn_Data[63:48];
			round_unit <= UPLIn_Data[47:32];
		    end
		    if(ctrl_mode == CTRL_SET_MAC) begin
			target_dest_mac <= UPLIn_Data[127:80];
		    end
		    state <= RECV_DATA2;
		end
		RECV_DATA2: begin
		    if(UPLIn_Enable == 0) begin
			state <= WAIT_ACK;
		    end
		    memory_we <= 0;
		end
		WAIT_ACK: begin
		    if(UPLOut_Ack == 1) begin
			UPLOut_Request <= 0;
			UPLOut_Enable <= 1;
			UPLOut_Data[127:96] <= fpga_ip;
			UPLOut_Data[95:64] <= host_ip;
			UPLOut_Data[63:48] <= fpga_port;
			UPLOut_Data[47:32] <= host_port;
			UPLOut_Data[31:0] <= 32'd32; // header(16B) + data(16B)
			state <= SEND_DATA0;
		    end else begin
			UPLOut_Request <= 1;
		    end
		end
		SEND_DATA0: begin
		    UPLOut_Enable <= 1;
		    if(ctrl_mode == CTRL_SENDER_RESET) begin
			UPLOut_Data[127:104] <= 24'hE10010;
			UPLOut_Data[103:0] <= 0;
		    end else if(ctrl_mode == CTRL_MEM_WRITE) begin
			UPLOut_Data[127:104] <= 24'hE10011;
			UPLOut_Data[103:96] <= 0;
			UPLOut_Data[95:64] <= memory_addr;
			UPLOut_Data[63:32] <= 1;
			UPLOut_Data[31:0] <= 0;
		    end else if(ctrl_mode == CTRL_MEM_READ) begin
			UPLOut_Data[127:104] <= 24'hE10011;
			UPLOut_Data[103:96] <= 0;
			UPLOut_Data[95:64] <= memory_addr;
			UPLOut_Data[63:32] <= 0;
			UPLOut_Data[31:0] <= 0;
		    end else if(ctrl_mode == CTRL_SET_CONFIG) begin
			UPLOut_Data[127:104] <= 24'hE10012;
			UPLOut_Data[103:0] <= 0;
		    end else if(ctrl_mode == CTRL_SET_MAC) begin
			UPLOut_Data[127:104] <= 24'hE10013;
			UPLOut_Data[103:0] <= 0;
		    end else if(ctrl_mode == CTRL_SENDER_KICK) begin
			UPLOut_Data[127:104] <= 24'hE10014;
			UPLOut_Data[103:0] <= 0;
		    end else if(ctrl_mode == CTRL_STOP_TIMER) begin
			UPLOut_Data[127:104] <= 24'hE10015;
			UPLOut_Data[103:0] <= 0;
		    end else if(ctrl_mode == CTRL_GET_RESULT) begin
			UPLOut_Data[127:104] <= 24'hE10014;
			UPLOut_Data[103:96] <= 0;
			UPLOut_Data[95:32] <= internal_counter;
			UPLOut_Data[31:0] <= 0;
		    end else begin
			UPLOut_Data[127:104] <= 24'hE100FF;
			UPLOut_Data[103:0] <= 0;
		    end
		    state <= SEND_DATA1;
		end
		SEND_DATA1: begin
		    UPLOut_Enable <= 1;
		    if(ctrl_mode == CTRL_SENDER_RESET) begin
			UPLOut_Data <= 0;
		    end else if(ctrl_mode == CTRL_MEM_WRITE) begin
			UPLOut_Data <= memory_dout;
		    end else if(ctrl_mode == CTRL_MEM_READ) begin
			UPLOut_Data <= memory_din;
		    end else if(ctrl_mode == CTRL_SET_CONFIG) begin
			UPLOut_Data[127:112] <= frontend_id;
			UPLOut_Data[111:96] <= frontend_num;
			UPLOut_Data[95:80] <= round_num;
			UPLOut_Data[79:64] <= qubit_id;
			UPLOut_Data[63:48] <= field_len;
			UPLOut_Data[47:32] <= round_unit;
			UPLOut_Data[31:0] <= 0;
		    end else if(ctrl_mode == CTRL_SET_MAC) begin
			UPLOut_Data[127:80] <= target_dest_mac;
			UPLOut_Data[79:0] <= 0;
		    end else if(ctrl_mode == CTRL_SENDER_KICK) begin
			UPLOut_Data <= 0;
		    end else if(ctrl_mode == CTRL_STOP_TIMER) begin
			UPLOut_Data <= 0;
		    end else if(ctrl_mode == CTRL_GET_RESULT) begin
			UPLOut_Data <= 0;
		    end else begin
			UPLOut_Data <= 0;
		    end
		    state <= IDLE;
		end
	    endcase // case (state)
	end
    end

    ila_ctrl_upl_parser ila_ctrl_upl_parser_i(
					      .clk(clk),
					      .probe0(internal_counter),
					      .probe1({UPLIn_Request, UPLIn_Enable, UPLIn_Data, UPLIn_Ack}),
					      .probe2({UPLOut_Request, UPLOut_Enable, UPLOut_Data, UPLOut_Ack})
					      );

endmodule // ctrl_upl_parser


`default_nettype wire
