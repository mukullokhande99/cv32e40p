// Copyright 2026
// Licensed under the Solderpad Hardware License, Version 2.0.

module cv32e40p_sparv_mult_tb;
  import cv32e40p_pkg::*;

  logic clk = 0;
  logic rst_n = 0;
  logic enable;
  mul_opcode_e operator;
  logic short_subword;
  logic [1:0] short_signed;
  logic [31:0] op_a, op_b, op_c;
  logic [4:0] imm;
  logic [1:0] dot_signed;
  logic [31:0] dot_a, dot_b, dot_c;
  logic is_clpx;
  logic [1:0] clpx_shift;
  logic clpx_img;
  logic [31:0] result;
  logic multicycle;
  logic ready;
  logic ex_ready;

  always #5 clk = ~clk;

  cv32e40p_sparv_mult dut (
      .clk(clk), .rst_n(rst_n),
      .enable_i(enable), .operator_i(operator),
      .short_subword_i(short_subword), .short_signed_i(short_signed),
      .op_a_i(op_a), .op_b_i(op_b), .op_c_i(op_c), .imm_i(imm),
      .dot_signed_i(dot_signed), .dot_op_a_i(dot_a), .dot_op_b_i(dot_b),
      .dot_op_c_i(dot_c), .is_clpx_i(is_clpx), .clpx_shift_i(clpx_shift),
      .clpx_img_i(clpx_img), .result_o(result), .multicycle_o(multicycle),
      .ready_o(ready), .ex_ready_i(ex_ready)
  );

  task automatic wait_ready(input integer max_cycles);
    integer n;
    begin
      n = 0;
      while (!ready && n < max_cycles) begin
        @(posedge clk);
        n = n + 1;
      end
      if (!ready) $fatal(1, "timeout waiting for SPARV multiplier");
    end
  endtask

  initial begin
    enable = 0;
    operator = MUL_I;
    short_subword = 0;
    short_signed = 2'b11;
    op_a = 0; op_b = 0; op_c = 0; imm = 0;
    dot_signed = 2'b00; dot_a = 0; dot_b = 0; dot_c = 0;
    is_clpx = 0; clpx_shift = 0; clpx_img = 0;
    ex_ready = 1;

    repeat (2) @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    // 4x8 unsigned DOTP: 1*5 + 2*6 + 3*7 + 4*8 + 10 = 80.
    operator = MUL_DOT8;
    dot_signed = 2'b00;
    dot_a = 32'h04030201;
    dot_b = 32'h08070605;
    dot_c = 32'd10;
    enable = 1;
    @(posedge clk);
    if (ready) $fatal(1, "DOT8 unexpectedly completed in one cycle");
    wait_ready(8);
    if (result !== 32'd80) $fatal(1, "DOT8 mismatch: %0d", result);
    @(posedge clk);
    enable = 0;

    // Signed scalar MAC: (-3)*7 + 100 = 79.
    operator = MUL_MAC32;
    op_a = -32'sd3;
    op_b = 32'd7;
    op_c = 32'd100;
    enable = 1;
    @(posedge clk);
    wait_ready(20);
    if ($signed(result) !== 32'sd79) $fatal(1, "MAC32 mismatch: %0d", $signed(result));
    @(posedge clk);
    enable = 0;

    // A non-accelerated integer MUL remains compatible with the baseline path.
    operator = MUL_I;
    op_a = 32'd9;
    op_b = 32'd11;
    op_c = 32'd0;
    enable = 1;
    #1;
    if (!ready) $fatal(1, "baseline MUL path should be ready");
    if (result !== 32'd99) $fatal(1, "baseline MUL mismatch: %0d", result);

    $display("SPARV multiplier integration PASS");
    $finish;
  end
endmodule
