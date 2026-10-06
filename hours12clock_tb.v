module tb;
  wire [5:0] sec,min;
  reg mode=0,set=0,inc=0,dec=0;
  wire [3:0] hrs12;
  wire am_pm;
  reg clk=0,rst;

  always #5 clk = ~clk;

  digitalclock12h dut (clk,rst,inc,dec,mode,set,sec,min,hrs12,am_pm);

  initial begin
    rst = 1;@(posedge clk) rst = 0;
    mode=1; // mode button pressed
    // hours setting 
    inc=1; 
    dec=0;  // increment hours 12 to 01
    @(posedge clk)
    mode=0; // mode button relesed
    inc=0;
    dec=1; // decrement hours 01 to 12
    @(posedge clk)
    mode=1; // mode button pressed
    // minutes setting
    dec=1; // decrement minutes 00 to 59
    @(posedge clk)
    mode=0;
    dec=0;
    @(posedge clk)
    set=1;
  end
  
  always @(posedge clk) begin
      if (am_pm == 0)
        $display("TIME = %02d:%02d:%02d AM",
                  hrs12, min, sec);
      else
        $display("TIME = %02d:%02d:%02d PM",
                  hrs12, min, sec);
  end

  initial begin
    repeat(30) @(posedge clk);
    $finish;
  end
 
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule
