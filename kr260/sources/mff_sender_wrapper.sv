`default_nettype none

module mff_sender_wrapper
  (
   input wire clk,
   input wire reset,

   input wire UPLIn_Request,
   input wire UPLIn_Enable,
   input wire [127:0] UPLIn_Data,
   output wire UPLIn_Ack,

   output wire UPLOut_Request,
   output wire UPLOut_Enable,
   output wire [127:0] UPLOut_Data,
   input  wire UPLOut_Ack,

   output wire [127:0] ether_out_data,
   output wire ether_out_req,
   output wire ether_out_en,
   input  wire ether_out_ack,
   
   output wire ctrl_upl_all_reset_kick,

   input wire [63:0] tick_counter,

   input wire [15:0] wait_const,
   input wire [15:0] sender_measure_wait_const,
   input wire [47:0] BASE_SRC_MAC_ADDRESS
 );

    wire ctrl_upl_mff_sender_reset;
    wire ctrl_upl_mff_sender_kick;
    wire ctrl_upl_mff_sender_busy;
    wire [31:0] ctrl_upl_memory_addr;
    wire [127:0] ctrl_upl_memory_dout;
    wire ctrl_upl_memory_we;
    wire [127:0] ctrl_upl_memory_din;
    wire [15:0] ctrl_upl_frontend_id;
    wire [15:0] ctrl_upl_frontend_num;
    wire [15:0] ctrl_upl_round_num;
    wire [15:0] ctrl_upl_qubit_id;
    wire [15:0] ctrl_upl_field_len;
    wire [15:0] ctrl_upl_round_unit;
    wire [47:0] ctrl_upl_target_dest_mac;

    ctrl_upl_parser ctrl_upl_parser_i (
				       .clk  (clk),
				       .reset(reset),

				       .UPLIn_Request(UPLIn_Request),
				       .UPLIn_Enable (UPLIn_Enable),
				       .UPLIn_Data   (UPLIn_Data),
				       .UPLIn_Ack    (UPLIn_Ack),

				       .UPLOut_Request(UPLOut_Request),
				       .UPLOut_Enable (UPLOut_Enable),
				       .UPLOut_Data   (UPLOut_Data),
				       .UPLOut_Ack    (UPLOut_Ack),

				       .all_reset_kick(ctrl_upl_all_reset_kick),

				       .dummy_sender_reset(ctrl_upl_mff_sender_reset),
				       .dummy_sender_kick(ctrl_upl_mff_sender_kick),

				       .memory_addr(ctrl_upl_memory_addr),
				       .memory_dout(ctrl_upl_memory_dout),
				       .memory_we  (ctrl_upl_memory_we),
				       .memory_din (ctrl_upl_memory_din),

				       .frontend_id (ctrl_upl_frontend_id),
				       .frontend_num(ctrl_upl_frontend_num),
				       .round_num   (ctrl_upl_round_num),
				       .qubit_id    (ctrl_upl_qubit_id),
				       .field_len   (ctrl_upl_field_len),
				       .round_unit  (ctrl_upl_round_unit),

				       .target_dest_mac(ctrl_upl_target_dest_mac)
				       );

    wire [63:0] mff_sender_mask = 64'hFFFFFFFF_FFFFFFFF;

    mff_sender mff_sender_i(
			    .clk(clk),
			    .reset(reset),
			    
			    .mff_sender_mask(mff_sender_mask),
			    
			    .mff_sender_reset(ctrl_upl_mff_sender_reset),
			    
			    .mff_sender_mem_we   (ctrl_upl_memory_we),
			    .mff_sender_mem_addr (ctrl_upl_memory_addr[6:0]),
			    .mff_sender_mem_wdata(ctrl_upl_memory_dout[127:64]),
			    .mff_sender_mem_rdata(ctrl_upl_memory_din[127:64]),

			    .mff_sender_dest_mac(ctrl_upl_target_dest_mac),
			    .mff_sender_device_id(ctrl_upl_frontend_id),
			    .mff_sender_num_qubits(ctrl_upl_frontend_num),
			    .mff_sender_num_info(ctrl_upl_field_len),
			    .mff_sender_round_num(ctrl_upl_round_num),

			    .mff_sender_kick(ctrl_upl_mff_sender_kick),
			    .mff_sender_busy(ctrl_upl_mff_sender_busy),
			    
			    .ether_out_data(ether_out_data),
			    .ether_out_req(ether_out_req),
			    .ether_out_en(ether_out_en),
			    .ether_out_ack(ether_out_ack),
			    
			    .tick_counter(tick_counter),
			    .wait_const(wait_const),
			    .sender_measure_wait_const(sender_measure_wait_const),
			    .BASE_SRC_MAC_ADDRESS(BASE_SRC_MAC_ADDRESS)
			    );

    ila_mff_sender_wrapper ila_mff_sender_wrapper_i(
							.clk(clk),
							.probe0(ctrl_upl_mff_sender_reset), // 1
							.probe1(ctrl_upl_mff_sender_kick), // 1
							.probe2(ctrl_upl_mff_sender_busy), // 1
							.probe3(ctrl_upl_memory_addr), // 32
							.probe4(ctrl_upl_memory_dout), // 128
							.probe5(ctrl_upl_memory_we), // 1
							.probe6(ctrl_upl_memory_din), // 128
							.probe7(ctrl_upl_frontend_id), // 16
							.probe8(ctrl_upl_frontend_num), // 16
							.probe9(ctrl_upl_round_num), // 16
							.probe10(ctrl_upl_qubit_id), // 16
							.probe11(ctrl_upl_field_len), // 16
							.probe12(ctrl_upl_round_unit), // 16
							.probe13(ctrl_upl_target_dest_mac) // 48
							);

endmodule // mff_sender_wrapper

`default_nettype wire
