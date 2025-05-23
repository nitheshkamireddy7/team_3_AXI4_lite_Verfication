class write_txn extends uvm_sequence_item;

  rand bit [3:0]  AWADDR;
  rand bit [31:0] WDATA;
  rand bit [3:0]  WSTRB;

  constraint AWADDR_range {
    AWADDR inside {0, 4, 8, 12};
  }

  constraint WSTRB_valid {
    WSTRB inside {[1:15]};
  }

  // Disable WDATA constraints, we'll handle it manually
  constraint no_wdata_c { soft WDATA == WDATA; } // dummy to keep legal

  `uvm_object_utils(write_txn)

  function new(string name = "write_txn");
    super.new(name);
  endfunction

  // Manual control after randomization
  function void post_randomize();
    randcase
      1: WDATA = $urandom_range(0, 15);       // Low bin
      1: WDATA = $urandom_range(16, 255);     // Mid bin
      1: WDATA = $urandom_range(256, 65535);  // High bin
    endcase
  endfunction

endclass
