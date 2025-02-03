`timescale 1ns / 1ps

module crc_tb();
    parameter Degree = 8;
    reg clk;
    reg rst;
    reg first;       // Indicates the start of data
    reg last;        // Indicates the end of data
    reg valid;       // Indicates valid data
    reg [7:0] data;  // Input Data (8-bit)
    wire [Degree - 1:0] crc;  // Computed CRC (8-bit)
    wire done;       // Indicates CRC check is complete
    wire pass;       // Indicates CRC check passed
    wire fail;       // Indicates CRC check failed
    
    // Instantiate the CRC module
    crc uut (.clk(clk), .rst(rst), .first(first), .last(last), .valid(valid), .data(data), .crc(crc), .done(done), .pass(pass), .fail(fail));
    
    // Clock Generation: 10ns period (100MHz)
    always #5 clk = ~clk;
    
    // Test Data Array
    reg [7:0] data_array [0:31];
    integer i;
    
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        data = 8'b0;
        valid = 1'b0;
        first = 1'b0;
        last = 1'b0;
        
        // Initialize Test Data
        data_array[0]  = 8'hA5;
        data_array[1]  = 8'hA3;
        data_array[2]  = 8'hA0;
        data_array[3]  = 8'hC1;
        data_array[4]  = 8'hD2;
        data_array[5]  = 8'hE3;
        data_array[6]  = 8'hF4;
        data_array[7]  = 8'h12;
        data_array[8]  = 8'h34;
        data_array[9]  = 8'h56;
        data_array[10] = 8'h78;
        data_array[11] = 8'h9A;
        data_array[12] = 8'hBC;
        data_array[13] = 8'hDE;
        data_array[14] = 8'hF0;
        data_array[15] = 8'h11;
        data_array[16] = 8'h22;
        data_array[17] = 8'h33;
        data_array[18] = 8'h44;
        data_array[19] = 8'h55;
        data_array[20] = 8'h66;
        data_array[21] = 8'h77;
        data_array[22] = 8'h88;
        data_array[23] = 8'h99;
        data_array[24] = 8'hAA;
        data_array[25] = 8'hBB;
        data_array[26] = 8'hCC;
        data_array[27] = 8'hDD;
        data_array[28] = 8'hEE;
        data_array[29] = 8'hFF;
        data_array[30] = 8'h0A;
        data_array[31] = 8'hB5;
        
        #20;
        
        // Release reset
        rst = 0;
        valid = 1'b1;
        first = 1'b1;
        
        // Send Data
        for (i = 0; i < 32; i = i + 1) begin
            data = data_array[i];
            if (i == 31) last = 1'b1;
            else last = 1'b0;
            #10;
            first = 1'b0;
        end
        
        // Wait for some cycles to observe results
        #100;
        
        // End simulation
        $finish;
    end
endmodule
