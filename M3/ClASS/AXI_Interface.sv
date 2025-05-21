
//Team 3 AXI 4 Lite interface defined with modports

interface axi_if (input logic ACLK, input logic ARESETn);
  logic [3:0] AWADDR;
  logic                  AWVALID;
  logic                  AWREADY;

  logic [31:0] WDATA;
  logic [3:0] WSTRB;
  logic                  WVALID;
  logic                  WREADY;

  logic                  BVALID;
  //logic [1:0]            BRESP;
  logic                  BREADY;

  logic [3:0] ARADDR;
  logic                  ARVALID;
  logic                  ARREADY;

  logic [31:0] RDATA;
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
