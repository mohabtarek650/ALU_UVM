
package alsu_config_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class alsu_config extends uvm_object;
    `uvm_object_utils(alsu_config)

    virtual alu_if alsu_vif;

    function new(string name = "alsu_config");
      super.new(name);
    endfunction
  endclass
endpackage

