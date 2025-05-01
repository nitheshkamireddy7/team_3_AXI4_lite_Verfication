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
`include "environment.sv"
`include "AXI_SLAVE.sv"

module tb_top;

  // Clock and Reset
  logic ACLK;
  logic ARESETn;

  // Clock Generation
  initial ACLK = 0;
  always #5 ACLK = ~ACLK;  // 100MHz

  // Reset Generation
  initial begin
    ARESETn = 0;
    repeat(2) @(posedge ACLK);
    ARESETn = 1;
  end

  // Interface instantiation
  axi_if axi(ACLK, ARESETn);

  // DUT instantiation
  axi_lite_slave #(.ADDR_WIDTH(4), .DATA_WIDTH(32)) dut (
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

  // Environment instantiation and execution
  environment e;

  initial begin
    e = new(axi);
    e.run();
  end

  // Optional simulation stop
  initial begin
    #2000;
    $display("Simulation completed.");
    $finish;
  end

endmodule
