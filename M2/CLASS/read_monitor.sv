class read_monitor;
  virtual axi_if axi;
  mailbox #(read_txn) rsbox;
  function new(mailbox #(read_txn) rsbox,axi_if axi);
    this.axi = axi;
    this.rsbox = rsbox;
  endfunction

  task run;
  read_txn rtx;
  forever begin
    wait(axi.ARVALID && axi.ARREADY);
    bit [3:0] addr = axi.ARADDR;

    
    wait(axi.RVALID && axi.RREADY);
    @(posedge axi.ACLK);

    
    rtx = new();
    rtx.ARADDR = addr;
    rtx.RDATA  = axi.RDATA;
    rsbox.put(rtx);
  end
endtask

   
    
