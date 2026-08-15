`default_nettype none

module mff_sender
  (
   input wire clk,
   input wire reset,

   input wire [63:0] mff_sender_mask,

   input wire mff_sender_reset,
   
   input wire mff_sender_mem_we,
   input wire [6:0] mff_sender_mem_addr,
   input wire [63:0] mff_sender_mem_wdata,
   output wire [63:0] mff_sender_mem_rdata,

   input wire [47:0] mff_sender_dest_mac,
   input wire [15:0] mff_sender_device_id,
   input wire [15:0] mff_sender_num_qubits,
   input wire [15:0] mff_sender_num_info,
   input wire [15:0] mff_sender_round_num,

   input wire mff_sender_kick,
   output reg mff_sender_busy,

   output wire [127:0] ether_out_data,
   output wire         ether_out_req,
   output wire         ether_out_en,
   input  wire         ether_out_ack,

   input wire [63:0] tick_counter,
   input wire [15:0] wait_const,
   input wire [15:0] sender_measure_wait_const,
   input wire [47:0] BASE_SRC_MAC_ADDRESS // 48'hFC_E4_98_10_00_01
   );

    enum logic[7:0] {GEN_IDLE, DATA_PRE0, DATA_PRE1, DATA_GEN, PACKET_GEN, PACKET_PUT, MFF_MEASURE_WAIT} gen_state;
    reg mff_sender_kick_d;
    reg [15:0] mff_sender_round_counter;
    reg [63:0] mff_sender_mask_r;
    reg [63:0] step_id_counter;

    reg ether_frame_we;

    reg [351:0] ether_frame_din;
    reg ether_frame_rd;
    wire [351:0] ether_frame_dout;
    wire ether_frame_empty;
    wire ether_frame_valid;

    reg [47:0] dest_mac;
    reg [47:0] src_mac;
    reg [15:0] ether_header_type;
    reg [15:0] ether_version;
    reg [63:0] step_id;
    reg [31:0] device_id;
    reg [31:0] num_qubits;
    reg [31:0] num_info;
    reg [63:0] data_payload;

    reg [31:0] mem_addr;
    wire [63:0] mem_dout;
    reg [63:0] mem_dout_r;

    reg [15:0] mff_measure_wait_counter;

    always @(posedge clk) begin
	if(reset == 1 || mff_sender_reset == 1) begin
	    gen_state <= GEN_IDLE;
	    mff_sender_kick_d <= 0;
	    mff_sender_busy <= 0;
	    mem_addr <= 0;

	    ether_frame_we <= 0;
	    step_id_counter <= 0;
	end else begin
	    mff_sender_kick_d <= mff_sender_kick;
	    mff_sender_mask_r <= mff_sender_mask;
	    case(gen_state)
		GEN_IDLE: begin
		    if(
		       mff_sender_kick == 1 &&
		       mff_sender_kick_d == 0 &&
		       mff_sender_round_num > 0
		       ) begin
			gen_state <= DATA_PRE0;
			mff_sender_busy <= 1;
		    end else begin
			mff_sender_busy <= 0;
		    end
		    ether_frame_we <= 0;
		    mff_sender_round_counter <= 0;
		    mem_addr <= 0;
		end
		DATA_PRE0: begin
		    gen_state <= DATA_PRE1;
		    ether_frame_we <= 0;
		end
		DATA_PRE1: begin
		    gen_state <= DATA_GEN;
		    ether_frame_we <= 0;

		    mem_dout_r <= mem_dout[63:0];
		    mem_addr <= mem_addr+1; // ready for next
		end
		DATA_GEN: begin
		    gen_state <= PACKET_GEN;
		    ether_frame_we <= 0;
		end
		PACKET_GEN: begin
		    gen_state <= PACKET_PUT;
		    ether_frame_we <= 0;
		    dest_mac <= mff_sender_dest_mac;
		    src_mac <= BASE_SRC_MAC_ADDRESS;
		    ether_header_type <= 16'h3434;
		    ether_version <= 16'h0002;
		    step_id <= step_id_counter;
		    device_id <= {16'h0000, mff_sender_device_id};
		    num_qubits <= {16'h0000, mff_sender_num_qubits};
		    num_info <= {16'h0000, mff_sender_num_info};
		    data_payload <= mem_dout_r & mff_sender_mask_r;
		end
		PACKET_PUT: begin
		    ether_frame_din <= {
					dest_mac,          // 48bit
					src_mac,           // 48bit
					ether_header_type, // 16bit
					ether_version,     // 16bit
					step_id,           // 64bit
					device_id,         // 32bit,
					num_qubits,        // 32bit,
					num_info,          // 32bit
					data_payload       // 64bit
					}; // (+ 48 48 16 16 64 32 32 32 64);; 352
		    ether_frame_we <= 1;

		    if(mff_sender_round_counter + 1 < mff_sender_round_num) begin
			mff_sender_round_counter <= mff_sender_round_counter + 1;
			mff_measure_wait_counter <= sender_measure_wait_const;
			gen_state <= MFF_MEASURE_WAIT;
		    end else begin
			gen_state <= GEN_IDLE;
		    end
		    step_id_counter <= step_id_counter + 1;
		end
		MFF_MEASURE_WAIT: begin
		    ether_frame_we <= 0;
		    if(mff_measure_wait_counter == 0) begin
			gen_state <= DATA_PRE1;
		    end else begin
			mff_measure_wait_counter <= mff_measure_wait_counter - 1;
		    end
                end
		default: begin
		    ether_frame_we <= 0;
		    mff_sender_round_counter <= 0;
		    mem_addr <= 0;
		    gen_state <= GEN_IDLE;
		end
	    endcase // case (gen_state)
	end
    end

    dummy_sender_storage dummy_sender_storage_i
      (
       .clka(clk),
       .ena(1),
       .wea(mff_sender_mem_we),
       .addra(mff_sender_mem_addr[6:0]),
       .dina(mff_sender_mem_wdata[63:0]),
       .douta(mff_sender_mem_rdata[63:0]),
       .clkb(clk),
       .enb(1),
       .web(0),
       .addrb(mem_addr[6:0]),
       .dinb(0),
       .doutb(mem_dout[63:0])
       );

    ila_mff_sender ila_mff_sender_i(
				    .clk(clk),
				    .probe0(mff_sender_kick),
				    .probe1(mff_sender_kick_d),
				    .probe2(mff_sender_busy)
				    );

    mff_sender_etherout mff_sender_etherout_i
      (
       .clk(clk),
       .reset(reset),

       .ether_frame_we(ether_frame_we),
       .ether_frame_din(ether_frame_din),

       .ether_out_data(ether_out_data),
       .ether_out_req(ether_out_req),
       .ether_out_en(ether_out_en),
       .ether_out_ack(ether_out_ack),

       .tick_counter(tick_counter),
       .wait_const(wait_const)
       );

endmodule // mff_sender


`default_nettype wire
