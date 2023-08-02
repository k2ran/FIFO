module ALU_4bit(
  input [3:0] A,
  input [3:0] B,
  input [3:0] SEL,
  output reg C,
  output wire [3:0] OUT1,
  output wire [3:0] OUT2
);

  reg [7:0] result; // Increase the width of the result register

  always @(*)
    case (SEL)
      4'b0000: begin
        result = A + B;
        C = (A + B) > 15;
      end
      4'b0001: begin
        result = A - B;
        C = (A - B) < 0;
      end
      4'b0010: result = A * B;
      4'b0011: result = A / B;
      4'b0100: result = {A[0], A[7:1]};
      4'b0101: result = {A[6:0], A[7]};
      4'b0110: result = A << 1;
      4'b0111: result = A >> 1;
      4'b1000: result = A & B;
      4'b1001: result = A | B;
      4'b1010: result = ~A;
      4'b1011: result = ~(A | B);
      4'b1100: result = A ^ B;
      4'b1101: result = ~(A & B);
      4'b1110: result = (A > B) ? 4'b1 : 4'b0;
      4'b1111: result = (A == B) ? 4'b1 : 4'b0;
      default: result = 4'b0;
    endcase

  // Output assignment
  assign OUT1 = result[3:0]; // Assign the lower 4 bits of result to OUT1
  assign OUT2 = result[7:4]; // Assign the upper 4 bits of result to OUT2
endmodule


module tb;
  reg [3:0] A;
  reg [3:0] B;
  reg [3:0] SEL;
  wire C;
  wire [3:0] out1;
  wire [3:0] out2;
  reg clk;

  ALU_4bit u0(.A(A), .B(B), .SEL(SEL), .C(C), .OUT1(out1), .OUT2(out2));

  initial begin
    clk = 0;
    #5 A = 4'b0001; B = 4'b0001; SEL = 4'b0000;
    #5 A = 4'b0001; B = 4'b1000; SEL = 4'b0000;
    #5 A = 4'b1111; B = 4'b0011; SEL = 4'b0001;
    #5 $finish;
  end
  initial begin
  	$dumpfile("dump.vcd");
  	$dumpvars;
  end
  always #5 clk = ~clk;
endmodule


	
