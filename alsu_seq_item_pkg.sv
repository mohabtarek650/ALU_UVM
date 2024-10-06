
package alsu_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_seq_item extends uvm_sequence_item;
`uvm_object_utils(alsu_seq_item)

bit [3] arr [6]='{000,001,010,011,100,101};
rand bit [2:0] A,B;
rand bit [2:0] opcode;
rand bit rst,cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
logic [15:0] leds;
logic signed [5:0] out;

function new(string name ="alsu_seq_item");
super.new(name);
endfunction


function string convert2string(); 
return $sformatf("%s reset = 0b%0b, a = 0b%0b, b = 0b%0b, opcode = 0b%0b, red_op_A = 0b%0b , red_op_B = 0b%0b, bypass_A = 0b%0b, bypass_B = 0b%0b, direction = 0b%0b, serial_in = 0b%0b",super.convert2string, rst, A, B, opcode, red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in);
endfunction


function string convert2string_stimulus(); 
return $sformatf("reset = 0b%0b, a = 0b%0b, b = 0b%0b, opcode = 0b%0b, red_op_A = 0b%0b , red_op_B = 0b%0b, bypass_A = 0b%0b, bypass_B = 0b%0b, direction = 0b%0b, serial_in = 0b%0b", rst, A, B, opcode, red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in);
endfunction

////////////////////////////////
constraint rst_n{
rst dist{1:/10,0:/90};
}
////////////////////////////////////
constraint add_mult{
if(opcode==3'b010 || opcode==3'b011){
A dist{3'b111:=30, 3'b000:=30, 3'b011:=30, 3'b001:=5, 3'b010:=5, 3'b101:=5};
B dist{3'b111:=30, 3'b000:=30, 3'b011:=30, 3'b001:=5, 3'b010:=5, 3'b101:=5};
}
}
//////////////////////////////////////
constraint or_xor1{
if((opcode==3'b000 || opcode==3'b001) && red_op_A){
A dist{3'b010:/30, 3'b100:/30, 3'b001:/30, 3'b110:/2,3'b011:/2,3'b101:/2,3'b111:/2,3'b000:/2};
B inside{3'b000};
}
}
//////////////////////////////////////
constraint or_xor2{
if((opcode==3'b000 || opcode==3'b001) && red_op_B){
B dist{3'b010:/30, 3'b100:/30, 3'b001:/30, 3'b110:/2,3'b011:/2,3'b101:/2,3'b111:/2,3'b000:/2};
A inside{3'b000} ;
}
}
//////////////////////////////////////
constraint invalid{
opcode dist{3'b000:=30, 3'b001:=30, 3'b010:=30, 3'b011:=30, 3'b100:=30, 3'b101:=30, 3'b110:=5, 3'b111:=5};
}
/////////////////////////////////////
constraint bypass{
bypass_A dist{1:/10,0:/90};
bypass_B dist{1:/10,0:/90};
}
///////////////////////////////////////
constraint new_cons{
opcode inside{arr};
}

endclass

endpackage