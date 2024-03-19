`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/20 22:43:23
// Design Name: 
// Module Name: SIM_ad7606_drive_tb
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


module SIM_ad7606_drive_tb();

localparam P_CLK_PERIOD = 20;
reg clk,rst;

always begin
    clk = 0;
    #(P_CLK_PERIOD/2);
    clk = 1;
    #(P_CLK_PERIOD/2);
end

initial begin
    rst = 1;
    #100;
    @(posedge clk)rst = 0;
end

AD7606_drive AD7606_drive_u0(
    .i_clk           (clk),//50MHz 1 cycle = 20ns
    .i_rst           (rst),
    /*------user interface------*/
    .i_user_ctrl     (1'b1),
    .o_user_data_1   (), 
    .o_user_valid_1  (), 
    .o_user_data_2   (), 
    .o_user_valid_2  (), 
    .o_user_data_3   (), 
    .o_user_valid_3  (), 
    .o_user_data_4   (), 
    .o_user_valid_4  (), 
    .o_user_data_5   (), 
    .o_user_valid_5  (), 
    .o_user_data_6   (), 
    .o_user_valid_6  (), 
    .o_user_data_7   (), 
    .o_user_valid_7  (), 
    .o_user_data_8   (), 
    .o_user_valid_8  (), 
    .o_user_chnl     (),
    /*------AD7606 interface------*/
    .o_ad_psb_sel    (),
    .o_ad_stby       (),
    .o_ad_osc        (),
    .o_ad_reset      (),
    .o_ad_convstA    (),
    .o_ad_convstB    (),
    .o_ad_cs         (),
    .o_ad_rd         (),
    .i_ad_busy       (0),
    .i_ad_firstdata  (),
    .i_ad_data       (16'h5555)
    );

endmodule
