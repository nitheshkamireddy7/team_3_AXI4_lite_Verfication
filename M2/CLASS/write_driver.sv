class write_driver;
  mailbox #(write_txn) wbox;
  virtual axi_if axi;

  // Constructor with correct virtual interface declaration
  function new(mailbox #(write_txn) wbox, virtual axi_if axi);
    this.wbox = wbox;
    this.axi  = axi;
  endfunction

  // Run task
  task run;
    write_txn wtx; 
    forever begin
      wbox.get(wtx);

      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;
      $display("DRIVER: Sending write Addr=%0d, WSTRB=%b, WDATA=%h",
          wtx.AWADDR, wtx.WSTRB, wtx.WDATA);

      

      wait (axi.AWREADY && axi.WREADY);

      

      wait (axi.BVALID);
      axi.BREADY <= 1;

      @(posedge axi.ACLK);  // Wait for a clock cycle
      axi.BREADY <= 0;
      
      
    end
  endtask
endclass
