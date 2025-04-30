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
    output logic [1:0]              BRESP,
    input  logic                    BREADY,

    // Read Address Channel
    input  logic [ADDR_WIDTH-1:0]   ARADDR,
    input  logic                    ARVALID,
    output logic                    ARREADY,

    // Read Data Channel
    output logic [DATA_WIDTH-1:0]   RDATA,
    output logic                    RVALID,
    output logic [1:0]              RRESP,
    input  logic                    RREADY
);

  // Register file
  logic [DATA_WIDTH-1:0] reg_file [0:3];

  // Internal latches
  logic [ADDR_WIDTH-1:0] awaddr_latched;

  // ---------------------------
  // Write Address & Data Handling
  // ---------------------------
  typedef enum logic [1:0] {IDLE, ADDR_DATA, RESP} write_state_t;
  write_state_t write_state;

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      AWREADY <= 0;
      WREADY  <= 0;
      BVALID  <= 0;
      BRESP   <= 2'b00;
      write_state <= IDLE;
    end else begin
      case (write_state)
        IDLE: begin
          if (AWVALID && WVALID) begin
            AWREADY <= 1;
            WREADY  <= 1;
            write_state <= ADDR_DATA;
          end
        end

        ADDR_DATA: begin
          if (AWREADY && AWVALID && WREADY && WVALID) begin
            AWREADY <= 0;
            WREADY  <= 0;
            awaddr_latched <= AWADDR;

            // Byte-wise write using WSTRB
            for (int i = 0; i < 4; i++) begin
              if (WSTRB[i])
                reg_file[AWADDR[3:2]][8*i +: 8] <= WDATA[8*i +: 8];
            end

            BVALID <= 1;
            BRESP  <= 2'b00; // OKAY
            write_state <= RESP;
          end
        end

        RESP: begin
          if (BVALID && BREADY) begin
            BVALID <= 0;
            write_state <= IDLE;
          end
        end
      endcase
    end
  end

  // ---------------------------
  // Read Address Handling
  // ---------------------------
  typedef enum logic [1:0] {RIDLE, RDATA} read_state_t;
  read_state_t read_state;

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      ARREADY <= 0;
      RVALID  <= 0;
      RDATA   <= 0;
      RRESP   <= 2'b00;
      read_state <= RIDLE;
    end else begin
      case (read_state)
        RIDLE: begin
          if (ARVALID) begin
            ARREADY <= 1;
            read_state <= RDATA;
          end
        end

        RDATA: begin
          if (ARVALID && ARREADY) begin
            ARREADY <= 0;
            RDATA   <= reg_file[ARADDR[3:2]];
            RVALID  <= 1;
            RRESP   <= 2'b00; // OKAY
            read_state <= RIDLE;
          end

          if (RVALID && RREADY)
            RVALID <= 0;
        end
      endcase
    end
  end

  // ---------------------------
  // Register Reset
  // ---------------------------
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      for (int i = 0; i < 4; i++) begin
        reg_file[i] <= '0;
      end
    end
  end

endmodule
