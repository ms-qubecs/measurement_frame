`default_nettype none

module resetgen#(parameter RESET_NUM = 3700*1000)
    (
     input wire clk,
     input wire reset_n,
     output wire reset_out
     );

    reg reset_reg = 1;
    reg [22:0] reset_cnt = 0;

    assign reset_out = reset_reg;

    always @(posedge clk) begin
	if(reset_n == 0) begin
	    reset_cnt <= 0;
	end else if(reset_cnt <= RESET_NUM + 100) begin
            reset_cnt <= reset_cnt + 1;
	end else begin
            reset_cnt <= reset_cnt;
	end
    end

    always @(posedge clk) begin
	if(reset_n == 0) begin
	    reset_reg <= 1;
	end else if(reset_cnt <= RESET_NUM) begin
            reset_reg <= 1;
	end else begin
            reset_reg <= 0;
	end
    end

endmodule // resetgen

`default_nettype wire

