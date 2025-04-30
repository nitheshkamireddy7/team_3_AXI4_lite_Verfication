class write_driver;
  mailbox #(write_txn) wbox;
  virtual axi_if axi;

  function new(mailbox #(write_txn),axi_if axi);
    this.wbox = wbox;
    this.axi = axi;
  endfunction

  task run;
    wbox.get(wtx);
    axi.WDATA = wtx.WDATA;
    axi.AWADDR = wtx.AWADDR;
    axi.WSTRB  = wtx.WSTRB;
    axi.AWVALID = 1;
    axi.WVAILD = 1;
    wait(axi.AWREADY && axi.WREADY);
    axi.AWREADY = 0;
    axi.WREADY  = 0;
    wait(axi.BVALID);
    axi.BREADY = 1;
    @posedge(axi.ACLK);
    axi.BREDAY =0;
    //end of transaction
  endtask
endclass
    
    
