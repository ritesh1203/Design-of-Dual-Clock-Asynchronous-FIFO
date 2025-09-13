`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 10:41:49
// Design Name: 
// Module Name: TOP
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


//====================================================
// Asynchronous FIFO - Top Level Wrapper
//====================================================
module async_fifo1
#(
  parameter DATASIZE = 8,   // Data width
  parameter ADDRSIZE = 4    // Address size (FIFO depth = 2^ADDRSIZE)
 )
(
  input   winc, wclk, wrst_n,   // write enable, write clock, write reset (active low)
  input   rinc, rclk, rrst_n,   // read enable, read clock, read reset (active low)
  input   [DATASIZE-1:0] wdata, // data input

  output  [DATASIZE-1:0] rdata, // data output
  output  wfull,                // FIFO full flag
  output  rempty                // FIFO empty flag
);

  // Internal signals
  wire [ADDRSIZE-1:0] waddr, raddr;
  wire [ADDRSIZE:0]   wptr, rptr;
  wire [ADDRSIZE:0]   wq2_rptr, rq2_wptr;

  //====================================================
  // Submodules
  //====================================================

  // Synchronize read pointer into write clock domain
  sync_r2w #(.ADDRSIZE(ADDRSIZE)) u_sync_r2w (
    .rptr     (rptr),
    .wclk     (wclk),
    .wrst_n   (wrst_n),
    .wq2_rptr (wq2_rptr)
  );

  // Synchronize write pointer into read clock domain
  sync_w2r #(.ADDRSIZE(ADDRSIZE)) u_sync_w2r (
    .wptr     (wptr),
    .rclk     (rclk),
    .rrst_n   (rrst_n),
    .rq2_wptr (rq2_wptr)
  );

  // FIFO memory
  fifomem #(.DATASIZE(DATASIZE), .ADDRSIZE(ADDRSIZE)) u_fifomem (
    .winc   (winc),
    .wfull  (wfull),
    .wclk   (wclk),
    .waddr  (waddr),
    .raddr  (raddr),
    .wdata  (wdata),
    .rdata  (rdata)
  );

  // Read pointer & empty flag logic
  rptr_empty #(.ADDRSIZE(ADDRSIZE)) u_rptr_empty (
    .rinc     (rinc),
    .rclk     (rclk),
    .rrst_n   (rrst_n),
    .rq2_wptr (rq2_wptr),
    .raddr    (raddr),
    .rptr     (rptr),
    .rempty   (rempty)
  );

  // Write pointer & full flag logic
  wptr_full #(.ADDRSIZE(ADDRSIZE)) u_wptr_full (
    .winc     (winc),
    .wclk     (wclk),
    .wrst_n   (wrst_n),
    .wq2_rptr (wq2_rptr),
    .waddr    (waddr),
    .wptr     (wptr),
    .wfull    (wfull)
  );

endmodule

