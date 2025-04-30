class write_driver;
  mailbox #(write_txn) wbox;
  virtual axi_if axi;

 class write_driver;
  mailbox #(write_txn) wbox;
  virtual axi_if axi;

  function new(mailbox #(write_txn) wbox, axi_if axi);
    this.wbox = wbox;
    this.axi  = axi;
  endfunction

  task run;
    write_txn wtx;
    forever begin
      wbox.get(wtx);

      
      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;

      
      wait (axi.AWREADY && axi.WREADY);

      axi.AWVALID <= 0;
      axi.WVALID  <= 0;
      wait (axi.BVALID);
      axi.BREADY <= 1;
      @(posedge axi.ACLK);   
      axi.BREADY <= 0;
    end
  endtask
endclass
    
    
