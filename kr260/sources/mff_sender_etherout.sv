`default_nettype none

module mff_sender_etherout
  (
   input wire clk,
   input wire reset,

   input wire ether_frame_we,
   input wire [351:0] ether_frame_din,
   /*
    (+ 48 ;; destination
       48 ;; source
       16 ;; type
       16 ;; version
       64 ;; step id
       32 ;; device id
       32 ;; #. of qubits
       32 ;; #. of info bits
       64 ;; payload (64qubits)
    );; 352
   */

   output reg [127:0] ether_out_data,
   output reg         ether_out_req,
   output reg         ether_out_en,
   input wire         ether_out_ack,

   input wire [63:0] tick_counter,

   input wire [15:0] wait_const
   );


    enum logic[7:0] {IDLE, WAIT_ACK, DATA1, DATA2, DATA3, DATA4, END_FRAME} state;
    reg [15:0] wait_counter;

    reg ether_frame_rd;
    wire ether_frame_valid;
    wire [351:0] ether_frame_dout;
    wire ether_frame_empty;
    reg [351:0] ether_frame_dout_r;

    always @(posedge clk) begin
	if (reset == 1) begin
	    state <= IDLE;
	    ether_out_req <= 0;
	    ether_out_en <= 0;
	    ether_out_data <= 0;
	    wait_counter <= wait_const;
	    ether_frame_rd <= 0;
	end else begin
	    case(state)
		IDLE: begin
		    if(ether_frame_valid == 1 && ether_frame_empty == 0 && wait_counter == 0) begin
			ether_out_req <= 1;
			state <= WAIT_ACK;
		    end else begin
			ether_out_req <= 0;
			if(wait_counter > 0) begin
			    wait_counter <= wait_counter - 1;
			end
		    end
		    ether_out_en <= 0;
		    ether_out_data <= 0;
		    ether_frame_rd <= 0;
		    ether_frame_dout_r <= ether_frame_dout;
		end
		WAIT_ACK: begin // 80bit=10B
		    if(ether_out_ack == 1) begin // 16-Bytes
			state <= DATA1;
			ether_frame_rd <= 1;
			ether_out_req <= 0;
			ether_out_en <= 1;
			ether_out_data[127:80] <= 48'd64; // (- 127 80)47, (- 127 80)47, frame length
			ether_out_data[79:32]  <= ether_frame_dout_r[351:304]; // (- 79 32)47, (- 351 304)47, dst_mac
			ether_out_data[31:0]   <= ether_frame_dout_r[303:272]; // (- 31 0)31, (- 303 272)31, src_mac[47:16]
		    end
		end
		DATA1: begin  // 128bit=16B
		    state <= DATA2;
		    ether_frame_rd <= 0;
		    ether_out_en <= 1;
		    ether_out_data[127:112] <= ether_frame_dout_r[271:256]; // (- 127 112)15, (- 271 256)15, src_mac[15:0]
		    ether_out_data[111:96]  <= ether_frame_dout_r[255:240]; // (- 111 96)15, (- 255 240)15, type[15:0]
		    ether_out_data[95:80]   <= ether_frame_dout_r[239:224]; // (- 95 80)15, (- 239 224)15, version[15:0]
		    ether_out_data[79:16]   <= ether_frame_dout_r[223:160]; // (- 79 16)63, (- 223 160)63, step_id[63:0]
		    ether_out_data[15:0]    <= ether_frame_dout_r[159:144]; // (- 15 0)15, (- 159 144)15, qubit_id[15:0]
		end
		DATA2: begin  // 128bit=16B
		    state <= DATA3;
		    ether_frame_rd <= 0;
		    ether_out_en <= 1;
		    ether_out_data[127:112] <= ether_frame_dout_r[143:128]; // (- 127 112)15, (- 143 128)15, field_len[15:0]
		    ether_out_data[111:48]  <= ether_frame_dout_r[127:64];  // (- 111 48)63, (- 127 64)63, x[63:0]
		    ether_out_data[47:0]    <= ether_frame_dout_r[63:16];   // (- 47 0)47, (- 63 16)47, z[63:16]
		end
		DATA3: begin  // 128bit=16B
		    state <= DATA4;
		    ether_frame_rd <= 0;
		    ether_out_en <= 1;
		    ether_out_data[127:112] <= ether_frame_dout_r[15:0]; // (- 127 112)15, (- 15 0)15, z[15:0]
		    ether_out_data[111:48]  <= tick_counter[63:0];
		    ether_out_data[47:0]    <= 0;
		end
		DATA4: begin  // 128bit=16B
		    state <= END_FRAME;
		    ether_frame_rd <= 0;
		    ether_out_en <= 1;
		    ether_out_data <= 0;
		end
		END_FRAME: begin
		    state <= IDLE;
		    wait_counter <= wait_const;
		    ether_frame_rd <= 0;
		    ether_out_en <= 0;
		    ether_out_data <= 0;
		end
		default: begin
		    state <= IDLE;
		    ether_out_en <= 0;
		    ether_out_req <= 0;
		    ether_out_data <= 0;
		    ether_frame_rd <= 0;
		    ether_frame_dout_r <= ether_frame_dout;
		end
	    endcase // case (state)
	end
    end // always @ (posedge clk)

    dummy_sender_frame_fifo dummy_sender_frame_fifo_i
      (
       .clk(clk),
       .srst(reset),

       .din(ether_frame_din),
       .wr_en(ether_frame_we),
       .rd_en(ether_frame_rd),
       .dout(ether_frame_dout),

       .full(),
       .empty(ether_frame_empty),
       .valid(ether_frame_valid),

       .wr_rst_busy(),
       .rd_rst_busy()
       );

    ila_mff_sender_etherout ila_mff_sender_etherout_i
      (
       .clk(clk),
       .probe0(ether_frame_we), // 1
       .probe1(ether_frame_rd), // 1
       .probe2(ether_frame_dout), // 352
       .probe3({ether_frame_empty, ether_frame_valid}), // 2
       .probe4(ether_out_data), // 128
       .probe5({ether_out_req, ether_out_en, ether_out_ack}), // 3
       .probe6({wait_counter, wait_const}) // 32
       );

endmodule // dummy_sender_etherout

`default_nettype wire
