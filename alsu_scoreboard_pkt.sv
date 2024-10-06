package alsu_scoreboard_pkt;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_seq_item_pkg::*;
import alsu_config_pkg::*;

class alsu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alsu_scoreboard)
  
  // Export and FIFO for analysis
  uvm_analysis_export #(alsu_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo;
  alsu_seq_item seq_item_sb;
  logic [5:0] alsu_out_ref;
  int error_count = 0;
  int correct_count = 0;

  function new(string name = "alsu_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // These should be fine, as they don't attempt to change the scoreboard name
    sb_export = new("sb_export", this);
    sb_fifo   = new("sb_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      sb_fifo.get(seq_item_sb);
      ref_model(seq_item_sb);
      if (seq_item_sb.out != alsu_out_ref) begin
        `uvm_info("run_phase", $sformatf("Comparison failed"), UVM_HIGH);
        error_count++;
      end else begin
        `uvm_info("run_phase", $sformatf("Correct out : %s", seq_item_sb.convert2string()), UVM_HIGH);
        correct_count++;
      end
    end
  endtask

  task ref_model(alsu_seq_item seq_item_chk);
    if(seq_item_chk.rst) begin
      alsu_out_ref = 0;
    end else begin
      if(seq_item_chk.bypass_A && seq_item_chk.bypass_B)
        alsu_out_ref = seq_item_chk.A;
      else if(seq_item_chk.bypass_A)
        alsu_out_ref = seq_item_chk.A;
      else if(seq_item_chk.bypass_B)
        alsu_out_ref = seq_item_chk.B;
      else if((seq_item_chk.red_op_A | seq_item_chk.red_op_B) && (seq_item_chk.opcode[1] | seq_item_chk.opcode[2]))
        alsu_out_ref = 0;
      else begin
        case (seq_item_chk.opcode)
          3'h0: begin 
            if (seq_item_chk.red_op_A && seq_item_chk.red_op_B)
              alsu_out_ref = |seq_item_chk.A;
            else if (seq_item_chk.red_op_A) 
              alsu_out_ref  = |seq_item_chk.A;
            else if (seq_item_chk.red_op_B)
              alsu_out_ref  = |seq_item_chk.B;
            else 
              alsu_out_ref = seq_item_chk.A | seq_item_chk.B;
          end
          3'h1: begin
            if (seq_item_chk.red_op_A && seq_item_chk.red_op_B)
              alsu_out_ref = ^seq_item_chk.A;
            else if (seq_item_chk.red_op_A) 
              alsu_out_ref = ^seq_item_chk.A;
            else if (seq_item_chk.red_op_B)
              alsu_out_ref = (^seq_item_chk.B);
            else 
              alsu_out_ref = seq_item_chk.A ^ seq_item_chk.B;
          end
          3'h2: alsu_out_ref = seq_item_chk.A + seq_item_chk.B;
          3'h3: alsu_out_ref = seq_item_chk.A * seq_item_chk.B;
          3'h4: begin
            if (seq_item_chk.direction)
              alsu_out_ref = {alsu_out_ref[4:0], seq_item_chk.serial_in};
            else
              alsu_out_ref = {seq_item_chk.serial_in, alsu_out_ref[5:1]};
          end
          3'h5: begin
            if (seq_item_chk.direction)
              alsu_out_ref = {alsu_out_ref[4:0], alsu_out_ref[5]};
            else
              alsu_out_ref = {alsu_out_ref[0], alsu_out_ref[5:1]};
          end
          3'h6: alsu_out_ref = 0;
          3'h7: alsu_out_ref = 0;
        endcase
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total successful transactions: %0d, Total failed transactions: %0d", correct_count, error_count), UVM_MEDIUM);
  endfunction
endclass
endpackage
