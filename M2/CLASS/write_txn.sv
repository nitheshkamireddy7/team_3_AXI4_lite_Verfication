class write_txn;
  rand bit [3:0] AWADDR;
  rand bit [31:0] WDATA;
  rand bit [3 :0] WSTRB;

  constraint AWADDR_range{AWADDR<4}};
  constraint WSTRB_valid {WSTRB inside{[15:0]};
  constraint WDATA_random { WDATA inside {[0:$]};
endclass

  
