//Team 3 AXI 4 Lite interface defined with modports

interface axi_if #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 32) (input logic ACLK, input logic ARESETn);
  logic [ADDR_WIDTH-1:0] AWADDR;
  logic                  AWVALID;
  logic                  AWREADY;

  logic [DATA_WIDTH-1:0] WDATA;
  logic [(DATA_WIDTH/8)-1:0] WSTRB;
  logic                  WVALID;
  logic                  WREADY;

  logic                  BVALID;
  //logic [1:0]            BRESP;
  logic                  BREADY;

  logic [ADDR_WIDTH-1:0] ARADDR;
  logic                  ARVALID;
  logic                  ARREADY;

  logic [DATA_WIDTH-1:0] RDATA;
  logic                  RVALID;
  //logic [1:0]            RRESP;
  logic                  RREADY;

  modport DUT (input ACLK, input ARESETn,
               input AWADDR, input AWVALID, output AWREADY,
               input WDATA, input WSTRB, input WVALID, output WREADY,
               output BVALID, input BREADY,
               input ARADDR, input ARVALID, output ARREADY,
               output RDATA, output RVALID, input RREADY);

  modport TB (input ACLK, input ARESETn,
              output AWADDR, output AWVALID, input AWREADY,
              output WDATA, output WSTRB, output WVALID, input WREADY,
              input BVALID, output BREADY,
              output ARADDR, output ARVALID, input ARREADY,
              input RDATA, input RVALID,output RREADY);
endinterface
