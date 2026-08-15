`default_nettype none

module config_memory_wrapper(
			     input wire clk,
			     input wire reset,
			     
			     output wire [31:0] MYIPADDR0_o,
			     output wire [31:0] MYNETMASK0_o,
			     output wire [31:0] MYDEFAULTGATEWAY0_o,
			     output wire [31:0] MYTARGETIPADDR0_o,
			     output wire [47:0] MYMACADDR0_o,

			     output wire [31:0] MYIPADDR1_o,
			     output wire [31:0] MYNETMASK1_o,
			     output wire [31:0] MYDEFAULTGATEWAY1_o,
			     output wire [31:0] MYTARGETIPADDR1_o,
			     output wire [47:0] MYMACADDR1_o,

			     output wire [31:0] MYIPADDR2_o,
			     output wire [31:0] MYNETMASK2_o,
			     output wire [31:0] MYDEFAULTGATEWAY2_o,
			     output wire [31:0] MYTARGETIPADDR2_o,
			     output wire [47:0] MYMACADDR2_o,

			     output wire [31:0] MYIPADDR3_o,
			     output wire [31:0] MYNETMASK3_o,
			     output wire [31:0] MYDEFAULTGATEWAY3_o,
			     output wire [31:0] MYTARGETIPADDR3_o,
			     output wire [47:0] MYMACADDR3_o,

			     output wire [31:0] MYIPADDR4_o,
			     output wire [31:0] MYNETMASK4_o,
			     output wire [31:0] MYDEFAULTGATEWAY4_o,
			     output wire [31:0] MYTARGETIPADDR4_o,
			     output wire [47:0] MYMACADDR4_o,

			     output wire [31:0] MYIPADDR5_o,
			     output wire [31:0] MYNETMASK5_o,
			     output wire [31:0] MYDEFAULTGATEWAY5_o,
			     output wire [31:0] MYTARGETIPADDR5_o,
			     output wire [47:0] MYMACADDR5_o,

			     output wire [31:0] MYIPADDR6_o,
			     output wire [31:0] MYNETMASK6_o,
			     output wire [31:0] MYDEFAULTGATEWAY6_o,
			     output wire [31:0] MYTARGETIPADDR6_o,
			     output wire [47:0] MYMACADDR6_o,

			     output wire [31:0] MYIPADDR7_o,
			     output wire [31:0] MYNETMASK7_o,
			     output wire [31:0] MYDEFAULTGATEWAY7_o,
			     output wire [31:0] MYTARGETIPADDR7_o,
			     output wire [47:0] MYMACADDR7_o
			     );
    
    reg [31:0] myipaddr0 = 32'h0a0300f0;
    reg [31:0] mynetmask0 = 32'hff000000;
    reg [31:0] mydefaultgateway0 = 32'h0a000001;
    reg [31:0] mytargetipaddr0 = 32'h0a000001;
    reg [47:0] mymacaddr0 = 48'h001b1affff00;

    reg [31:0] myipaddr1 = 32'h0a0400ff;
    reg [31:0] mynetmask1 = 32'hff000000;
    reg [31:0] mydefaultgateway1 = 32'h0a000001;
    reg [31:0] mytargetipaddr1 = 32'h0a000001;
    reg [47:0] mymacaddr1 = 48'h001b1affff01;

    reg [31:0] myipaddr2 = 32'h0aff00ff;
    reg [31:0] mynetmask2 = 32'hff000000;
    reg [31:0] mydefaultgateway2 = 32'h0a000001;
    reg [31:0] mytargetipaddr2 = 32'h0a000001;
    reg [47:0] mymacaddr2 = 48'h001b1affff02;

    reg [31:0] myipaddr3 = 32'h0afe00ff;
    reg [31:0] mynetmask3 = 32'hff000000;
    reg [31:0] mydefaultgateway3 = 32'h0a000001;
    reg [31:0] mytargetipaddr3 = 32'h0a000001;
    reg [47:0] mymacaddr3 = 48'h001b1affff03;

    assign MYIPADDR0_o = myipaddr0;
    assign MYNETMASK0_o = mynetmask0;
    assign MYDEFAULTGATEWAY0_o = mydefaultgateway0;
    assign MYTARGETIPADDR0_o = mytargetipaddr0;
    assign MYMACADDR0_o = mymacaddr0;

    assign MYIPADDR1_o = myipaddr1;
    assign MYNETMASK1_o = mynetmask1;
    assign MYDEFAULTGATEWAY1_o = mydefaultgateway1;
    assign MYTARGETIPADDR1_o = mytargetipaddr1;
    assign MYMACADDR1_o = mymacaddr1;

    assign MYIPADDR2_o = myipaddr2;
    assign MYNETMASK2_o = mynetmask2;
    assign MYDEFAULTGATEWAY2_o = mydefaultgateway2;
    assign MYTARGETIPADDR2_o = mytargetipaddr2;
    assign MYMACADDR2_o = mymacaddr2;

    assign MYIPADDR3_o = myipaddr3;
    assign MYNETMASK3_o = mynetmask3;
    assign MYDEFAULTGATEWAY3_o = mydefaultgateway3;
    assign MYTARGETIPADDR3_o = mytargetipaddr3;
    assign MYMACADDR3_o = mymacaddr3;

    reg [31:0] myipaddr4 = 32'h0afd00ff;
    reg [31:0] mynetmask4 = 32'hff000000;
    reg [31:0] mydefaultgateway4 = 32'h0a000001;
    reg [31:0] mytargetipaddr4 = 32'h0a000001;
    reg [47:0] mymacaddr4 = 48'h001b1affff04;

    reg [31:0] myipaddr5 = 32'h0afc00ff;
    reg [31:0] mynetmask5 = 32'hff000000;
    reg [31:0] mydefaultgateway5 = 32'h0a000001;
    reg [31:0] mytargetipaddr5 = 32'h0a000001;
    reg [47:0] mymacaddr5 = 48'h001b1affff05;

    reg [31:0] myipaddr6 = 32'h0afb00ff;
    reg [31:0] mynetmask6 = 32'hff000000;
    reg [31:0] mydefaultgateway6 = 32'h0a000001;
    reg [31:0] mytargetipaddr6 = 32'h0a000001;
    reg [47:0] mymacaddr6 = 48'h001b1affff06;

    reg [31:0] myipaddr7 = 32'h0afa00ff;
    reg [31:0] mynetmask7 = 32'hff000000;
    reg [31:0] mydefaultgateway7 = 32'h0a000001;
    reg [31:0] mytargetipaddr7 = 32'h0a000001;
    reg [47:0] mymacaddr7 = 48'h001b1affff07;

    assign MYIPADDR4_o = myipaddr4;
    assign MYNETMASK4_o = mynetmask4;
    assign MYDEFAULTGATEWAY4_o = mydefaultgateway4;
    assign MYTARGETIPADDR4_o = mytargetipaddr4;
    assign MYMACADDR4_o = mymacaddr4;

    assign MYIPADDR5_o = myipaddr5;
    assign MYNETMASK5_o = mynetmask5;
    assign MYDEFAULTGATEWAY5_o = mydefaultgateway5;
    assign MYTARGETIPADDR5_o = mytargetipaddr5;
    assign MYMACADDR5_o = mymacaddr5;

    assign MYIPADDR6_o = myipaddr6;
    assign MYNETMASK6_o = mynetmask6;
    assign MYDEFAULTGATEWAY6_o = mydefaultgateway6;
    assign MYTARGETIPADDR6_o = mytargetipaddr6;
    assign MYMACADDR6_o = mymacaddr6;

    assign MYIPADDR7_o = myipaddr7;
    assign MYNETMASK7_o = mynetmask7;
    assign MYDEFAULTGATEWAY7_o = mydefaultgateway7;
    assign MYTARGETIPADDR7_o = mytargetipaddr7;
    assign MYMACADDR7_o = mymacaddr7;

    (* keep *) reg [31:0] VERSION = 32'h20220929;

    (* keep *) reg [9:0] addra;
    wire [31:0] douta;
    config_memory config_memory_i (
				   .clka(clk),    // input wire clka
				   .ena(1),      // input wire ena
				   .wea(0),      // input wire [0 : 0] wea
				   .addra(addra),  // input wire [3 : 0] addra
				   .dina(0),    // input wire [31 : 0] dina
				   .douta(douta)  // output wire [31 : 0] douta
				   );
    (* keep *) reg [7:0] config_status = 0;
    always @(posedge clk) begin
	if(reset == 1) begin
	    addra <= 0;
	    config_status <= 0;
	end else begin
	    case(config_status)
		0: begin
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		1: begin
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////
      
		2: begin
		    if(douta != 32'h00000000) begin
			myipaddr0 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		3: begin
		    if(douta != 32'h00000000) begin
			mynetmask0 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		4: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway0 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		5: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr0 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		6: begin
		    if(douta != 32'h00000000) begin
			mymacaddr0[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		7: begin
		    if(douta != 32'h00000000) begin
			mymacaddr0[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		///////////////////////////////////////////////////
      
		8: begin
		    if(douta != 32'h00000000) begin
			myipaddr1 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		9: begin
		    if(douta != 32'h00000000) begin
			mynetmask1 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		10: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway1 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		11: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr1 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		12: begin
		    if(douta != 32'h00000000) begin
			mymacaddr1[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		13: begin
		    if(douta != 32'h00000000) begin
			mymacaddr1[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		///////////////////////////////////////////////////

		14: begin
		    if(douta != 32'h00000000) begin
			myipaddr2 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		15: begin
		    if(douta != 32'h00000000) begin
			mynetmask2 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		16: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway2 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		17: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr2 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		18: begin
		    if(douta != 32'h00000000) begin
			mymacaddr2[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		19: begin
		    if(douta != 32'h00000000) begin
			mymacaddr2[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		///////////////////////////////////////////////////

		20: begin
		    if(douta != 32'h00000000) begin
			myipaddr3 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		21: begin
		    if(douta != 32'h00000000) begin
			mynetmask3 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		22: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway3 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		23: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr3 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		24: begin
		    if(douta != 32'h00000000) begin
			mymacaddr3[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		25: begin
		    if(douta != 32'h00000000) begin
			mymacaddr3[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		///////////////////////////////////////////////////

		26: begin
		    if(douta != 32'h00000000) begin
			myipaddr4 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		27: begin
		    if(douta != 32'h00000000) begin
			mynetmask4 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		28: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway4 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		29: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr4 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		30: begin
		    if(douta != 32'h00000000) begin
			mymacaddr4[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		31: begin
		    if(douta != 32'h00000000) begin
			mymacaddr4[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		///////////////////////////////////////////////////

		32: begin
		    if(douta != 32'h00000000) begin
			myipaddr5 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		33: begin
		    if(douta != 32'h00000000) begin
			mynetmask5 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		34: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway5 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		35: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr5 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		36: begin
		    if(douta != 32'h00000000) begin
			mymacaddr5[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		37: begin
		    if(douta != 32'h00000000) begin
			mymacaddr5[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		///////////////////////////////////////////////////

		38: begin
		    if(douta != 32'h00000000) begin
			myipaddr6 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		39: begin
		    if(douta != 32'h00000000) begin
			mynetmask6 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		40: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway6 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		41: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr6 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		42: begin
		    if(douta != 32'h00000000) begin
			mymacaddr6[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		43: begin
		    if(douta != 32'h00000000) begin
			mymacaddr6[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		///////////////////////////////////////////////////

		44: begin
		    if(douta != 32'h00000000) begin
			myipaddr7 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		45: begin
		    if(douta != 32'h00000000) begin
			mynetmask7 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		46: begin
		    if(douta != 32'h00000000) begin
			mydefaultgateway7 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		47: begin
		    if(douta != 32'h00000000) begin
			mytargetipaddr7 <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		48: begin
		    if(douta != 32'h00000000) begin
			mymacaddr7[47:16] <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		49: begin
		    if(douta != 32'h00000000) begin
			mymacaddr7[15:0] <= douta[31:16];
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end
		50: begin
		    if(douta != 32'h00000000) begin
			VERSION <= douta;
		    end
		    config_status <= config_status + 1;
		    addra <= addra + 1;
		end

		///////////////////////////////////////////////////

		default: begin
                    if(addra != 0) addra <= addra + 1;
		end
	    endcase // case (config_status)
	end
    end

    ila_config_memory ila_config_memory_i(.clk(clk),
					  .probe0(myipaddr0),
					  .probe1(mynetmask0),
					  .probe2(mydefaultgateway0),
					  .probe3(mytargetipaddr0),
					  .probe4(mymacaddr0),
					  .probe5(addra),
					  .probe6(config_status),
					  .probe7(myipaddr1),
					  .probe8(mynetmask1),
					  .probe9(mydefaultgateway1),
					  .probe10(mytargetipaddr1),
					  .probe11(mymacaddr1),
					  .probe12(myipaddr4),
					  .probe13(mynetmask4),
					  .probe14(mydefaultgateway4),
					  .probe15(mytargetipaddr4),
					  .probe16(mymacaddr4),
					  .probe17(VERSION)
					  );

endmodule // config_memory_wrapper

`default_nettype wire
