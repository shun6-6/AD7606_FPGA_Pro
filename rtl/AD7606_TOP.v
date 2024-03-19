`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/21 21:57:30
// Design Name: 
// Module Name: AD7606_TOP
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


module AD7606_TOP(
    input           clk             ,

    // output          o_ad_psb_sel    ,
    // output          o_ad_stby       ,
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

wire        w_clk_50mhz    ;
wire        locked         ;

wire        w_user_ctrl    ;
wire [3 :0] w_user_chnl    ;
wire [15:0] w_user_data_1  ;
wire        w_user_valid_1 ;
wire [15:0] w_user_data_2  ;
wire        w_user_valid_2 ;
wire [15:0] w_user_data_3  ;
wire        w_user_valid_3 ;
wire [15:0] w_user_data_4  ;
wire        w_user_valid_4 ;
wire [15:0] w_user_data_5  ;
wire        w_user_valid_5 ;
wire [15:0] w_user_data_6  ;
wire        w_user_valid_6 ;
wire [15:0] w_user_data_7  ;
wire        w_user_valid_7 ;
wire [15:0] w_user_data_8  ;
wire        w_user_valid_8 ;


sys_clk sys_clk_u0
   (
    .clk_out1        (w_clk_50mhz   ),  
    .locked          (locked        ),      
    .clk_in1         (clk           )     
);
AD7606_drive#(
    .P_RANGE         (0             )//0：0-5V:；1：0-10V
) AD7606_drive_u0(
    .i_clk           (w_clk_50mhz   ),//50MHz 1 cycle = 20ns
    .i_rst           (~locked       ),
    /*------user interface------*/
    .i_user_ctrl     (1'b1          ),
    .o_user_chnl     (w_user_chnl   ),
    .o_user_data_1   (w_user_data_1 ), 
    .o_user_valid_1  (w_user_valid_1), 
    .o_user_data_2   (w_user_data_2 ), 
    .o_user_valid_2  (w_user_valid_2), 
    .o_user_data_3   (w_user_data_3 ), 
    .o_user_valid_3  (w_user_valid_3), 
    .o_user_data_4   (w_user_data_4 ), 
    .o_user_valid_4  (w_user_valid_4), 
    .o_user_data_5   (w_user_data_5 ), 
    .o_user_valid_5  (w_user_valid_5), 
    .o_user_data_6   (w_user_data_6 ), 
    .o_user_valid_6  (w_user_valid_6), 
    .o_user_data_7   (w_user_data_7 ), 
    .o_user_valid_7  (w_user_valid_7), 
    .o_user_data_8   (w_user_data_8 ), 
    .o_user_valid_8  (w_user_valid_8), 
    
    /*------AD7606 interface------*/
    .o_ad_psb_sel    (  ),
    .o_ad_stby       (  ),
    .o_ad_range      (o_ad_range    ),
    .o_ad_osc        (o_ad_osc      ),
    .o_ad_reset      (o_ad_reset    ),
    .o_ad_convstA    (o_ad_convstA  ),
    .o_ad_convstB    (o_ad_convstB  ),
    .o_ad_cs         (o_ad_cs       ),
    .o_ad_rd         (o_ad_rd       ),
    .i_ad_busy       (i_ad_busy     ),
    .i_ad_firstdata  (i_ad_firstdata),
    .i_ad_data       (i_ad_data     )
    );
    
endmodule
