class axi_coverage;
  // Transactions for sampling
  read_txn rtx;
  write_txn wtx;

  // Covergroup for READ transactions
  covergroup cg_read;
    coverpoint rtx.ARADDR {
      bins addr_vals[] = {0, 4, 8, 12};
    }

    coverpoint rtx.RDATA {
      bins low_data   = {[0:15]};
      bins mid_data   = {[16:255]};
      bins high_data  = {[256:65535]};
    }
    
    
  endgroup

  // Covergroup for WRITE transactions
 covergroup cg_write;

  // Address coverpoint with explicit bins
  cp_awaddr : coverpoint wtx.AWADDR {
    bins addr_vals[] = {0, 4, 8, 12};
  }

  cp_wdata : coverpoint wtx.WDATA {
    bins low_data   = {[0:15]};
    bins mid_data   = {[16:255]};
    bins high_data  = {[256:65535]};
  }

  cp_wstrb : coverpoint wtx.WSTRB {
    bins strobe_1bit  = {[1:1]};
    bins strobe_2bit  = {[2:3]};
    bins strobe_4bit  = {[4:15]};
  }

  
  cross cp_awaddr, cp_wstrb;

endgroup



  // Constructor
  function new();
    cg_read = new();
    cg_write = new();
  endfunction

  // Sample functions
  task sample_read(read_txn t);
    rtx = t;
    cg_read.sample();
  endtask

  task sample_write(write_txn t);
    wtx = t;
    cg_write.sample();
  endtask

endclass
