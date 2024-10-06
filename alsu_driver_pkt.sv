package alsu_driver_pkt;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_seq_item_pkg::*;
import alsu_config_pkg::*;

class alsu_driver extends uvm_driver #(alsu_seq_item);
   `uvm_component_utils(alsu_driver)

   virtual alu_if alsu_vif;
   alsu_seq_item stim_seq_item;

   function new(string name = "alsu_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
         stim_seq_item = alsu_seq_item::type_id::create("stim_seq_item");
         seq_item_port.get_next_item(stim_seq_item);
         // Logging stimulus values
         `uvm_info("Driver", $sformatf("Stimulus: rst=%0d, A=%0d, B=%0d, opcode=%0d", 
                                        stim_seq_item.rst, stim_seq_item.A, 
                                        stim_seq_item.B, stim_seq_item.opcode), 
                    UVM_MEDIUM);
         alsu_vif.rst = stim_seq_item.rst;
         alsu_vif.A = stim_seq_item.A;
         alsu_vif.B = stim_seq_item.B;
         alsu_vif.opcode = stim_seq_item.opcode;
         alsu_vif.cin = stim_seq_item.cin;
         alsu_vif.serial_in = stim_seq_item.serial_in;
         alsu_vif.red_op_A = stim_seq_item.red_op_A;
         alsu_vif.red_op_B = stim_seq_item.red_op_B;
         alsu_vif.bypass_A = stim_seq_item.bypass_A;
         alsu_vif.bypass_B = stim_seq_item.bypass_B;
         alsu_vif.direction = stim_seq_item.direction;

         @(negedge alsu_vif.clk);
         seq_item_port.item_done();
         `uvm_info("Driver", stim_seq_item.convert2string_stimulus(), UVM_HIGH);
      end
   endtask
endclass
endpackage