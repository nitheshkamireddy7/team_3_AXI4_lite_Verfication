class read_monitor;
  virtual axi_if axi;
  mailbox #(read_txn) rsbox;

  // Constructor
  function new(mailbox #(read_txn) rsbox, virtual axi_if axi);
    this.axi   = axi;
    this.rsbox = rsbox;
  endfunction

  // Run task
  task run;
    read_txn rtx;
    bit [3:0] addr;
    forever begin
      // Wait for read address handshake
      wait (axi.ARVALID && axi.ARREADY);
      addr = axi.ARADDR;  

      // Wait for read data handshake
      wait (axi.RVALID && axi.RREADY);
      rtx = new();
      rtx.ARADDR = addr;
      rtx.RDATA  = axi.RDATA;
      rsbox.put(rtx);

      // Wait for RVALID and RREADY to go low before next read
      @(posedge axi.ACLK);
      wait (!(axi.RVALID && axi.RREADY));
    end
  endtask
endclass
