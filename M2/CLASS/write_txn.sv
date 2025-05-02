class write_txn;
  rand bit [3:0] AWADDR;
  rand bit [31:0] WDATA;
  rand bit [3 :0] WSTRB;

  constraint AWADDR_range{AWADDR inside {0, 4, 8, 12};};
  constraint WSTRB_valid {WSTRB <16;};

endclass
