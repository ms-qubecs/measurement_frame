`default_nettype none

module eval_latency_sender
  (
   input wire clk,
   input wire reset,
   
   input wire kick,
   output reg busy,

   input wire [47:0] destination_addr,
   input wire [47:0] source_addr,
   input wire [15:0] ether_type,
   input wire [15:0] mff_version,
   input wire [63:0] step_id,
   input wire [31:0] device_id,
   input wire [31:0] num_qubits,
   input wire [31:0] num_info_bits,

   input wire [31:0] num_of_bytes,
   input wire [63:0] tick_counter, // to evaluate latency

   // output UPL
   output reg [127:0] ether_out_data,
   output reg         ether_out_req,
   output reg         ether_out_en,
   input wire         ether_out_ack
   );


    enum logic[7:0] {IDLE, WAIT_ACK, DATA1, DATA2, DATA3, DATA4, END_FRAME} state;
    reg [15:0] wait_counter;

    logic kick_d;

    wire [31:0] payload_bytes = num_of_bytes < 24 ? 24 : num_of_bytes;
    reg [31:0] payload_bytes_r;

    reg [63:0] tick_counter_r;

    reg [47:0] destination_addr_r;
    reg [47:0] source_addr_r;
    reg [15:0] ether_type_r;
    reg [15:0] mff_version_r;
    reg [63:0] step_id_r;
    reg [31:0] device_id_r;
    reg [31:0] num_qubits_r;
    reg [31:0] num_info_bits_r;

    always @(posedge clk) begin
	if (reset == 1) begin
	    state <= IDLE;
	    kick_d <= 0;
	    ether_out_req <= 0;
	    ether_out_en <= 0;
	    busy <= 1;
	end else begin
	    kick_d <= kick;
	    case(state)
		IDLE: begin
		    busy <= 0;
		    ether_out_en <= 0;
		    ether_out_req <= 0;
		    if(kick == 1 && kick_d == 0) begin
			busy <= 1;
			state <= WAIT_ACK;
			ether_out_req <= 1;
			payload_bytes_r <= payload_bytes;

			destination_addr_r <= destination_addr;
			source_addr_r <= source_addr;
			ether_type_r <= ether_type;
			mff_version_r <= mff_version;
			step_id_r <= step_id;
			device_id_r <= device_id;
			num_qubits_r <= num_qubits;
			num_info_bits_r <= num_info_bits;
		    end
		end
		WAIT_ACK: begin
		    if(ether_out_ack == 1) begin
			ether_out_req <= 0;
			ether_out_en <= 1;
			ether_out_data[127:80] <= 36 + payload_bytes_r + 4; // (+ (/ (+ 48 48 16 16 64 32 32 32) 8.0) 24 4)
                                                                          // (+ header data_bytes fcs)
			ether_out_data[79:32] <= destination_addr_r;
			ether_out_data[31:0] <= source_addr_r[47:16];
			state <= DATA1;
			tick_counter_r <= tick_counter;
		    end
		end
		DATA1: begin
		    ether_out_en <= 1;
		    ether_out_data[127:112] <= source_addr_r[15:0];
		    ether_out_data[111:96]  <= ether_type_r;
		    ether_out_data[95:80]   <= mff_version_r;
		    ether_out_data[79:16]   <= step_id_r;
		    ether_out_data[15:0]    <= device_id_r[31:16];
		    state <= DATA2;
		end
		DATA2: begin
		    ether_out_en <= 1;
		    ether_out_data[127:112] <= device_id_r[15:0];
		    ether_out_data[111:80]  <= num_qubits_r;
		    ether_out_data[79:48] <= num_info_bits_r;
		    ether_out_data[47:0] <= tick_counter_r[63:16]; // 6 Bytes
		    state <= DATA3;
		end
		DATA3: begin
		    ether_out_en <= 1;
		    ether_out_data[127:112] <= tick_counter_r[15:0]; // 2 Bytes
		    ether_out_data[111:0]  <= 112'd0; // 14 Bytes
		    payload_bytes_r <= payload_bytes_r - (6+2+14); // payload_bytes_r is lager than 22
		    state <= DATA4;
		end
		DATA4: begin
		    ether_out_en <= 1;
		    ether_out_data <= 128'd0; // 16 Bytes
		    if(payload_bytes_r > 16) begin
			payload_bytes_r <= payload_bytes_r - 16;
		    end else begin
			state <= END_FRAME;
		    end
		end
		END_FRAME: begin
		    ether_out_en <= 0;
		    state <= IDLE;
		end
		default: begin
		    state <= IDLE;
		    ether_out_req <= 0;
		    ether_out_en <= 0;
		end
	    endcase // case (state)
	end
    end

endmodule // eval_latency_sender

`default_nettype wire
