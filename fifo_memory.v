`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 10:46:40
// Design Name: 
// Module Name: fifo_memory
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
// FIFO Memory (Verilog-2001 for Vivado)
//====================================================
module fifomem
#(
  parameter DATASIZE = 8, // Memory data word width
  parameter ADDRSIZE = 4  // Number of mem address bits
)
(
  input   winc, wfull, wclk,
  input   [ADDRSIZE-1:0] waddr, raddr,
  input   [DATASIZE-1:0] wdata,
  output  [DATASIZE-1:0] rdata
);

  // Depth = 2^ADDRSIZE
  localparam DEPTH = 1 << ADDRSIZE;

  // Memory declaration
  reg [DATASIZE-1:0] mem [0:DEPTH-1];

  // Asynchronous read (combinational)
  assign rdata = mem[raddr];

  // Synchronous write
  always @(posedge wclk) begin
    if (winc && !wfull)
      mem[waddr] <= wdata;
  end

endmodule
