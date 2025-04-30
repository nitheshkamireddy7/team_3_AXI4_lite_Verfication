class read_driver;
  mailbox #(read_txn) rbox;
  virtual axi_vif axi;
  function new(mailbox #(read_txn) rbox,axi_vif axi);
    this.rbox = rbox;
    this.axi = axi;
  endfunction

  task run;
    read_txn rtx;
    forever begin
      rbox.get(rtx);
      axi.ARADDR <= rtx.ARADDR;
      axi.ARVALID <= 1;
      wait(axi.ARREADY);
      axi.ARVALID <= 0;
      wait(axi.RVALID);
      axi.RREADY <=1;
      @(posedge axi.ACLK);
      axi.RREADY = 0;  
    end
  endtask
endclass
