
module ALSU(alu_if.DUT aluif);

logic cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
logic [2:0] opcode_reg, A_reg, B_reg;

logic invalid_red_op, invalid_opcode, invalid;

//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;

//Registering input signals
always @(posedge aluif.clk or posedge aluif.rst) begin
  if(aluif.rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;
  end else begin
     cin_reg <= aluif.cin;
     red_op_B_reg <= aluif.red_op_B;
     red_op_A_reg <= aluif.red_op_A;
     bypass_B_reg <= aluif.bypass_B;
     bypass_A_reg <= aluif.bypass_A;
     direction_reg <= aluif.direction;
     serial_in_reg <= aluif.serial_in;
     opcode_reg <= aluif.opcode;
     A_reg <= aluif.A;
     B_reg <= aluif.B;
  end
end

//leds output blinking 
always @(posedge aluif.clk or posedge aluif.rst) begin
  if(aluif.rst) begin
     aluif.leds <= 0;
  end else begin
      if (invalid)
        aluif.leds <= ~aluif.leds;
      else
        aluif.leds <= 0;
  end
end

//ALSU output processing
always @(posedge aluif.clk or posedge aluif.rst) begin
  if(aluif.rst) begin
    aluif.out <= 0;
  end
  else begin
    if (bypass_A_reg && bypass_B_reg)
      aluif.out <= (aluif.INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg)
      aluif.out <= A_reg;
    else if (bypass_B_reg)
      aluif.out <= B_reg;
    else begin
        case (opcode_reg)
          3'h0: begin 
            if (red_op_A_reg && red_op_B_reg)
              aluif.out = (aluif.INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              aluif.out <= |A_reg;
            else if (red_op_B_reg)
              aluif.out <= |B_reg;
            else 
              aluif.out <= A_reg | B_reg;
          end
          3'h1: begin
            if (red_op_A_reg && red_op_B_reg)
			   aluif.out <= (aluif.INPUT_PRIORITY == "A")? ^A_reg : ^B_reg;
            else if (red_op_A_reg) 
              aluif.out <= ^A_reg;
            else if (red_op_B_reg)
              aluif.out <= ^B_reg;
            else 
              aluif.out <= A_reg ^ B_reg;
          end
          3'h2:begin
		  if(aluif.FULL_ADDER == "ON") 
                aluif.out <= A_reg +B_reg+cin_reg;
                 else 
                aluif.out <= A_reg +B_reg ;
		  end
          3'h3: aluif.out <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              aluif.out <= {aluif.out[4:0], serial_in_reg};
            else
              aluif.out <= {serial_in_reg, aluif.out[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              aluif.out <= {aluif.out[4:0], aluif.out[5]};
            else
              aluif.out <= {aluif.out[0], aluif.out[5:1]};
          end
        endcase
    end 
  end
end

endmodule

