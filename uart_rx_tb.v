`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: Ryan W. Ziffra
// 
// Create Date: 09/26/2026 09:44:24 PM
// Design Name: 
// Module Name: uart_rx_tb
// Project Name: FPGA Tick-to-Trade
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


module uart_rx_tb;

    reg clk;
    reg rst;
    reg rx;
    wire [7:0] data;
    wire data_valid;
    
    initial clk = 0;
    parameter CYCLES_PER_BIT_TIME = 104170;
    

    // Instantiate the UART receiver (unit under test)
    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data(data),
        .data_valid(data_valid)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        rst = 1;
        rx = 1;
        #20;
        rst = 0;
        
        rx = 0;
        #CYCLES_PER_BIT_TIME;
        
        //test bits, 01010101
        rx = 1;
        #(CYCLES_PER_BIT_TIME);  // bit 0
        rx = 0; 
        #(CYCLES_PER_BIT_TIME);  // bit 1
        rx = 1; 
        #(CYCLES_PER_BIT_TIME);  // bit 2
        rx = 0; 
        #(CYCLES_PER_BIT_TIME);  // bit 3
        rx = 1; 
        #(CYCLES_PER_BIT_TIME);  // bit 4
        rx = 0; 
        #(CYCLES_PER_BIT_TIME);  // bit 5
        rx = 1; 
        #(CYCLES_PER_BIT_TIME);  // bit 6
        rx = 0; 
        #(CYCLES_PER_BIT_TIME);  // bit 7
        
        
        
        
        rx = 1;
        #CYCLES_PER_BIT_TIME;
        
        $finish;
        
        
     end
    
    
    

endmodule