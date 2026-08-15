`default_nettype none

module mff_receiver
  (
   input wire clk,
   input wire reset,

   input wire ether_in_req,
   input wire ether_in_en,
   input wire [127:0] ether_in_data,

   output reg mff_valid,
   output reg [47:0] dest_mac,
   output reg [47:0] src_mac,
   output reg [15:0] ether_type,
   output reg [15:0] mff_version,
   output reg [63:0] mff_step_id,
   output reg [31:0] mff_device_id,
   output reg [31:0] mff_num_of_qubits,
   output reg [31:0] mff_num_of_info,
   output reg [255:0] mff_payload
   );

    enum logic[7:0] {IDLE, DATA0, DATA1, DATA2, DATA3} state;

    logic ether_in_en_d;

    always @(posedge clk) begin

	if(reset == 1) begin
	    mff_valid <= 1'b0;
	    ether_in_en_d <= 1'b0;
	    state <= IDLE;
	end else begin
	    ether_in_en_d <= ether_in_en;
	    case(state)
		IDLE: begin
		    if(ether_in_en_d == 1'b0 && ether_in_en == 1'b1) begin
			state <= DATA0;
			dest_mac    <= ether_in_data[127:80]; // 48
			src_mac     <= ether_in_data[79:32];  // 48
			ether_type  <= ether_in_data[31:16];  // 16
			mff_version <= ether_in_data[15:0];   // 16
		    end
		    mff_valid <= 1'b0;
		end
		DATA0: begin
		    state <= DATA1;
		    mff_step_id       <= ether_in_data[127:64]; // 64
		    mff_device_id     <= ether_in_data[63:32];  // 32
		    mff_num_of_qubits <= ether_in_data[31:0];   // 32
		    mff_valid <= 1'b0;
		end
		DATA1: begin
		    state <= DATA2;
		    mff_num_of_info      <= ether_in_data[127:96]; // 32
		    mff_payload[255:160] <= ether_in_data[95:0];   // 96
		    mff_valid <= 1'b0;
		end
		DATA2: begin
		    state <= DATA3;
		    mff_payload[159:32] <= ether_in_data[127:0]; // 128
		    mff_valid <= 1'b0;
		end
		DATA3: begin
		    state <= IDLE;
		    mff_payload[31:0] <= ether_in_data[127:96]; // 32
		    mff_valid <= 1'b1;
		end
		default: begin
		    state <= IDLE;
		    mff_valid <= 1'b0;
		end
	    endcase // case (state)
	end

    end

endmodule // mff_receiver

`default_nettype wire
