module FIFO_TB;
  reg clk;  reg reset;
  reg [7:0] data_in;
  reg write_en;
  reg read_en;
  wire [7:0] data_out;
  wire full;
  wire empty;
  wire [2:0] head;
  wire [2:0] tail;
  wire [3:0] count;

  FIFO dut (.clk(clk), .reset(reset),  .data_in(data_in),  .write_en(write_en),  .data_out(data_out), .read_en(read_en), .full(full),  .empty(empty), .head(head), .tail(tail), .count(count));

   initial begin
    clk = 0;
    forever #5 clk = ~clk;
   end

  initial begin
    
    clk = 0;
    reset = 1;
    data_in = 8'b0;
    write_en = 0;
    read_en = 0;
    #10 reset = 0;

    $display("Full: %b, Empty: %b,Head: %b,Tail: %b,Count: %b,	Indata: %b", full, empty,head,tail,count,data_in);

    repeat (8) begin
      data_in = data_in + 1;
      write_en = 1;
      #10;
      write_en = 0;
      #10; 
     $display("Full: %b, Empty: %b,Head: %b,Tail: %b,Count: %b,	Indata: %b", full, empty,head,tail,count,data_in);
    end

    repeat (8) begin
      read_en = 1;
      #10;
      read_en = 0;
      #10; 
      $display("Full: %b, Empty: %b,Head: %b,Tail: %b,Count: %b,	Outdata: %b", full, empty,head,tail,count,data_out);
    end

    #10;
    $finish;
  end
  initial begin
   $dumpfile("dump.vcd"); 
   $dumpvars; 
 end
endmodule

module FIFO ( input  clk, input  reset, input [7:0] data_in, input write_en, input read_en, output reg [7:0] data_out, output full, output empty, output reg [2:0] head, output reg[2:0]tail,        
  output reg [3:0] count       
);

  reg [7:0] memory [0:7]; 
        
  assign full = (count == 8);
  assign empty = (count == 0);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      head <= 3'b0;
      tail <= 3'b0;
      count <= 3'b0;
    end else if (write_en && !full) begin
      memory[head] <= data_in;
      head = head + 1;
      count = count + 1;
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 8'b0;
    end else if (read_en && !empty) begin
      data_out <= memory[tail];
      tail = tail + 1;
      count = count - 1;
    end
  end

endmodule






