typedef enum logic [3:0] {
    ALU_ADD  = 4'b0000,
    ALU_SUB  = 4'b0001,
    ALU_AND  = 4'b0010,
    ALU_OR   = 4'b0011,
    ALU_XOR  = 4'b0100,
    ALU_SLL  = 4'b0101,  // shift left logical
    ALU_SRL  = 4'b0110,  // shift right logical
    ALU_SRA  = 4'b0111,  // shift right arithmetic
    ALU_SLT  = 4'b1000,  // set less than (signed)
    ALU_SLTU = 4'b1001   // set less than (unsigned)
} alu_op_e;

module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  alu_op_e      op,
    output logic [31:0] result,
    output logic         zero      // 1 when result == 0 — branches (beq) will use this
);

    always_comb begin
        case (op)
            ALU_ADD:  result = a + b;
            ALU_SUB:  result = a - b;
            ALU_AND:  result = a & b;
            ALU_OR:   result = a | b;
            ALU_XOR:  result = a ^ b;
            ALU_SLL:  result = a << b[4:0];
            ALU_SRL:  result = a >> b[4:0];
            ALU_SRA:  result = $signed(a) >>> b[4:0];
            ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            ALU_SLTU: result = (a < b) ? 32'd1 : 32'd0;
            default:  result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule