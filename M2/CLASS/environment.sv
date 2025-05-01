class environment;
  virtual axi_if axi;

  mailbox #(read_txn) rbox;
  mailbox #(read_txn) rsbox;
  mailbox #(write_txn) wbox;
  mailbox #(write_txn) wsbox;

  write_generator wgen;
  read_generator  rgen;
  write_driver    wdrv;
  read_driver     rdrv;
  write_monitor   wmon;
  read_monitor    rmon;
  scoreboard      sb;
  
  function new(axi_if axi);
    this.axi = axi;
  
    rbox = new();
    rsbox = new();
    wbox = new();
    wsbox = new();
    wgen = new(wbox);
    rgen = new(rbox);
    wdrv = new(wbox,axi);
    rdrv = new(rbox,axi);
    wmon = new(wsbox,axi);
    rmon = new(rsbox,axi);
    sb = new(wsbox,rsbox);
  endfunction

  
    task run;
    fork
      wgen.run();
      rgen.run();
      wdrv.run();
      rdrv.run();
      wmon.run();
      rmon.run();
      sb.run();
    join_none
  endtask
endclass
  
  
