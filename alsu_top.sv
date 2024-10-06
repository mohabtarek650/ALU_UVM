
import uvm_pkg::*; 
`include "uvm_macros.svh"
import alsu_test_pkg::*; 
module alsu_top();
bit clk;
always #5 clk = ~clk;

alu_if aluif(clk);
ALSU DUT(aluif);
    bind ALSU SVA alsu_inst(aluif);
initial begin 
uvm_config_db#(virtual alu_if)::set(null,"uvm_test_top","ALU_IF",aluif);
run_test("alsu_test");
end
endmodule