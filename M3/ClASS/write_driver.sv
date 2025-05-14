class write_driver;
  mailbox #(write_txn) wbox;
  virtual axi_if axi;

  function new(mailbox #(write_txn) wbox, virtual axi_if axi);
    this.wbox = wbox;
    this.axi  = axi;
  endfunction

  task run;
    write_txn wtx;
    wbox.get(wtx);

      // Drive address and data
      @(posedge axi.ACLK);
      @(posedge axi.ACLK);

      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 0;
      axi.WVALID  <= 1;
      axi.BREADY  <= 0;
       @(posedge axi.ACLK);
      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;
      axi.BREADY  <= 1;
      

     

      // Wait for both AWREADY and WREADY handshake
      wait (axi.AWREADY && axi.WREADY);

      
      

      // Wait for BVALID and assert BREADY
      wait (axi.BVALID);
      @(posedge axi.ACLK);
      axi.BREADY <= 0;
       @(posedge axi.ACLK);
      axi.BREADY <= 1;

      

      // Drive address and data
      @(posedge axi.ACLK);
      wbox.get(wtx);
      @(posedge axi.ACLK);

      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 0;
      axi.BREADY  <= 0;
       @(posedge axi.ACLK);
      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;
      axi.BREADY  <= 1;
      

     

      // Wait for both AWREADY and WREADY handshake
      wait (axi.AWREADY && axi.WREADY);

      
      

      // Wait for BVALID and assert BREADY
      wait (axi.BVALID);
      @(posedge axi.ACLK);
      axi.BREADY <= 1;
      


      


    forever begin
      wbox.get(wtx);

      // Drive address and data
      @(posedge axi.ACLK);
      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;
      axi.BREADY  <= 0;

     

      // Wait for both AWREADY and WREADY handshake
      wait (axi.AWREADY && axi.WREADY);

      
      

      // Wait for BVALID and assert BREADY
      wait (axi.BVALID);
      @(posedge axi.ACLK);
      axi.BREADY <= 1;

      
    end
  endtask
endclass
