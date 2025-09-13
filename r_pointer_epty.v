`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 10:49:02
// Design Name: 
// Module Name: r_pointer_epty
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
// Read Pointer & Empty Flag Logic
//====================================================
module rptr_empty
#(
  parameter ADDRSIZE = 4
)
(
  input   rinc, rclk, rrst_n,
  input   [ADDRSIZE:0] rq2_wptr,     // synchronized write pointer
  output  reg rempty,                // empty flag
  output  [ADDRSIZE-1:0] raddr,      // memory read address
  output  reg [ADDRSIZE:0] rptr      // read pointer (Gray code)
);

  reg  [ADDRSIZE:0] rbin;            // binary read pointer
  wire [ADDRSIZE:0] rgraynext;       // next Gray-coded pointer
  wire [ADDRSIZE:0] rbinnext;        // next binary pointer
  wire rempty_val;

  //-------------------
  // Binary & Gray pointer logic
  //-------------------
  assign rbinnext   = rbin + (rinc & ~rempty);
  assign rgraynext  = (rbinnext >> 1) ^ rbinnext;

  // Memory read address = binary pointer (lower bits only)
  assign raddr = rbin[ADDRSIZE-1:0];

  //-------------------
  // Pointer register update
  //-------------------
  always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n)
      {rbin, rptr} <= 0;
    else
      {rbin, rptr} <= {rbinnext, rgraynext};
  end

  //---------------------------------------------------------------
  // FIFO empty when next rptr == synchronized wptr
  //---------------------------------------------------------------
  assign rempty_val = (rgraynext == rq2_wptr);

  always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;
  end

endmodule

