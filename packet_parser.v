`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: Ryan W. Ziffra
// 
// Create Date: 09/27/2026 01:38:43 PM
// Design Name: 
// Module Name: packet_parser
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


module packet_parser(

    input wire clk,
    input wire rst,
    
    input wire [7:0] data, //byte in
    input wire data_valid, //byte valid
    
    output reg [31:0] symbol,
    output reg [15:0] price, 
    output reg [15:0] size, 
    output reg side,
    
    output reg packet_valid
    
    );
    
    localparam IDLE = 3'd0;
    localparam SYMBOL = 3'd1;
    localparam PRICE = 3'd2;
    localparam SIZE = 3'd3;
    localparam SIDE = 3'd4;
    localparam DONE = 3'd5;
    
        
   
    
    reg [2:0] state = IDLE;
    reg [2:0] byte_index = 0;
    
        always @(posedge clk) begin
            if (rst) begin
                state <= IDLE;
                
                packet_valid <= 0;
                
            end else begin
                packet_valid <= 0;
                
                
                case (state) 
                    IDLE: begin
                    //IDLE
                        if (data_valid) begin
                            state <= SYMBOL;
                            symbol[31:24] <= data;
                            byte_index <= 1;
                            // store bit
                        end
                          
                    end
                    SYMBOL: begin
                    //SYMBOL
                        if (data_valid) begin
                            
                            if (byte_index == 1) begin
                                byte_index <= 2;
                                symbol[23:16] <= data;
                            end
                            else if (byte_index == 2) begin
                                byte_index <= 3;
                                symbol[15:8] <= data;
                            end 
                            else if (byte_index == 3) begin
                                byte_index <= 0; 
                                symbol[7:0] <= data;
                                state <= PRICE;
                            end
                             
                        end
                    end
                    PRICE: begin
                    //PRICE
                        if (data_valid) begin
                            if (byte_index == 0) begin
                                price[15:8] <= data;
                                byte_index <= 1;
                            end
                            else if (byte_index == 1) begin
                                price[7:0] <= data;
                                state <= SIZE;
                                byte_index <= 0;
                            end    
                        end
                    end
                    SIZE: begin
                    //SIZE
                        if (data_valid) begin
                            if (byte_index == 0) begin
                                size[15:8] <= data; 
                                byte_index <= 1;
                            end
                            else if (byte_index == 1) begin
                                size[7:0] <= data;
                                byte_index <= 0;
                                state <= SIDE;
                            end
                        end
                    end
                    SIDE: begin
                    //SIDE
                        if (data_valid) begin
                            side <= data[0];
                            state <= DONE;
                        end
                    end
                    DONE: begin
                    //DONE
                        packet_valid <= 1;
                        state <= IDLE;
                    end
                 
                endcase
            end
        end
                    
                    
                    
            
    
    
    
    
    
    
endmodule
