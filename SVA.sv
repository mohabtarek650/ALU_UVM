module SVA (alu_if.DUT aluif);
property or_case;
    @(posedge aluif.clk) disable iff (aluif.rst)
    aluif.opcode == 3'h0 |=> 
        ((aluif.red_op_A && aluif.red_op_B) ? (aluif.out == ((aluif.INPUT_PRIORITY == "A") ? |aluif.A : |aluif.B)) :
        (aluif.red_op_A ? (aluif.out == |aluif.A) :
        (aluif.red_op_B ? (aluif.out == |aluif.B) : (aluif.out == (aluif.A | aluif.B)))));
endproperty
assert property (or_case); 
cover property (or_case); 

property xor_case;
    @(posedge aluif.clk) disable iff (aluif.rst)
    aluif.opcode == 3'h1 |=> 
        ((aluif.red_op_A && aluif.red_op_B) ? (aluif.out == ((aluif.INPUT_PRIORITY == "A") ? ^aluif.A : ^aluif.B)) :
        (aluif.red_op_A ? (aluif.out == ^aluif.A) :
        (aluif.red_op_B ? (aluif.out == ^aluif.B) : (aluif.out == (aluif.A^ aluif.B)))));
endproperty
assert property (xor_case); 
cover property (xor_case); 

property add_case;
    @(posedge aluif.clk) disable iff (aluif.rst)
    aluif.opcode == 3'h2 |=> 
        ((aluif.FULL_ADDER == "ON") ? (aluif.out == (aluif.A + aluif.B + aluif.cin)) : (aluif.out == (aluif.A + aluif.B)));
endproperty
assert property (add_case); 
cover property (add_case); 
 

property multiply_case;
    @(posedge aluif.clk) disable iff (aluif.rst)
    aluif.opcode == 3'h3 |=> (aluif.out == (aluif.A * aluif.B));
endproperty
assert property (multiply_case); 
cover property (multiply_case); 


property leds_blink_on_invalid;
    @(posedge aluif.clk) disable iff (aluif.rst)
    (aluif.opcode == 3'h5 ) |=> (aluif.leds == ~aluif.leds);
endproperty
assert property (leds_blink_on_invalid); 
cover property (leds_blink_on_invalid); 

endmodule
