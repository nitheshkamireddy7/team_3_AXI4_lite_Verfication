class axi_coverage extends uvm_subscriber#(scoreboard_txn);

  `uvm_component_utils(axi_coverage)

  
  read_txn  rtx;
  write_txn wtx;

  
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

  // WRITE covergroup
  covergroup cg_write;
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
  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_read = new();
    cg_write = new();
  endfunction

  // UVM callback: triggered when analysis port sends data
  function void write(scoreboard_txn t);  
  if (t.txn_type == WRITE_TXN) begin
    this.wtx = t.wtx;
    cg_write.sample();
  end else if (t.txn_type == READ_TXN) begin
    this.rtx = t.rtx;
    cg_read.sample();
  end
endfunction


endclass

