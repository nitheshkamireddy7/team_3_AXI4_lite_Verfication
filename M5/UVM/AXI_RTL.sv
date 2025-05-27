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
  // Write Channel FSM 
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
      unique case (write_state)
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
        AWREADY     <= 0;   // <-- add this
        WREADY      <= 0;   // <-- and this
       write_state <= IDLE;
       end
       end

      endcase
    end
  end

  // ---------------------------
  // Read Channel FSM
  // ---------------------------
  logic [ADDR_WIDTH-1:0] araddr_latched;

always_ff @(posedge ACLK or negedge ARESETn) begin
  if (!ARESETn) begin
    ARREADY     <= 0;
    RVALID      <= 0;
    RDATA       <= 0;
    araddr_latched <= 0;
    read_state  <= RIDLE;
  end else begin
   unique case (read_state)
      RIDLE: begin
        if (ARVALID) begin
          ARREADY        <= 1;
        end

        if (ARVALID && ARREADY) begin
          araddr_latched <= ARADDR;     
          ARREADY        <= 0;
          read_state     <= RDATA_STATE;
        end
      end

      RDATA_STATE: begin
`ifdef AXI_BUG
  
  RDATA <= reg_file[araddr_latched[1:0]];
`else
  // Correct: Return full 32-bit word from register file
  RDATA <= reg_file[araddr_latched[3:2]];
`endif
  RVALID <= 1;

  if (RVALID && RREADY) begin
    RVALID     <= 0;
    RDATA <= 'x;
    read_state <= RIDLE;
  end
end

    endcase
  end
end


endmodule
