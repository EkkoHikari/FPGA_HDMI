`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/07 23:53:05
// Design Name: 
// Module Name: rd_image
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rd_image(
	input 	wire 			clk 	,
	input	wire 			rst 	,
	input	wire 			rd_req	,
	output	wire	[23:0]	rd_data 
    );


//==========================================
//parameter define
//==========================================
parameter 	STOP_ADDR 	= 256*256 - 1;

reg 	[15:0]		rd_addr 	;
wire	[23:0]		dout 		;

assign rd_data = dout;
//----------------rd_addr------------------
always @(posedge clk) begin
	if (rst==1'b1) begin
		rd_addr <= 'd0;
	end
	else if(rd_req==1'b1 )begin 
		if(rd_addr == STOP_ADDR)begin
			rd_addr <= 'd0;
		end
		else begin
			rd_addr <= rd_addr + 1'b1;
		end
	end
end


rom_image rom (
  .clka(clk),    // input wire clka
  .addra(rd_addr),  // input wire [15 : 0] addra
  .douta(dout)  // output wire [23 : 0] douta
);
endmodule

