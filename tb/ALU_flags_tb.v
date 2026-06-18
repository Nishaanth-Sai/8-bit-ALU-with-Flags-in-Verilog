module ALU_flags_tb ;

 reg [7:0] a; 
 reg [7:0] b;
 reg [3:0] sel;
 wire [7:0] out;
 wire zero,carry,overflow,negative;

ALU_flags DUT (.a(a),
               .b(b),
               .sel(sel),
               .out(out),
               .zero(zero),
               .carry(carry),
               .overflow(overflow),
               .negative(negative));

initial begin

    $monitor ($time, "A = %d , B = %d, sel = %d, out = %d, zero = %d, carry = %d, overflow = %d, negative = %d ", a,b,sel,out,zero,carry,overflow,negative);

    // Create waveform dump file for GTKWave
        $dumpfile("flag_result.vcd");

        // Dump all signals in the testbench hierarchy
        $dumpvars(0, ALU_flags_tb);
    #5

       /* Addition (0001): Expected outputs given inputs

       | A   | B   | Expected Out | C | O | Z | N |
       --------------------------------------------
       | 3   | 2   | 5            | 0 | 0 | 0 | 0 |
       | 15  | 1   | 16           | 0 | 0 | 0 | 0 |
       | 255 | 1   | 0            | 1 | 0 | 1 | 0 |
       | 127 | 1   | 128          | 0 | 1 | 0 | 1 |
       | 128 | 255 | 127          | 1 | 1 | 0 | 0 |
    */
        a =  3 ; b = 2; sel = 1; #5
        a =  15 ; b = 1; sel = 1; #5
        a =  255 ; b = 1; sel = 1; #5
        a = 127 ; b = 1; sel = 1; #5
        a =  128 ; b = 255; sel = 1; #5

        /* SUB(0010): Expected outputs given inputs
        | A          | B        | Expected Out | C (borrow) | O | Z | N |
        ------------------------------------------------------------------
        | 6          | 3        | 3            | 0          | 0 | 0 | 0 |
        | 5          | 5        | 0            | 0          | 0 | 1 | 0 |
        | 2          | 4        | 254          | 1          | 0 | 0 | 1 |
        | 127        | 255 (-1) | 128          | 1          | 1 | 0 | 1 |
        | 128 (-128) | 1        | 127          | 0          | 1 | 0 | 0 |
        */
         a =  6 ; b = 3; sel = 2; #5
         a =  5 ; b = 5; sel = 2; #5
         a =  2 ; b = 4; sel = 2; #5
         a =  127 ; b = 255; sel = 2; #5
         a =  128 ; b = 1; sel = 2; #5

         /* AND (0011): Expected outputs given inputs
            | A        | B        | Expected Out | 
            | -------- | -------- | ------------ |
            | 11001100 | 10101010 | 10001000     |
            | 11111111 | 00000000 | 00000000     |
                          
        */
             a = 8'b11001100 ; b = 8'b10101010; sel = 3; #5
             a = 8'b11111111 ; b = 8'b00000000; sel = 3; #5



        /* OR (0100): Expected outputs given inputs
            | A        | B        | Expected Out |
            | -------- | -------- | ------------ |
            | 11001100 | 10101010 | 11101110     |
            | 00000000 | 00000000 | 00000000     |
                         
        */
            a = 8'b11001100 ; b = 8'b10101010; sel = 4; #5
            a = 8'b00000000 ; b = 8'b00000000; sel = 4; #5


        /* XOR (0101): Expected outputs given inputs
            | A        | B        | Expected Out |
            | -------- | -------- | ------------ |
            | 11001100 | 10101010 | 01100110     |
            | 11111111 | 11111111 | 00000000     |
        */
            a = 8'b11001100 ; b = 8'b10101010; sel = 5; #5
            a = 8'b11111111 ; b = 8'b11111111; sel = 5; #5
        
        /* NOT A(0111): Expected outputs given inputs
            | A        | Expected Out |
            | -------- | ------------ |
            | 10101010 | 01010101     |
            | 11111111 | 00000000     |
        */
            a = 8'b10101010 ; sel = 7; #5
            a = 8'b11111111 ; sel = 7; #5

        /* NOT B(1000):Expected outputs given inputs
            | B        | Expected Out |
            | -------- | ------------ |
            | 11001100 | 00110011     |
            | 11111111 | 00000000     |
        */

            b = 8'b11001100 ; sel = 8; #5
            b = 8'b11111111 ; sel = 8; #5

        /* Shift Right (1001): Expected outputs given inputs
            | A        | B | Expected Out |
            | -------- | - | ------------ |
            | 10000000 | 1 | 01000000     |
            | 10000000 | 4 | 00001000     |
            | 11111111 | 8 | 00000000     |
        */
             a = 8'b10000000 ; b = 8'b00000001; sel = 9; #5
             a = 8'b10000000 ; b = 8'b00000100; sel = 9; #5
             a = 8'b11111111 ; b = 8'b00001000; sel = 9; #5

        /* Shift Left (1010): Expected outputs given inputs
             | A        | B        | Expected Out |
             | -------- | -------- | ------------ |
             | 00000001 | 00000100 | 00010000     |
             | 10000000 | 00000000 | 10000000     |
             | 00000001 | 10000000 | 00000000     |
        */
             a = 8'b00000001 ; b = 8'b00000100; sel = 10; #5
             a = 8'b10000000 ; b = 8'b00000000; sel = 10; #5
             a = 8'b00000001 ; b = 8'b10000000; sel = 10; #5
        
        
         /* Comparison(1011): Expected outputs given inputs
             | A | B | Expected Out |
             | - | - | ------------ |
             | 3 | 5 | 1            |
             | 8 | 2 | 0            |
             | 4 | 4 | 0            |
        */
            a =  3 ; b = 5; sel = 11; #5
            a =  8 ; b = 2; sel = 11; #5
            a =  4 ; b = 4; sel = 11; #5

        #10
        $finish;

end
endmodule 









