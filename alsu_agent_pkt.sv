package alsu_agent_pkt;
import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_driver_pkt::*;
import alsu_monitor_pkt::*;
import alsu_main_sequence_pkt::*;
import alsu_seq_item_pkg::*;
import alsu_config_pkg::*;
import mysequencer_pkt::*;

class alsu_agent extends uvm_agent;
  `uvm_component_utils(alsu_agent);

  alsu_driver drv;
  alsu_monitor mon;
  alsu_main_sequence seq;
  alsu_config alsu_cfg;
  uvm_analysis_port #(alsu_seq_item) agt_ap;

  function new(string name = "alsu_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(alsu_config)::get(this, "", "CFG", alsu_cfg)) begin
      `uvm_fatal("build_phase", "Unable to get configuration object");
    end
    sqr = mysequencer::type_id::create("sqr", this);
    drv = alsu_driver::type_id::create("drv", this);
    seq = alsu_main_sequence::type_id::create("seq", this);
    mon = alsu_monitor::type_id::create("mon", this);
    agt_ap = new("agt_ap", this);
    `uvm_info("Agent", "Driver, Monitor, and Sequence created", UVM_MEDIUM);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      drv.alsu_vif = alsu_cfg.alsu_vif; 
      mon.alsu_vif = alsu_cfg.alsu_vif;
      mon.mon_ap.connect(agt_ap); 
  endfunction
endclass
endpackage