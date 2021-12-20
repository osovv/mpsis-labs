`timescale 1ns / 1ps

module ALU_RISCV(
  input [4:0] alu_op,
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] result,
  output reg flag
);

  //output: result depends, flag = 0
  `define ADD  5'b00000 // add (+)
  `define SUB  5'b01000 // subtract (-)
  `define LS   5'b00001 // left shift (<<)
  `define LT   5'b00010 // less than (<)
  `define ULT  5'b00011 // unsigned less than (<<)
  `define XOR  5'b00100 // xor (^)
  `define RS   5'b00101 // right shift (>>)
  `define ARS  5'b01101 // arithmetic right shift (>>>)
  `define OR   5'b00110 // or (|)
  `define AND  5'b00111 // and (&)

  // output: result = 0, flag depends
  `define F_EQ   5'b11000 // equal (==)
  `define F_NEQ  5'b11001 // not equal (!=)
  `define F_LT   5'b11100 // less than (<)
  `define F_GEQ  5'b11101 // greater or equal (>=)
  `define F_ULT  5'b11110 // unsigned less than(<)
  `define F_UGEQ 5'b11111 // unsigned greater or equal (>=)

  always @ (*) begin
    result = 32'b0;
    flag = 1'b0;

    case (alu_op)
      `ADD:    result <= a+ b;
      `SUB:    result <= a - b;
      `LS:     result <= a << b;
      `LT:     result <= a < b;
      `ULT:    result <= $unsigned(a < b);
      `XOR:    result <= a ^ b;
      `RS:     result <= a >> b;
      `ARS:    result <= $signed(a) >>> $signed(b);
      `OR:     result <= a | b;
      `AND:    result <= a & b;
      `F_EQ:   flag <= a == b;
      `F_NEQ:  flag <= a != b;
      `F_LT:   flag <= a < b;
      `F_GEQ:  flag <= a >= b;
      `F_ULT:  flag <= $unsigned(a < b);
      `F_UGEQ: flag <= $unsigned(a > b);
      default: flag <= 0;
    endcase
  end
endmodule
