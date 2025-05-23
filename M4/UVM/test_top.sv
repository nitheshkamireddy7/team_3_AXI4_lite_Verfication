`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "axi_if.sv"

`include "write_txn_uvm.sv"
`include "read_txn_uvm.sv"
`include "write_sequence.sv"
`include "read_sequence.sv"
`include "write_sequencer.sv"
`include "read_sequencer.sv"
`include "write_driver.sv"
`include "read_driver.sv"
`include "scoreboard_txn.sv"
`include "write_monitor.sv"
`include "read_monitor.sv"

`include "write_agent.sv"
`include "read_agent.sv"

`include "scoreboard.sv"
`include "coverage.sv"

`include "report.sv"
`include "environment.sv"

`include "test.sv"

module test_top;

  bit clk;
  bit rst;

  // Clock generation
  always #5 clk = ~clk;

  // Instantiate interface
  axi_if axi(clk, rst);

  // DUT instance
  axi_lite_slave dut_inst (
    .ACLK(clk),
    .ARESETn(rst),
    .AWVALID(axi.AWVALID),
    .AWREADY(axi.AWREADY),
    .AWADDR(axi.AWADDR),
    .WDATA(axi.WDATA),
    .WSTRB(axi.WSTRB),
    .WVALID(axi.WVALID),
    .WREADY(axi.WREADY),
    .BVALID(axi.BVALID),
    .BREADY(axi.BREADY),
    .ARADDR(axi.ARADDR),
    .ARVALID(axi.ARVALID),
    .ARREADY(axi.ARREADY),
    .RDATA(axi.RDATA),
    .RVALID(axi.RVALID),
    .RREADY(axi.RREADY)
  );

  // UVM test start at time 0
  initial begin
    my_report_server server;
      server = new();  
    uvm_report_server::set_server(server);
    clk = 0;
    rst = 0;

    uvm_config_db#(virtual axi_if)::set(null, "*", "axi", axi);
    
    
  
  
    run_test("axi_test");
  end

  // Reset release after delay
  initial begin
    #20 rst = 1;
  end

endmodule
