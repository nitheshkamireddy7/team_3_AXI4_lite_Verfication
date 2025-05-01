`timescale 1ns/1ps


`include "axi_if.sv"
`include "write_txn.sv"
`include "read_txn.sv"
`include "write_generator.sv"
`include "read_generator.sv"
`include "write_driver.sv"
`include "read_driver.sv"
`include "write_monitor.sv"
`include "read_monitor.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "dut.sv"  // your RTL (must match interface ports)


module tb_top;

  logic ACLK;
  logic ARESETn;

  
  initial ACLK = 0;
  always #5 ACLK = ~ACLK;

  
  initial begin
    ARESETn = 0;
    repeat (2) @(posedge ACLK);
    ARESETn = 1;
  end

  
  axi_if axi(ACLK,ARESETn);

  
  dut dut_inst (
    .ACLK     (ACLK),
    .ARESETn  (ARESETn),
    .AWADDR   (axi.AWADDR),
    .AWVALID  (axi.AWVALID),
    .AWREADY  (axi.AWREADY),
    .WDATA    (axi.WDATA),
    .WSTRB    (axi.WSTRB),
    .WVALID   (axi.WVALID),
    .WREADY   (axi.WREADY),
    .BVALID   (axi.BVALID),
    .BREADY   (axi.BREADY),
    .ARADDR   (axi.ARADDR),
    .ARVALID  (axi.ARVALID),
    .ARREADY  (axi.ARREADY),
    .RDATA    (axi.RDATA),
    .RVALID   (axi.RVALID),
    .RREADY   (axi.RREADY)
  );

  
  initial begin
    env e = new(axi);
    e.run();
  end

endmodule
