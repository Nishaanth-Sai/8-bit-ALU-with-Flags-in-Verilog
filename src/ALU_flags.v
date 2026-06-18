/*
Author: Nishaanth Sai Vinodh Kumar
Project: 8-Bit ALU With Flags
Language: Verilog HDL
*/


module ALU_flags (
    input [7:0] a,      // First 8-bit operand
    input [7:0] b,      // Second 8-bit operand
    input [3:0] sel,    // Operation select signal
    output reg [7:0] out,// Output
    output reg zero,carry,overflow,negative // flags
);

// 8-Bit Arithmetic Logic Unit (ALU)
// ---------------------------------
// Operation Codes:
//
// 0001 : Addition       (a + b)
// 0010 : Subtraction    (a - b)
// 0011 : Bitwise AND    (a & b)
// 0100 : Bitwise OR     (a | b)
// 0101 : Bitwise XOR    (a ^ b)
// 0111 : Bitwise NOT A  (~a)
// 1000 : Bitwise NOT B  (~b)
// 1001 : Shift Right    (a >> b)
// 1010 : Shift Left     (a << b)
// 1011 : Compare        (a < b)
//
// Any undefined outputs 0
localparam ADD = 4'b0001;
localparam SUB = 4'b0010;
localparam AND = 4'b0011;
localparam OR = 4'b0100;
localparam XOR = 4'b0101;
localparam NOT_A = 4'b0111;
localparam NOT_B = 4'b1000;
localparam SHIFT_RIGHT = 4'b1001;
localparam SHIFT_LEFT = 4'b1010;
localparam COMPARISON = 4'b1011;

reg[8:0] a_out; // ALU actual output

always @(*) begin
    carry = 0;
    overflow = 0; 
    zero = 0;
    negative = 0;

    // Select operation based on sel input
    case(sel)

        ADD: 
        begin
            a_out = {1'b0, a} + {1'b0, b}; 

            carry = a_out[8];
            
            if (((a[7] ==  b[7]) ) && (a_out[7] != a[7]))
                overflow = 1; 
            
            out = a_out[7:0];
        end

        SUB:         
        begin 
            a_out = {1'b0, a} - {1'b0, b};     
            
            carry = ~a_out[8];
           
            if (((a[7] != b[7])) && (a_out[7] != a[7]))
                overflow = 1; 
                     
            out = a_out[7:0];
        end

        AND:         out = a & b;      // Bitwise AND

        OR:          out = a | b;      // Bitwise OR

        XOR:         out = a ^ b;      // Bitwise XOR

        NOT_A:       out = ~a;         // Bitwise NOT of A

        NOT_B:       out = ~b;         // Bitwise NOT of B

        SHIFT_RIGHT: out = a >> b;     // Logical right shift by B positions

        SHIFT_LEFT: out = a << b;     // Logical left shift by B positions

        COMPARISON: out = (a < b) ? 8'b00000001 : 8'b00000000; // Outputs 1 if A < B, otherwise 0

        default: out = 0;          // Default output for undefined opcodes
        



    endcase

        negative = out[7];
        zero = (out == 8'b00000000);
   
     
end


endmodule