
package mysequencer_pkt;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_seq_item_pkg::*;

class mysequencer extends uvm_sequencer #(alsu_seq_item);
`uvm_component_utils(mysequencer);

function new(string name = "mysequencer" , uvm_component parent = null);
super.new(name,parent);
endfunction

endclass
endpackage