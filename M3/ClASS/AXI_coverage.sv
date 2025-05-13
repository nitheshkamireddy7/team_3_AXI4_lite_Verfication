class axi_coverage;
  
  read_txn rtx;
  write_txn wtx;

  
  covergroup cg_read;
    coverpoint rtx.ARADDR {
      bins addr_vals[] = {0, 4, 8, 12};
    }

    coverpoint rtx.RDATA {
      bins data_bins[] = {[0:32'hFFFF]};
    }

    cross rtx.ARADDR, rtx.RDATA;
  endgroup

  
  covergroup cg_write;
    coverpoint wtx.AWADDR {
      bins addr_vals[] = {0, 4, 8, 12};
    }

    coverpoint wtx.WDATA {
      bins data_bins[] = {[0:32'hFFFF]};
    }

    coverpoint wtx.WSTRB {
      bins strobe_vals[] = {[0:15]};
    }

    cross wtx.AWADDR, wtx.WDATA, wtx.WSTRB;
  endgroup

  
  function new();
    cg_read = new();
    cg_write = new();
  endfunction

  
  task sample_read(read_txn t);
    rtx = t;
    cg_read.sample();
  endtask

  task sample_write(write_txn t);
    wtx = t;
    cg_write.sample();
  endtask

endclass
