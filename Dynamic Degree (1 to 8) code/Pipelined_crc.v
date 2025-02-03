`timescale 1ns / 1ps

module crc #(
    parameter Degree = 8, //Mention the Polynomial Highest Degree
    parameter [Degree :0]POLYNOMIAL = 9'b100000111, // CRC-8 Polynomial: x^8 + x^2 + x + 1
    parameter expected = 8'h02 
)(
    input clk,         // Clock input
    input rst,         // Reset input
    input first,        // Indicates the start of data
    input last,         // Indicates the end of data
    input valid,        // Indicates valid data
    input [7:0] data,  // Input Data (8-bit)
    output reg [Degree-1 :0] crc, // Computed CRC (8-bit)
    output done,         // Indicates CRC check is complete
    output pass,         // Indicates CRC check passed
    output fail          // Indicates CRC check failed
);
    
    
    parameter [Degree-1 :0]POLY = (POLYNOMIAL[Degree-1:0]); // Keep only the lower 8 bits
    parameter N = Degree + 8 -1; // Degree + Lenght of data -1
    //Stage Register
    reg [N :0] reg_stage1;
    reg [N:0] reg_stage2;
    reg [N:0] reg_stage3;
    reg [N:0] reg_stage4;
    reg [N:0] reg_stage5;
    reg [N:0] reg_stage6;
    reg [N:0] reg_stage7;
    reg [N:0] reg_stage8;
    reg [N:0] reg_stage9;
    //Temporary Stage Register
    reg [N:0] temp_stage1;
    reg [N:0] temp_stage2;
    reg [N:0] temp_stage3;
    reg [N:0] temp_stage4;
    reg [N:0] temp_stage5;
    reg [N:0] temp_stage6;
    reg [N:0] temp_stage7;
    reg [N:0] temp_stage8;
    reg [N:0] temp_stage9;
    
    integer last_count = 0;  // Counter for stages
    initial begin
        reg_stage1 <= 0;
        reg_stage2 <= 0;
        reg_stage3 <= 0;
        reg_stage4 <= 0;
        reg_stage5 <= 0;
        reg_stage6 <= 0;
        reg_stage7 <= 0;
        reg_stage8 <= 0;
        reg_stage9 <= 0;
        crc <= 0;
        temp_stage1 <= 0;
        temp_stage2 <= 0;
        temp_stage3 <= 0;
        temp_stage4 <= 0;
        temp_stage5 <= 0;
        temp_stage6 <= 0;
        temp_stage7 <= 0;
        temp_stage8 <= 0;
        temp_stage9 <= 0;
    end
    
    assign pass = (last_count == 5 && crc == expected)? 1'b1:1'b0;
    assign fail = (last_count == 5 && crc != expected)? 1'b1:1'b0;
    assign done = (last_count == 5)? 1'b1:1'b0;
    
    // Pipeline Stage 1 - Fetch
    always @(posedge clk)begin
        if(valid)begin
            if(last_count >= 1)begin 
               reg_stage1 = 0;
            end
            else begin
               reg_stage1 = {data, {Degree{1'b0}}}; // Append 0's to the highest degree
            end
        end
    end

    // Pipeline Stage 2 - XOR Division 1st iteration
    always @(negedge clk)begin
        if(valid)begin
            temp_stage2 = reg_stage1;
            reg_stage2 = (temp_stage2[N]) ? (temp_stage2 << 1) ^ (POLY << 8) : (temp_stage2 << 1);
        end
    end

    // Pipeline Stage 3 - XOR Division 2nd iteration
    always @(posedge clk)begin
        if(valid )begin
            temp_stage3 = reg_stage2;
            reg_stage3 = (temp_stage3[N]) ? (temp_stage3 << 1) ^ (POLY << 8) : (temp_stage3 << 1);
        end
    end

    // Pipeline Stage 4 - XOR Division 3rd iteration
    always @(negedge clk)begin
        if(valid )begin
            temp_stage4 = reg_stage3;
            reg_stage4 = (temp_stage4[N]) ? (temp_stage4 << 1) ^ (POLY << 8) : (temp_stage4 << 1);
        end
    end

    // Pipeline Stage 5 - XOR Division 4th iteration
    always @(posedge clk)begin
        if(valid )begin
            temp_stage5 = reg_stage4;
            reg_stage5 = (temp_stage5[N]) ? (temp_stage5 << 1) ^ (POLY << 8) : (temp_stage5 << 1);
        end
    end

    // Pipeline Stage 6 - XOR Division 5th iteration
    always @(negedge clk)begin
        if(valid )begin
            temp_stage6 = reg_stage5;
            reg_stage6 = (temp_stage6[N]) ? (temp_stage6 << 1) ^ (POLY << 8) : (temp_stage6 << 1);
        end
    end

    // Pipeline Stage 7 - XOR Division 6th iteration
    always @(posedge clk)begin
        if(valid )begin
            temp_stage7 = reg_stage6;
            reg_stage7 = (temp_stage7[N]) ? (temp_stage7 << 1) ^ (POLY << 8) : (temp_stage7 << 1);
        end
    end

    // Pipeline Stage 8 - XOR Division 7th iteration
    always @(negedge clk)begin
        if(valid )begin
            temp_stage8 = reg_stage7;
            reg_stage8 = (temp_stage8[N]) ? (temp_stage8 << 1) ^ (POLY << 8) : (temp_stage8 << 1);
        end
    end

    // Pipeline Stage 9 - XOR Division 8th iteration and Get the Output
    always @(posedge clk)begin
        if(valid )begin
            temp_stage9 = reg_stage8;
            reg_stage9 = (temp_stage9[N]) ? (temp_stage9 << 1) ^ (POLY << 8) : (temp_stage9 << 1);
            crc = (reg_stage9[N:8]); // Extract final CRC value after 8 clock cycles
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_stage1 <= 0;
            reg_stage2 <= 0;
            reg_stage3 <= 0;
            reg_stage4 <= 0;
            reg_stage5 <= 0;
            reg_stage6 <= 0;
            reg_stage7 <= 0;
            reg_stage8 <= 0;
            reg_stage9 <= 0;
            crc <= 0;
        end 
        if(last)begin 
                last_count <= last_count+1;
         end
    end
endmodule
