# FPGA_HDMI
开发平台：Vivado

开发语言：Verilog HDL

硬件平台：MicroPhase Z7-Lite 7010

分辨率：640*480@60Hz

ip核配置：

1. PLL：输入50MHz时钟，输出2个时钟，一个像素时钟25.175MHz,一个五倍于像素时钟125.875MHz
  
2. ROM：初始化加载COE文件
