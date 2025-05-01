module tb_top;

  
  logic ACLK;
  logic ARESETn;

  /
  initial ACLK = 0;
  always #5 ACLK = ~ACLK;  // 100MHz clock

  
  axi_if axi();

  
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
    ARESETn = 0;
    repeat (2) @(posedge ACLK);
    ARESETn = 1;
  end

  
  initial begin
    env e;
    e = new(axi);        
    e.run();             
  end

endmodule
