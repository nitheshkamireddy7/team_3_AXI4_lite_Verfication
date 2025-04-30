class read_txn;
  rand bit [3:0] ARADDR;

  constraint ARADDR_range{ARADDR < 4;};
endclass
