module tb_axi_lite_slave;

  parameter ADDR_WIDTH = 4;
  parameter DATA_WIDTH = 32;

  // Clock & Reset
  logic ACLK = 0;
  logic ARESETn;

  // AXI Lite Interface Signals
  logic [ADDR_WIDTH-1:0] AWADDR;
  logic AWVALID;
  logic AWREADY;

  logic [DATA_WIDTH-1:0] WDATA;
  logic [(DATA_WIDTH/8)-1:0] WSTRB;
  logic WVALID;
  logic WREADY;

  logic BVALID;
  logic BREADY;

  logic [ADDR_WIDTH-1:0] ARADDR;
  logic ARVALID;
  logic ARREADY;

  logic [DATA_WIDTH-1:0] RDATA;
  logic RVALID;
  logic RREADY;

  // DUT instantiation
  axi_lite_slave #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .ACLK,
    .ARESETn,
    .AWADDR,
    .AWVALID,
    .AWREADY,
    .WDATA,
    .WSTRB,
    .WVALID,
    .WREADY,
    .BVALID,
    .BREADY,
    .ARADDR,
    .ARVALID,
    .ARREADY,
    .RDATA,
    .RVALID,
    .RREADY
  );

  // Clock generation
  always #5 ACLK = ~ACLK;

  // Reset sequence
  initial begin
    ARESETn = 0;
    repeat(3) @(posedge ACLK);
    ARESETn = 1;
  end

  // Task: AXI Write
  task automatic axi_write(
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] data,
    input [(DATA_WIDTH/8)-1:0] strb
  );
    begin
      AWADDR  = addr;
      AWVALID = 1;
      WDATA   = data;
      WSTRB   = strb;
      WVALID  = 1;
      BREADY  = 1;

      wait (AWREADY && AWVALID);
      @(posedge ACLK);
      AWVALID = 0;

      wait (WREADY && WVALID);
      @(posedge ACLK);
      WVALID = 0;

      wait (BVALID);
      @(posedge ACLK);
      BREADY = 0;
    end
  endtask

  // Task: AXI Read
  task automatic axi_read(
    input  [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data_out
  );
    begin
      ARADDR  = addr;
      ARVALID = 1;
      RREADY  = 1;

      wait (ARREADY && ARVALID);
      @(posedge ACLK);
      ARVALID = 0;

      wait (RVALID);
      data_out = RDATA;
      @(posedge ACLK);
      RREADY = 0;
    end
  endtask

  // Main test sequence
  initial begin
    // Declarations MUST be before any procedural code
    logic [DATA_WIDTH-1:0] expected_data;
    logic [DATA_WIDTH-1:0] read_data;

    // Wait for reset to complete
    wait (ARESETn);
    @(posedge ACLK);

    // Test 1: Full Write and Read
    $display("TEST 1: Full Write and Read");
    expected_data = 32'h12345678;
    axi_write(4'h4, expected_data, 4'b1111);
    axi_read(4'h4, read_data);

    if (read_data == expected_data)
      $display("PASS: Read = 0x%08h", read_data);
    else
      $display("FAIL: Expected 0x%08h, Got 0x%08h", expected_data, read_data);

    // Test 2: Partial Write (only upper two bytes)
    $display("\nTEST 2: Partial Write (Upper Bytes Only)");
    expected_data = 32'hDEADBEEF;
    axi_write(4'h8, expected_data, 4'b1100);  // only upper bytes
    axi_read(4'h8, read_data);

    $display("Partial Write Read Back = 0x%08h", read_data);
    if (read_data[31:16] == 16'hDEAD)
      $display("PASS: Upper bytes correctly written.");
    else
      $display("FAIL: Expected 0xDEAD, Got 0x%04h", read_data[31:16]);

    // Simulation complete
    $display("\nAll tests completed.");
    $finish;
  end

endmodule
