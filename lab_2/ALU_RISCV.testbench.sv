`timescale 1ns / 1ps

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

module ALU_RISCV_testbench();
  integer     a, b;
  reg  [4:0]  alu_op;
  wire [31:0] result;
  wire        flag;

  integer correct_result;
  integer correct_flag;

  ALU_RISCV dut (alu_op, a, b, result, flag);

  initial begin
    for (a = $signed(-10); a <= 10; a = a + 1) begin
     for (b = $signed(-10); b <= 10; b = b + 1) begin
        for (alu_op = 5'b00000; alu_op <= 5'b11111; alu_op = alu_op + 1) begin
          correct_result = 0;
          correct_flag = 1'b0;
          case (alu_op)
            `ADD:    correct_result <= a+ b;
            `SUB:    correct_result <= a - b;
            `LS:     correct_result <= a << b;
            `LT:     correct_result <= a < b;
            `ULT:    correct_result <= $unsigned(a < b);
            `XOR:    correct_result <= a ^ b;
            `RS:     correct_result <= a >> b;
            `ARS:    correct_result <= $signed(a) >>> $signed(b);
            `OR:     correct_result <= a | b;
            `AND:    correct_result <= a & b;
            `F_EQ:   correct_flag <= a == b;
            `F_NEQ:  correct_flag <= a != b;
            `F_LT:   correct_flag <= a < b;
            `F_GEQ:  correct_flag <= a >= b;
            `F_ULT:  correct_flag <= $unsigned(a < b);
            `F_UGEQ: correct_flag <= $unsigned(a > b);
            default: ;
          endcase

          # 100
          if (result == correct_result && flag == correct_flag) begin
            $display("OK!");
           end else begin
            $display("ERROR!");
            $display("  ALU OPERATION: %d", alu_op);
            $display("  VALUES: a = %d, b = %d", a, b);
            $display("  ALU_FLAG: %d should be %d", flag, correct_flag);
            $display("  ALU_RESULT: %d should be %d", result, correct_result);
          end
        end
      end
    end
    $stop;
  end
endmodule
