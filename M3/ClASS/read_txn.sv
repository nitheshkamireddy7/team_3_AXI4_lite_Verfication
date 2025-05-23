class read_txn;
  rand bit [3:0] ARADDR;
  logic [31:0] RDATA;
  constraint ARADDR_range{ARADDR inside {0, 4, 8, 12};};
endclass
