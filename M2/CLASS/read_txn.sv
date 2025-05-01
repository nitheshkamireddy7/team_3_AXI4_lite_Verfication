class read_txn;
  rand bit [3:0] ARADDR;
  logic [31:0] RDATA;
  constraint ARADDR_range{ARADDR < 4;};
endclass
