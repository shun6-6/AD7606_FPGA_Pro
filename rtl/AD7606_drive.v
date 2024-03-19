`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/20 18:18:15
// Design Name: 
// Module Name: AD7606_drive
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


module AD7606_drive#(
    parameter       P_RANGE = 0
)(
    input           i_clk           ,//50MHz 1 cycle = 20ns
    input           i_rst           ,
    /*------user interface------*/
    input           i_user_ctrl     ,
    output  [3 :0]  o_user_chnl     ,
    output  [15:0]  o_user_data_1   ,
    output          o_user_valid_1  ,
    output  [15:0]  o_user_data_2   ,
    output          o_user_valid_2  ,
    output  [15:0]  o_user_data_3   ,
    output          o_user_valid_3  ,
    output  [15:0]  o_user_data_4   ,
    output          o_user_valid_4  ,
    output  [15:0]  o_user_data_5   ,
    output          o_user_valid_5  ,
    output  [15:0]  o_user_data_6   ,
    output          o_user_valid_6  ,
    output  [15:0]  o_user_data_7   ,
    output          o_user_valid_7  ,
    output  [15:0]  o_user_data_8   ,
    output          o_user_valid_8  ,
    
    /*------AD7606 interface------*/
    output          o_ad_psb_sel    ,
    output          o_ad_stby       ,
    output          o_ad_range      ,
    output  [2 :0]  o_ad_osc        ,
    output          o_ad_reset      ,
    output          o_ad_convstA    ,
    output          o_ad_convstB    ,
    output          o_ad_cs         ,
    output          o_ad_rd         ,
    input           i_ad_busy       ,
    input           i_ad_firstdata  ,
    input   [15:0]  i_ad_data       
);
/******************************function***************************/

/******************************parameter**************************/
localparam      P_ST_RESET  =   0,
                P_ST_CONVST =   1,
                P_ST_BUSY   =   2,
                P_ST_READ   =   3,
                P_ST_WAIT   =   4;
/******************************port*******************************/

/******************************machine****************************/
reg  [7 :0]     r_st_cur        ;
reg  [7 :0]     r_st_nxt        ;
reg  [15:0]     r_st_cnt        ;
/******************************reg********************************/
reg             ri_user_ctrl    ;
reg  [3 :0]     ro_user_chnl    ;
reg             ro_ad_psb_sel   ;
reg             ro_ad_stby      ;
reg  [2 :0]     ro_ad_osc       ;
reg             ro_ad_reset     ;
reg             ro_ad_convstA   ;
reg             ro_ad_convstB   ;
reg             ro_ad_cs        ;
reg             ro_ad_rd        ;
reg             ro_ad_rd_1d     ;
reg             ri_ad_busy      ;
reg             ri_ad_firstdata ;
reg  [15:0]     ri_ad_data      ;

reg  [15:0]     ro_user_data_1  ;
reg             ro_user_valid_1 ;
reg  [15:0]     ro_user_data_2  ;
reg             ro_user_valid_2 ;
reg  [15:0]     ro_user_data_3  ;
reg             ro_user_valid_3 ;
reg  [15:0]     ro_user_data_4  ;
reg             ro_user_valid_4 ;
reg  [15:0]     ro_user_data_5  ;
reg             ro_user_valid_5 ;
reg  [15:0]     ro_user_data_6  ;
reg             ro_user_valid_6 ;
reg  [15:0]     ro_user_data_7  ;
reg             ro_user_valid_7 ;
reg  [15:0]     ro_user_data_8  ;
reg             ro_user_valid_8 ;

/******************************wire*******************************/

/******************************component**************************/

/******************************assign*****************************/
assign  o_user_chnl     =   ro_user_chnl    ;
assign  o_ad_psb_sel    =   ro_ad_psb_sel   ;
assign  o_ad_stby       =   ro_ad_stby      ;
assign  o_ad_range      =   P_RANGE         ;
assign  o_ad_osc        =   ro_ad_osc       ;
assign  o_ad_reset      =   ro_ad_reset     ;
assign  o_ad_convstA    =   ro_ad_convstA   ;
assign  o_ad_convstB    =   ro_ad_convstB   ;
assign  o_ad_cs         =   ro_ad_cs        ;
assign  o_ad_rd         =   ro_ad_rd        ;
 
assign  o_user_data_1   =   ro_user_data_1  ;
assign  o_user_valid_1  =   ro_user_valid_1 ;
assign  o_user_data_2   =   ro_user_data_2  ;
assign  o_user_valid_2  =   ro_user_valid_2 ;
assign  o_user_data_3   =   ro_user_data_3  ;
assign  o_user_valid_3  =   ro_user_valid_3 ;
assign  o_user_data_4   =   ro_user_data_4  ;
assign  o_user_valid_4  =   ro_user_valid_4 ;
assign  o_user_data_5   =   ro_user_data_5  ;
assign  o_user_valid_5  =   ro_user_valid_5 ;
assign  o_user_data_6   =   ro_user_data_6  ;
assign  o_user_valid_6  =   ro_user_valid_6 ;
assign  o_user_data_7   =   ro_user_data_7  ;
assign  o_user_valid_7  =   ro_user_valid_7 ;
assign  o_user_data_8   =   ro_user_data_8  ;
assign  o_user_valid_8  =   ro_user_valid_8 ; 
/******************************always*****************************/
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_st_cur <= P_ST_RESET;
    else
        r_st_cur <= r_st_nxt;
end

always @(*)begin
    case(r_st_cur)
        P_ST_RESET  : r_st_nxt = r_st_cnt == 10                 ? P_ST_CONVST   : P_ST_RESET    ;
        P_ST_CONVST : r_st_nxt = ri_user_ctrl                   ? P_ST_BUSY     : P_ST_CONVST   ;
        P_ST_BUSY   : r_st_nxt = r_st_cnt >= 10 && !ri_ad_busy  ? P_ST_READ     : P_ST_BUSY     ;
        P_ST_READ   : r_st_nxt = r_st_cnt == 16 - 1             ? P_ST_WAIT     : P_ST_READ     ;
        P_ST_WAIT   : r_st_nxt = r_st_cnt == 70                 ? P_ST_RESET    : P_ST_WAIT     ;
        default     : r_st_nxt = P_ST_RESET;
    endcase
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_st_cnt <= 'd0;
    else if(r_st_cur != r_st_nxt)
        r_st_cnt <= 'd0;
    else 
        r_st_cnt <= r_st_cnt + 1;
end
//AD7606启动信号
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ri_user_ctrl <= 'd0;
    else
        ri_user_ctrl <= i_user_ctrl;
end
//接口；类型 p并行 s串行 b字节
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_ad_psb_sel <= 'd0;
    else
        ro_ad_psb_sel <= 'd0;
end
//睡眠信号
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_ad_stby <= 'd0;
    else
        ro_ad_stby <= 'd0;
end
//过采样
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_ad_osc <= 'd0;
    else
        ro_ad_osc <= 'd0;
end
//转换忙信号，表示当前正在转换
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst) 
        ri_ad_busy      <= 'd0;
    else 
        ri_ad_busy      <= i_ad_busy     ;
end
//芯片复位信号
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_ad_reset <= 'd1;
    else if(r_st_cur == P_ST_RESET)
        ro_ad_reset <= 'd1;
    else
        ro_ad_reset <= 'd0;
end
//转换信号 A：0-3通道 B：4-7通道
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        ro_ad_convstA <= 'd1;
        ro_ad_convstB <= 'd1;
    end
    else if(r_st_cur == P_ST_CONVST)begin
        ro_ad_convstA <= 'd0;
        ro_ad_convstB <= 'd0;
    end
    else begin
        ro_ad_convstA <= 'd1;
        ro_ad_convstB <= 'd1;    
    end
end
//片选信号
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_ad_cs <= 'd1;
    else if(r_st_cur == P_ST_READ)
        ro_ad_cs <= 'd0;
    else
        ro_ad_cs <= 'd1;
end
//读数据信号，下降沿触发一次读数据
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_ad_rd <= 'd1;
    else if(r_st_cur == P_ST_READ)
        ro_ad_rd <= ~ro_ad_rd;
    else
        ro_ad_rd <= 'd1;
end

always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_ad_rd_1d <= 'd1;
    else
        ro_ad_rd_1d <= ro_ad_rd;
end
//读数据   
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ri_ad_data <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d)
        ri_ad_data <= i_ad_data;
    else
        ri_ad_data <= ri_ad_data;
end
//指示第一通道
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ri_ad_firstdata <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d)
        ri_ad_firstdata <= i_ad_firstdata;
    else
        ri_ad_firstdata <= 'd0;
end
//通道号
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        ro_user_chnl <= 'd0;
    else if(r_st_cur == P_ST_CONVST)
        ro_user_chnl <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d)
        ro_user_chnl <= ro_user_chnl + 1;
    else
        ro_user_chnl <= ro_user_chnl;
end


always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_data_1 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 0)
        ro_user_data_1 <= i_ad_data;
    else    
        ro_user_data_1 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst) 
        ro_user_data_2 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 1)
        ro_user_data_2 <= i_ad_data;
    else    
        ro_user_data_2 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_data_3 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 2)
        ro_user_data_3 <= i_ad_data;
    else    
        ro_user_data_3 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_data_4 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 3)
        ro_user_data_4 <= i_ad_data;
    else    
        ro_user_data_4 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_data_5 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 4)
        ro_user_data_5 <= i_ad_data;
    else    
        ro_user_data_5 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_data_6 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 5)
        ro_user_data_6 <= i_ad_data;
    else    
        ro_user_data_6 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_data_7 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 6)
        ro_user_data_7 <= i_ad_data;
    else    
        ro_user_data_7 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_data_8 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 7)
        ro_user_data_8 <= i_ad_data;
    else    
        ro_user_data_8 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_1 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 0)
        ro_user_valid_1 <= 'd1;
    else    
        ro_user_valid_1 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_2 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 1)
        ro_user_valid_2 <= 'd1;
    else    
        ro_user_valid_2 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_3 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 2)
        ro_user_valid_3 <= 'd1;
    else    
        ro_user_valid_3 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_4 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 3)
        ro_user_valid_4 <= 'd1;
    else    
        ro_user_valid_4 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_5 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 4)
        ro_user_valid_5 <= 'd1;
    else    
        ro_user_valid_5 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_6 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 5)
        ro_user_valid_6 <= 'd1;
    else    
        ro_user_valid_6 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_7 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 6)
        ro_user_valid_7 <= 'd1;
    else    
        ro_user_valid_7 <= 'd0;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_user_valid_8 <= 'd0;
    else if(ro_ad_rd && !ro_ad_rd_1d && ro_user_chnl == 7)
        ro_user_valid_8 <= 'd1;
    else    
        ro_user_valid_8 <= 'd0;
end

endmodule
