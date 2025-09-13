`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 10:52:22
// Design Name: 
// Module Name: syncw2r
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
// Synchronize Write Pointer into Read Clock Domain
//====================================================
module sync_w2r
#(
  parameter ADDRSIZE = 4
)
(
  input   rclk, rrst_n,
  input   [ADDRSIZE:0] wptr,
  output  reg [ADDRSIZE:0] rq2_wptr
);

  reg [ADDRSIZE:0] rq1_wptr;

  // Two-stage synchronizer for clock domain crossing
  always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n)
      {rq2_wptr, rq1_wptr} <= 0;
    else
      {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
  end

endmodule

