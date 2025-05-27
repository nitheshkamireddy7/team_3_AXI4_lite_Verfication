class write_monitor;
  virtual axi_if axi;
  mailbox #(write_txn) wsbox;
  mailbox #(write_txn) wcov;


  function new(mailbox #(write_txn) wsbox, virtual axi_if axi, mailbox #(write_txn) wcov);
    this.axi   = axi;
    this.wsbox = wsbox;
    this.wcov = wcov;
  endfunction

  // Run task
  task run;
    write_txn wtx; 
    forever begin
      wait (axi.AWVALID && axi.AWREADY);
      wait (axi.WVALID && axi.WREADY);
      @(posedge axi.ACLK);

      wtx = new();  // create a fresh transaction
      wtx.AWADDR = axi.AWADDR;
      wtx.WSTRB  = axi.WSTRB;
      wtx.WDATA  = axi.WDATA;
      //$display("MONITOR: Captured write to addr=%0d, wstrb=%b, data=%h", wtx.AWADDR, wtx.WSTRB, wtx.WDATA);


      wsbox.put(wtx);
      wcov.put(wtx);
    end
  endtask
endclass