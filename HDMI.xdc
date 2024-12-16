############## clock define##################
create_clock -period 20.000 [get_ports clk]
set_property PACKAGE_PIN N18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

############## key define##################
set_property PACKAGE_PIN P16 [get_ports rst_hdmi]
set_property IOSTANDARD LVCMOS33 [get_ports rst_hdmi]

set_property PACKAGE_PIN U18 [get_ports hdmi_tx_clk_p]
set_property PACKAGE_PIN V20 [get_ports hdmi_tx_chn_b_p]
set_property PACKAGE_PIN T20 [get_ports hdmi_tx_chn_g_p]
set_property PACKAGE_PIN N20 [get_ports hdmi_tx_chn_r_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_chn_r_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_chn_g_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_chn_b_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_clk_p]

set_property PACKAGE_PIN U19 [get_ports hdmi_tx_clk_n]
set_property PACKAGE_PIN W20 [get_ports hdmi_tx_chn_b_n]
set_property PACKAGE_PIN U20 [get_ports hdmi_tx_chn_g_n]
set_property PACKAGE_PIN P20 [get_ports hdmi_tx_chn_r_n]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_chn_r_n]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_chn_g_n]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_chn_b_n]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_clk_n]

#set_property PACKAGE_PIN Y19 [get_ports clk1x]
#set_property PACKAGE_PIN P18 [get_ports clk5x]
#set_property PACKAGE_PIN R17 [get_ports vpg_de]
#set_property PACKAGE_PIN U17 [get_ports vpg_hs]
#set_property PACKAGE_PIN W19 [get_ports vpg_vs]

#set_property IOSTANDARD LVCMOS33 [get_ports clk1x]
#set_property IOSTANDARD LVCMOS33 [get_ports clk5x]
#set_property IOSTANDARD LVCMOS33 [get_ports vpg_de]
#set_property IOSTANDARD LVCMOS33 [get_ports vpg_hs]
#set_property IOSTANDARD LVCMOS33 [get_ports vpg_vs]
