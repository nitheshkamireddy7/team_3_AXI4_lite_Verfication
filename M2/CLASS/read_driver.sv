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

      // Drive read address and assert ARVALID
      axi.ARADDR  <= rtx.ARADDR;
      axi.ARVALID <= 1;

      // Wait for AR handshake
      wait (axi.ARREADY);
      axi.ARVALID <= 0;

      // Wait for read data response
      wait (axi.RVALID);
      axi.RREADY <= 1;
      @(posedge axi.ACLK);
      axi.RREADY <= 0;

      // Optional delay to space transactions
      @(posedge axi.ACLK);
    end
  endtask
endclass
