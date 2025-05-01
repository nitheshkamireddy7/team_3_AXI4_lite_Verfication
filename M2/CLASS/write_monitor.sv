class write_monitor;
  virtual axi_if axi;
  mailbox #(write_txn) wsbox;
  function new(mailbox #(write_txn) wsbox, axi_if axi);
    this.axi = axi;
    this.wsbox = wsbox;
  endfunction

  task run;
    forever begin
    wait (axi.AWVALID && axi.AWREADY);
    wait (axi.WVALID && axi.WREADY);
      @(posedge axi.ACLK);
    write_txn wtx;
    wtx = new();
    wtx.AWADDR = axi.AWADDR;
    wtx.WSTRB  = axi.WSTRB;
    wtx.WDATA  = axi.WDATA;
      wsbox.put(wtx);
    end
  endtask
endclass

