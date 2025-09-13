`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 10:55:19
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module async_fifo1_tb;

  parameter DATASIZE = 8;
  parameter ADDRSIZE = 4;

  // DUT signals
  reg                   wclk, wrst_n, winc;
  reg                   rclk, rrst_n, rinc;
  reg  [DATASIZE-1:0]   wdata;
  wire [DATASIZE-1:0]   rdata;
  wire                  wfull, rempty;

  // Simple reference memory model
  reg [DATASIZE-1:0] ref_mem [0:(1<<ADDRSIZE)-1];
  integer wptr_ref, rptr_ref;

  // Instantiate DUT
  async_fifo1 #(.DATASIZE(DATASIZE), .ADDRSIZE(ADDRSIZE)) DUT
   (
    .winc   (winc),
    .wclk   (wclk),
    .wrst_n (wrst_n),
    .rinc   (rinc),
    .rclk   (rclk),
    .rrst_n (rrst_n),
    .wdata  (wdata),
    .rdata  (rdata),
    .wfull  (wfull),
    .rempty (rempty)
  );

  // Clock generation
  initial begin
    wclk = 0;
    forever #10 wclk = ~wclk;   // 50 MHz
  end

  initial begin
    rclk = 0;
    forever #35 rclk = ~rclk;   // ~14 MHz
  end

  // Reset sequence
  initial begin
    wrst_n = 0;
    rrst_n = 0;
    winc   = 0;
    rinc   = 0;
    wdata  = 0;
    wptr_ref = 0;
    rptr_ref = 0;
    #100;
    wrst_n = 1;
    rrst_n = 1;
  end

  // Write process
  initial begin
    @(posedge wrst_n);
    repeat (40) begin
      @(posedge wclk);
      if (!wfull) begin
        winc  = $random % 2;    // randomly enable write
        if (winc) begin
          wdata = $random;
          ref_mem[wptr_ref] = wdata;
          wptr_ref = (wptr_ref + 1) % (1<<ADDRSIZE);
          $display($time, " ns : WRITE %h", wdata);
        end
      end
    end
    winc = 0;
  end

  // Read process
  initial begin
    @(posedge rrst_n);
    repeat (40) begin
      @(posedge rclk);
      if (!rempty) begin
        rinc = $random % 2;    // randomly enable read
        if (rinc) begin
          #1; // wait for data stable
          if (rdata !== ref_mem[rptr_ref]) begin
            $display("ERROR at %t ns: expected %h, got %h",
                     $time, ref_mem[rptr_ref], rdata);
          end else begin
            $display($time, " ns : READ %h", rdata);
          end
          rptr_ref = (rptr_ref + 1) % (1<<ADDRSIZE);
        end
      end
    end
    rinc = 0;
    #500;
    $finish;
  end

endmodule

