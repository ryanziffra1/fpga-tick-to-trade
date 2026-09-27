`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: Ryan W. Ziffra
// 
// Create Date: 09/27/2026 03:04:43 PM
// Design Name: 
// Module Name: packet_parser_tb
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


module packet_parser_tb;

    reg clk;
    reg rst;
    reg [7:0] data;
    reg data_valid;
    wire [31:0] symbol;
    wire [15:0] price;
    wire [15:0] size;
    wire side;
    wire packet_valid;

    initial clk = 0;
    
    // instantiate packet_parser
    packet_parser uut (
        .clk(clk),
        .rst(rst),
        .data(data),
        .data_valid(data_valid),
        .symbol(symbol),
        .price(price),
        .size(size),
        .side(side),
        .packet_valid(packet_valid)
  
    );
    
    always #5 clk = ~clk;
    
    initial begin
        rst = 1;
        #20;
        rst = 0;
        
        //Sending Symbol, Price, Size, Buy
        //Sending RYAN, $123.45, 123, Buy
        //Symbol
        data = 8'h52;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        
        data = 8'h59;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        
        data = 8'h41;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        
        data = 8'h4E;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        //Price
        data = 8'h30;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        
        data = 8'h39;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        //Size
        data = 8'h00;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        
        data = 8'h7B;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        //Side (Buy/Sell)
        data = 8'h01;
        data_valid = 1;
        #10;
        data_valid = 0;
        #10;
        
        $finish;
    end



endmodule
