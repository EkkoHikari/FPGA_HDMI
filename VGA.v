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
input wire rst, //��λ
input wire vpg_pclk, //����ʱ��
output reg vpg_de, //���������Ч�ź�
output reg vpg_hs, //��ͬ���ź�
output reg vpg_vs, //��ͬ���ź�

output reg rd_req,//����������
input wire [23:0] rd_data,//������ͼ������
output reg [23:0] rgb //���ͼ��ֵRGB888
    );
    //����Ļ�ķֱ�����ˢ���ʼ��㳡Ƶ�ʣ���Ƶ��������ʱ��Ƶ��
    parameter H_TOTAL = 96+16+640+48 - 1 ;//һ���ܹ���Ҫ������ֵ
    parameter H_SYNC = 96 - 1 ;//��ͬ������ֵ
    parameter H_START = 96+16 - 1 ;//��ͼ��������Ч��ʼ����ֵ
    parameter H_END = 96+16+640 - 1 ;//��ͼ��������Ч��������ֵ
    
    parameter V_TOTAL = 2+10+480+33 - 1 ;//���ܹ���Ҫ������ֵ
    parameter V_SYNC = 2 - 1 ;//��ͬ������ֵ
    parameter V_START = 2+10 - 1 ;//��ͼ��������Ч��ʼ����ֵ
    parameter V_END = 2+10+480 - 1 ;//��ͼ��������Ч��������ֵ
    
    parameter SQUARE_X = 256;//����Ŀ��
    parameter SQUARE_Y = 256;//����ĳ���
    parameter SCREEN_X = 640;//��Ļˮƽ����
    parameter SCREEN_Y = 480;//��Ļ��ֱ����
    
    reg [12:0] cnt_h; //�м�����
    reg [12:0] cnt_v; //��������
    parameter x=12'd192; //�������ϽǺ�����
    parameter y=12'd112; //�������Ͻ�������
    
    //PLL�����ṩ����ʱ��
    
    
    //�м�����
    always @(posedge vpg_pclk ) begin
        if (rst==1'b1) begin
            cnt_h <= 'd0;
            end
        else if (cnt_h == H_TOTAL) begin//���������ֵ������
             cnt_h <= 'd0;
            end
        else if(cnt_h != H_TOTAL) begin//��û�м��������ֵ��ÿ��ʱ�����ڼ�һ
            cnt_h <= cnt_h + 1'b1;
            end
        end

    //��������
    always @(posedge vpg_pclk ) begin
        if (rst==1'b1) begin
            cnt_v <='d0;
            end
        else if (cnt_v == V_TOTAL && cnt_h == H_TOTAL) begin//�����������������ֵ�����㣨һ֡������
            cnt_v <= 'd0;
            end
        else if(cnt_h == H_TOTAL) begin//һ��ɨ�����������������һ
            cnt_v <= cnt_v + 1'b1;
            end
        end
        
     //��ͬ���ź�
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
    
    //��ͬ���ź�(��Щ״̬��д�Ķ�����׼)
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
    
    //������Ч�ź�
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
            //ת��ΪBGR��ʽ
            rgb <= rd_data;//�������ͼ��
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
