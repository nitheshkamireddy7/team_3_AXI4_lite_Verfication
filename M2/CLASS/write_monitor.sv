class write_monitor;
  virtual axi_if axi;
  mailbox #(write_txn) wtx;
  function new(mailbox #(write_txn) wtx, axi_if axi);
