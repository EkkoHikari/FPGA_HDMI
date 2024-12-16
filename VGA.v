`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/06 23:08:38
// Design Name: 
// Module Name: VGA
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


module VGA(
input wire rst, //复位
input wire vpg_pclk, //像素时钟
output reg vpg_de, //输出数据有效信号
output reg vpg_hs, //行同步信号
output reg vpg_vs, //场同步信号

output reg rd_req,//读数据请求
input wire [23:0] rd_data,//读出的图像数据
output reg [23:0] rgb //输出图像值RGB888
    );
    //由屏幕的分辨率与刷新率计算场频率，行频率与像素时钟频率
    parameter H_TOTAL = 96+16+640+48 - 1 ;//一行总共需要计数的值
    parameter H_SYNC = 96 - 1 ;//行同步计数值
    parameter H_START = 96+16 - 1 ;//行图像数据有效开始计数值
    parameter H_END = 96+16+640 - 1 ;//行图像数据有效结束计数值
    
    parameter V_TOTAL = 2+10+480+33 - 1 ;//场总共需要计数的值
    parameter V_SYNC = 2 - 1 ;//场同步计数值
    parameter V_START = 2+10 - 1 ;//场图像数据有效开始计数值
    parameter V_END = 2+10+480 - 1 ;//场图像数据有效结束计数值
    
    parameter SQUARE_X = 256;//方块的宽度
    parameter SQUARE_Y = 256;//方块的长度
    parameter SCREEN_X = 640;//屏幕水平长度
    parameter SCREEN_Y = 480;//屏幕垂直长度
    
    reg [12:0] cnt_h; //行计数器
    reg [12:0] cnt_v; //场计数器
    parameter x=12'd192; //方块左上角横坐标
    parameter y=12'd112; //方块左上角纵坐标
    
    //PLL例化提供像素时钟
    
    
    //行计数器
    always @(posedge vpg_pclk ) begin
        if (rst==1'b1) begin
            cnt_h <= 'd0;
            end
        else if (cnt_h == H_TOTAL) begin//计数到最大值，清零
             cnt_h <= 'd0;
            end
        else if(cnt_h != H_TOTAL) begin//还没有计数到最大值，每个时钟周期加一
            cnt_h <= cnt_h + 1'b1;
            end
        end

    //场计数器
    always @(posedge vpg_pclk ) begin
        if (rst==1'b1) begin
            cnt_v <='d0;
            end
        else if (cnt_v == V_TOTAL && cnt_h == H_TOTAL) begin//场计数器计数到最大值，清零（一帧结束）
            cnt_v <= 'd0;
            end
        else if(cnt_h == H_TOTAL) begin//一行扫描结束，场计数器加一
            cnt_v <= cnt_v + 1'b1;
            end
        end
        
     //行同步信号
     always @(posedge vpg_pclk) begin
        if(rst==1'b1) begin
            vpg_hs<=1'b1;
            end
        else if(cnt_h==H_TOTAL) begin
            vpg_hs<=1'b1;
            end
        else if(cnt_h==H_SYNC) begin
            vpg_hs<=1'b0;
            end
    end
    
    //场同步信号(这些状态机写的都不标准)
    always @(posedge vpg_pclk) begin
        if(rst==1'b1) begin
            vpg_vs<=1'b1;
            end
        else if(cnt_v==V_TOTAL && cnt_h==H_TOTAL) begin
            vpg_vs<=1'b1;
            end
        else if(cnt_v==V_SYNC && cnt_h==H_TOTAL) begin
            vpg_vs<=1'b0;
            end
    end
    
    //数据有效信号
    always @(posedge vpg_pclk) begin
        if(rst==1'b1) begin
            vpg_de<=1'b0;
            end
        else if((cnt_h>=H_START)&&(cnt_h<H_END)&&(cnt_v>=V_START)&&(cnt_v<V_END)) begin
            vpg_de<=1'b1;
            end
        else begin
            vpg_de<=1'b0;
            end
    end
    
    //----------------rd_req------------------
    always @(posedge vpg_pclk) begin
        if (rst==1'b1) begin
            rd_req <= 1'b0;
        end
        else if(cnt_h >=H_START+x-2 && cnt_h <H_START+SQUARE_X+x-2 && cnt_v >=V_START+y && cnt_v <V_START+SQUARE_Y+y)begin
            rd_req<= 1'b1;
        end
        else begin
            rd_req<= 1'b0;
        end
    end
    
    
    //rgb
    always @(posedge vpg_pclk ) begin
        if (rst==1'b1) begin
            rgb <='d0;
        end
        else if(cnt_h >=H_START+x && cnt_h <H_START+SQUARE_X+x && cnt_v >=V_START+y && cnt_v <V_START+SQUARE_Y+y)begin
            //转换为BGR格式
            rgb <= rd_data;//输出方块图像
        end
        else if (cnt_h >=H_START && cnt_h <H_END && cnt_v >=V_START && cnt_v <V_END && cnt_h[4:0]>='d20) begin
            rgb <=24'h00FF00;//green
        end
        else if (cnt_h >=H_START && cnt_h <H_END && cnt_v >=V_START && cnt_v <V_END && (cnt_h[4:0]>='d10 && cnt_h[2:0]<'d20)) begin
            rgb <=24'h0000FF;//bulue
        end
        else if (cnt_h >=H_START && cnt_h <H_END && cnt_v >=V_START && cnt_v <V_END && cnt_h[4:0]<'d10) begin
            rgb <=24'hFF0000;//red
        end
        else begin
            rgb <= 'd0;
        end
    end
endmodule
