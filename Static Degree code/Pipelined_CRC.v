`timescale 1ns / 1ps

module crc(
    input clk,         // Clock input
    input rst,         // Reset input
    input first,        // Indicates the start of data
    input last,         // Indicates the end of data
    input valid,        // Indicates valid data
    input [7:0] data,  // Input Data (8-bit)
    output reg [7:0] crc, // Computed CRC (8-bit)
    output done,         // Indicates CRC check is complete for all data
    output pass,         // Indicates CRC check passed by comaparing last crc with expected
    output fail          // Indicates CRC check failed by comaparing last crc with expected
);
  
    parameter POLY = 8'h07; // CRC-8 Polynomial: x^8 + x^2 + x + 1
    parameter expected = 8'h02; //expected value
    reg [15:0] reg_stage1;
    reg [15:0] reg_stage2;
    reg [15:0] reg_stage3;
    reg [15:0] reg_stage4;
    reg [15:0] reg_stage5;
    reg [15:0] reg_stage6;
    reg [15:0] reg_stage7;
    reg [15:0] reg_stage8;
    reg [15:0] reg_stage9;
    reg [15:0] temp_stage1;
    reg [15:0] temp_stage2;
    reg [15:0] temp_stage3;
    reg [15:0] temp_stage4;
    reg [15:0] temp_stage5;
    reg [15:0] temp_stage6;
    reg [15:0] temp_stage7;
    reg [15:0] temp_stage8;
    reg [15:0] temp_stage9;
    
    reg d_clk, stage_1, stage_2, stage_3, stage_4, stage_5, stage_6, stage_7, stage_8, stage_9;
    integer count = 1, last_count = 0;  // Counter for stages
    initial begin
        reg_stage1 <= 16'b0;
        reg_stage2 <= 16'b0;
        reg_stage3 <= 16'b0;
        reg_stage4 <= 16'b0;
        reg_stage5 <= 16'b0;
        reg_stage6 <= 16'b0;
        reg_stage7 <= 16'b0;
        reg_stage8 <= 16'b0;
        reg_stage9 <= 16'b0;
        crc <= 8'b0;
        temp_stage1 <= 16'b0;
        temp_stage2 <= 16'b0;
        temp_stage3 <= 16'b0;
        temp_stage4 <= 16'b0;
        temp_stage5 <= 16'b0;
        temp_stage6 <= 16'b0;
        temp_stage7 <= 16'b0;
        temp_stage8 <= 16'b0;
        temp_stage9 <= 16'b0;
    end
    
    assign pass = (last_count == 5 && crc == expected)? 1'b1:1'b0;
    assign fail = (last_count == 5 && crc != expected)? 1'b1:1'b0;
    assign done = (last_count == 5)? 1'b1:1'b0;

  // Pipeline Stage 1 (Fetch the new data and apend 8 0's)
    always @(posedge clk)begin
        if(valid)begin
            if(last_count >= 1)begin 
               reg_stage1 = 16'b0; // inserting 0 after last data
            end
            else begin
               reg_stage1 = {data, 8'b0};
            end
        end
    end
  
  // Pipeline Stage 2 (XOR Division 1st iteration)
    always @(negedge clk)begin
        if(valid)begin
            temp_stage2 = reg_stage1;
            reg_stage2 = (temp_stage2[15]) ? (temp_stage2 << 1) ^ (POLY << 8) : (temp_stage2 << 1);
        end
    end

  // Pipeline Stage 3 (XOR Division 2nd iteration)
    always @(posedge clk)begin
        if(valid)begin
            temp_stage3 = reg_stage2;
            reg_stage3 = (temp_stage3[15]) ? (temp_stage3 << 1) ^ (POLY << 8) : (temp_stage3 << 1);
        end
    end

  // Pipeline Stage 4 (XOR Division 3rd iteration)
    always @(negedge clk)begin
        if(valid)begin
            temp_stage4 = reg_stage3;
            reg_stage4 = (temp_stage4[15]) ? (temp_stage4 << 1) ^ (POLY << 8) : (temp_stage4 << 1);
        end
    end

  // Pipeline Stage 5 (XOR Division 4th iteration)
    always @(posedge clk)begin
        if(valid)begin
            temp_stage5 = reg_stage4;
            reg_stage5 = (temp_stage5[15]) ? (temp_stage5 << 1) ^ (POLY << 8) : (temp_stage5 << 1);
        end
    end

  // Pipeline Stage 6 (XOR Division 5th iteration)
    always @(negedge clk)begin
        if(valid)begin
            temp_stage6 = reg_stage5;
            reg_stage6 = (temp_stage6[15]) ? (temp_stage6 << 1) ^ (POLY << 8) : (temp_stage6 << 1);
        end
    end

  // Pipeline Stage 7 (XOR Division 6th iteration)
    always @(posedge clk)begin
        if(valid)begin
            temp_stage7 = reg_stage6;
            reg_stage7 = (temp_stage7[15]) ? (temp_stage7 << 1) ^ (POLY << 8) : (temp_stage7 << 1);
        end
    end

  // Pipeline Stage 8 (XOR Division 7th iteration)
    always @(negedge clk)begin
        if(valid)begin
            temp_stage8 = reg_stage7;
            reg_stage8 = (temp_stage8[15]) ? (temp_stage8 << 1) ^ (POLY << 8) : (temp_stage8 << 1);
        end
    end
  // Pipeline Stage 9 (XOR Division 8th iteration)
    always @(posedge clk)begin
        if(valid)begin
            temp_stage9 = reg_stage8;
            reg_stage9 = (temp_stage9[15]) ? (temp_stage9 << 1) ^ (POLY << 8) : (temp_stage9 << 1);
            crc = (reg_stage9[15:8]); // Extract final CRC value after 8 clock cycles
        end
    end
  
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_stage1 <= 16'b0;
            reg_stage2 <= 16'b0;
            reg_stage3 <= 16'b0;
            reg_stage4 <= 16'b0;
            reg_stage5 <= 16'b0;
            reg_stage6 <= 16'b0;
            reg_stage7 <= 16'b0;
            reg_stage8 <= 16'b0;
            reg_stage9 <= 16'b0;
            crc <= 8'b0;
            count<=1;   
        end 
        if(last)begin 
                last_count <= last_count+1;
         end
    end
endmodule
