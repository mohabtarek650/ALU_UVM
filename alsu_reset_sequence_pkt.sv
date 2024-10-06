package alsu_reset_sequence_pkt;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_seq_item_pkg::*;

class alsu_reset_sequence extends uvm_sequence #(alsu_seq_item);
  `uvm_object_utils(alsu_reset_sequence)  // Corrected to use uvm_object_utils

  alsu_seq_item seq_item;

  function new(string name = "alsu_reset_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(10000) begin
      seq_item = alsu_seq_item::type_id::create("seq_item");
      start_item(seq_item);
      seq_item.rst = 1;
      seq_item.A = 0;
      seq_item.B = 0;
      seq_item.cin = 0;
      seq_item.serial_in = 0;
      seq_item.direction = 0;
      seq_item.red_op_A = 0;
      seq_item.red_op_B = 0;
      seq_item.bypass_A = 0;
      seq_item.bypass_B = 0;
      finish_item(seq_item);
    end
  endtask

endclass
endpackage
