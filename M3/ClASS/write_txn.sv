class write_txn;
  rand bit [3:0]  AWADDR;
  rand bit [31:0] WDATA;
  rand bit [3:0]  WSTRB;

  
  constraint AWADDR_range {
    AWADDR inside {0, 4, 8, 12};
  }

  
  constraint WSTRB_valid {
    WSTRB inside {[1:15]};
  }

  
  constraint WDATA_range {
    WDATA dist {
      [0:15]        := 1,   // low range
      [16:255]      := 1,   // mid range
      [256:65535]   := 1    // high range
    };
  }

endclass
