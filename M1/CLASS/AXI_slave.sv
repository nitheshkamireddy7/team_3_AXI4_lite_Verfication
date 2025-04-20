/*
 -------------------------------------------------------------------------------
  File       : axi_lite_slave.sv
  Description: AXI4-Lite Slave Interface
               - Implements AXI4-Lite protocol with 5 channels:
                 • Write Address (AW)
                 • Write Data (W)
                 • Write Response (B)
                 • Read Address (AR)
                 • Read Data (R)
               - Supports 32-bit data width and 4 register locations
               - Implements full byte-wise write using WSTRB
               - Full-duplex communication with handshake signaling:
                   * AWVALID/AWREADY for address phase
                   * WVALID/WREADY for data phase
                   * BVALID/BREADY for response
                   * ARVALID/ARREADY for read address
                   * RVALID/RREADY for read data

               This design ensures memory-mapped access with selective byte 
               updates, following AXI4-Lite timing requirements.

  Notes      : Master is an testbench to verify our slave axi interface
  Author     : Team3
  Date       : 2025-04-18
 -------------------------------------------------------------------------------
*/


module axi_lite_slave #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 32
)(
    input  logic                    ACLK,
    input  logic                    ARESETn,

    // Write Address Channel
    input  logic [ADDR_WIDTH-1:0]   AWADDR,
    input  logic                    AWVALID,
    output logic                    AWREADY,

    // Write Data Channel
    input  logic [DATA_WIDTH-1:0]   WDATA,
    input  logic [(DATA_WIDTH/8)-1:0] WSTRB,
    input  logic                    WVALID,
    output logic                    WREADY,

    // Write Response Channel
    output logic                    BVALID,
    input  logic                    BREADY,

    // Read Address Channel
    input  logic [ADDR_WIDTH-1:0]   ARADDR,
    input  logic                    ARVALID,
    output logic                    ARREADY,

    // Read Data Channel
    output logic [DATA_WIDTH-1:0]   RDATA,
    output logic                    RVALID,
    input  logic                    RREADY
);

  // 
  logic [DATA_WIDTH-1:0] reg_file [0:3];
  logic [ADDR_WIDTH-1:0] awaddr_latched;

  // ----------------------------------
  // Write Logic
  
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      AWREADY <= 0;
      WREADY  <= 0;
      BVALID  <= 0;
    end else begin
      // Handshake for AW
      if (!AWREADY && AWVALID)
        AWREADY <= 1;

      // Handshake for W
      if (!WREADY && WVALID)
        WREADY <= 1;

      // If both handshakes done — do the write
      if (AWVALID && AWREADY && WVALID && WREADY) begin
        AWREADY <= 0;
        WREADY  <= 0;
        awaddr_latched = AWADDR;

        // Full byte-wise write using WSTRB
        for (int i = 0; i < 4; i++) begin
          if (WSTRB[i]) begin
            reg_file[awaddr_latched[3:2]][8*i +: 8] <= WDATA[8*i +: 8];
          end
        end

        BVALID <= 1; // Signal write response
      end

      // Complete the write response handshake
      if (BVALID && BREADY)
        BVALID <= 0;
    end
  end

  // ----------------------------------
  // Read Logic

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      ARREADY <= 0;
      RVALID  <= 0;
      RDATA   <= 0;
    end else begin
      if (!ARREADY && ARVALID)
        ARREADY <= 1;

      if (ARVALID && ARREADY) begin
        ARREADY <= 0;
        RDATA   <= reg_file[ARADDR[3:2]];
        RVALID  <= 1;
      end

      if (RVALID && RREADY)
        RVALID <= 0;
    end
  end

endmodule
