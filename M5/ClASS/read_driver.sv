class read_driver;
  mailbox #(read_txn) rbox;
  virtual axi_if axi;

  function new(mailbox #(read_txn) rbox, virtual axi_if axi);
    this.rbox = rbox;
    this.axi  = axi;
  endfunction

  task run;
    read_txn rtx;
    forever begin
      rbox.get(rtx);

      
      @(posedge axi.ACLK);
      axi.ARADDR  <= rtx.ARADDR;
      axi.ARVALID <= 1;

      $display("READ DRIVER: ARADDR = %0d", rtx.ARADDR);

      
      wait (axi.ARREADY);

      @(posedge axi.ACLK);
      axi.ARVALID <= 0;  
      
      wait (axi.RVALID);

      
      rtx.RDATA = axi.RDATA;

      
      @(posedge axi.ACLK);
      axi.RREADY <= 1;

      @(posedge axi.ACLK);
      axi.RREADY <= 0;

      
    end
  endtask
endclass
