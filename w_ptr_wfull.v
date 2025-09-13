`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 10:53:23
// Design Name: 
// Module Name: w_ptr_wfull
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
// Write Pointer & Full Flag Logic
//====================================================
module wptr_full
#(
  parameter ADDRSIZE = 4
)
(
  input   winc, wclk, wrst_n,
  input   [ADDRSIZE:0] wq2_rptr,   // synchronized read pointer
  output  reg wfull,               // full flag
  output  [ADDRSIZE-1:0] waddr,    // memory write address
  output  reg [ADDRSIZE:0] wptr    // write pointer (Gray code)
);

  reg  [ADDRSIZE:0] wbin;          // binary write pointer
  wire [ADDRSIZE:0] wgraynext;     // next Gray pointer
  wire [ADDRSIZE:0] wbinnext;      // next binary pointer
  wire wfull_val;

  //-------------------
  // Binary & Gray pointer logic
  //-------------------
  assign wbinnext  = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext >> 1) ^ wbinnext;

  // Memory write address = binary pointer (lower bits only)
  assign waddr = wbin[ADDRSIZE-1:0];

  //-------------------
  // Pointer register update
  //-------------------
  always @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n)
      {wbin, wptr} <= 0;
    else
      {wbin, wptr} <= {wbinnext, wgraynext};
  end

  //------------------------------------------------------------------
  // Full condition:
  // FIFO is full when next write pointer = read pointer
  // with MSBs inverted (classic Gray code full detection)
  //------------------------------------------------------------------
  assign wfull_val = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
                                    wq2_rptr[ADDRSIZE-2:0]});

  always @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n)
      wfull <= 1'b0;
    else
      wfull <= wfull_val;
  end

endmodule
