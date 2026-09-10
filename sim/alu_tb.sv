`timescale 1ns/1ps

module alu_tb;

    logic [31:0] a, b;
    alu_op_e      op;
    logic [31:0] result;
    logic         zero;

    int errors = 0;

    alu dut (
        .a      (a),
        .b      (b),
        .op     (op),
        .result (result),
        .zero   (zero)
    );

    task automatic check(
        input logic [31:0] a_in,
        input logic [31:0] b_in,
        input alu_op_e      op_in,
        input logic [31:0] expected,
        input string        name
    );
        a = a_in;
        b = b_in;
        op = op_in;
        #1; // let the always_comb block settle (no clock here, so 1 time unit is plenty)
        if (result !== expected) begin
            $display("FAIL  %-6s  a=%0d b=%0d  got=%0d  expected=%0d",
                      name, a_in, b_in, result, expected);
            errors++;
        end else begin
            $display("pass  %-6s  a=%0d b=%0d  result=%0d", name, a_in, b_in, result);
        end
    endtask

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        check(32'd10,  32'd3,   ALU_ADD,  32'd13,          "ADD");
        check(32'd10,  32'd3,   ALU_SUB,  32'd7,           "SUB");
        check(32'hFF,  32'h0F,  ALU_AND,  32'h0F,          "AND");
        check(32'hF0,  32'h0F,  ALU_OR,   32'hFF,          "OR");
        check(32'hFF,  32'h0F,  ALU_XOR,  32'hF0,          "XOR");
        check(32'd1,   32'd4,   ALU_SLL,  32'd16,          "SLL");
        check(32'd16,  32'd2,   ALU_SRL,  32'd4,           "SRL");
        check(-32'd8,  32'd1,   ALU_SRA,  -32'd4,          "SRA");
        check(-32'd5,  32'd3,   ALU_SLT,  32'd1,           "SLT");   // signed: -5 < 3
        check(32'd5,   32'd3,   ALU_SLTU, 32'd0,           "SLTU");  // unsigned: 5 < 3 is false
        check(32'd7,   32'd7,   ALU_SUB,  32'd0,           "ZERO");  // also exercises the zero flag

        // zero flag check on the last op above (7 - 7 = 0)
        if (zero !== 1'b1) begin
            $display("FAIL  zero flag did not assert when result == 0");
            errors++;
        end

        if (errors == 0)
            $display("\nALL TESTS PASSED");
        else
            $display("\n%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule