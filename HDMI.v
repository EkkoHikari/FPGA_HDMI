`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/07 19:01:54
// Design Name: 
// Module Name: HDMI
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


module HDMI(
input wire clk,
input wire rst_hdmi,

//output wire clk1x,
//output wire clk5x,
//output wire vpg_de,
//output wire vpg_hs,
//output wire vpg_vs,
//output wire [23:0] rd_data,
//output wire rd_req,
output wire hdmi_tx_clk_n,
output wire hdmi_tx_clk_p,
output wire hdmi_tx_chn_r_n,
output wire hdmi_tx_chn_r_p,
output wire hdmi_tx_chn_g_n,
output wire hdmi_tx_chn_g_p,
output wire hdmi_tx_chn_b_n,
output wire hdmi_tx_chn_b_p	
    );

wire rst;
wire locked;
wire clk1x;
wire clk5x;

wire [7:0] rgb_r;
wire [7:0] rgb_g;
wire [7:0] rgb_b;
wire vpg_de;
wire vpg_hs;
wire vpg_vs;

wire [23:0] rd_data;
wire rd_req;

    assign rst = ~locked;

	PLL_Clock_HDMI clock(
			// Clock out ports
			.clk_out1(clk1x),     // output clk_out1
			.clk_out2(clk5x),     // output clk_out2
			// Status and control signals
			.resetn(rst_hdmi), 		// input reset
			.locked(locked),       	// output locked
			// Clock in ports
			.clk_in1(clk) 		 // input clk_in1
	);     

	VGA  vga(
			.rst      (rst),
			.vpg_pclk (clk1x),
			.vpg_de   (vpg_de),
			.vpg_hs   (vpg_hs),
			.vpg_vs   (vpg_vs),
			.rd_data  (rd_data),
			.rd_req   (rd_req),
			.rgb    ({rgb_r,rgb_g,rgb_b})
		);
    
    rd_image rd_image (
			.clk     (clk1x),
			.rst     (rst),
			.rd_req  (rd_req),
			.rd_data (rd_data)
		);
		
     hdmi_trans hdmi_trans(
			.clk1x           (clk1x),
			.clk5x           (clk5x),
			.rst             (rst),
			.image_r         (rgb_r),
			.image_g         (rgb_g),
			.image_b         (rgb_b),
			.vsync           (vpg_vs),
			.hsync           (vpg_hs),
			.de              (vpg_de),
			.hdmi_tx_clk_n   (hdmi_tx_clk_n),
			.hdmi_tx_clk_p   (hdmi_tx_clk_p),
			.hdmi_tx_chn_r_n (hdmi_tx_chn_r_n),
			.hdmi_tx_chn_r_p (hdmi_tx_chn_r_p),
			.hdmi_tx_chn_g_n (hdmi_tx_chn_g_n),
			.hdmi_tx_chn_g_p (hdmi_tx_chn_g_p),
			.hdmi_tx_chn_b_n (hdmi_tx_chn_b_n),
			.hdmi_tx_chn_b_p (hdmi_tx_chn_b_p)
		);
endmodule
