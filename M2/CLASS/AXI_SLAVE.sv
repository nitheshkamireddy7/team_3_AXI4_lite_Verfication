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

  // ---------------------------
  // Internal State and Registers
  // ---------------------------
  typedef enum logic [1:0] {IDLE, ADDR_DATA, RESP} write_state_t;
  typedef enum logic [1:0] {RIDLE, RDATA_STATE} read_state_t;

  write_state_t write_state;
  read_state_t  read_state;

  logic [DATA_WIDTH-1:0] reg_file [0:3];
  logic [ADDR_WIDTH-1:0] awaddr_latched;

  // ---------------------------
  // Write Channel FSM (with continuous AWREADY/WREADY in IDLE)
  // ---------------------------
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      AWREADY     <= 0;
      WREADY      <= 0;
      BVALID      <= 0;
      write_state <= IDLE;
      for (int i = 0; i < 4; i++) begin
        reg_file[i] <= '0;
      end
    end else begin
      case (write_state)
        IDLE: begin
          AWREADY <= 1;
          WREADY  <= 1;
          if (AWVALID && WVALID) begin
            write_state <= ADDR_DATA;
          end
        end

        ADDR_DATA: begin
          if (AWVALID && AWREADY && WVALID && WREADY) begin
            AWREADY        <= 0;
            WREADY         <= 0;
            awaddr_latched <= AWADDR;

            // Apply byte-wise write
            for (int i = 0; i < 4; i++) begin
              if (WSTRB[i])
                reg_file[AWADDR[3:2]][8*i +: 8] <= WDATA[8*i +: 8];
            end

            BVALID      <= 1;
            write_state <= RESP;
          end
        end

        RESP: begin
        if (BVALID && BREADY) begin
        BVALID      <= 0;
        AWREADY     <= 1;   // <-- add this
        WREADY      <= 1;   // <-- and this
       write_state <= IDLE;
       end
       end

      endcase
    end
  end

  // ---------------------------
  // Read Channel FSM
  // ---------------------------
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      ARREADY     <= 0;
      RVALID      <= 0;
      RDATA       <= 0;
      read_state  <= RIDLE;
    end else begin
      case (read_state)
        RIDLE: begin
          if (ARVALID) begin
            ARREADY    <= 1;
            read_state <= RDATA_STATE;
          end
        end

        RDATA_STATE: begin
          if (ARVALID && ARREADY) begin
            
            RDATA   <= reg_file[ARADDR[3:2]];
            RVALID  <= 1;
            read_state <= RIDLE;
          end

          if (RVALID && RREADY)
            RVALID <= 0;
        end
      endcase
    end
  end

endmodule
