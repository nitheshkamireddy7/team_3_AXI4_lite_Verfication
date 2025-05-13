class environment;
  virtual axi_if axi;

  // Mailboxes
  mailbox #(read_txn)  rbox;
  mailbox #(read_txn)  rsbox;
  mailbox #(read_txn)  rcov;   // Added for read coverage
  mailbox #(write_txn) wbox;
  mailbox #(write_txn) wsbox;
  mailbox #(write_txn) wcov;   // Added for write coverage

  // Component handles
  write_generator wgen;
  read_generator  rgen;
  write_driver    wdrv;
  read_driver     rdrv;
  write_monitor   wmon;
  read_monitor    rmon;
  scoreboard      sb;
  axi_coverage    cov;  // Coverage instance

  // Constructor with virtual interface
  function new(virtual axi_if axi);
    this.axi = axi;

    // Instantiate mailboxes
    rbox  = new();
    rsbox = new();
    rcov  = new();  // new mailbox for read coverage
    wbox  = new();
    wsbox = new();
    wcov  = new();  // new mailbox for write coverage

    // Instantiate components
    wgen = new(wbox);
    rgen = new(rbox);
    wdrv = new(wbox, axi);
    rdrv = new(rbox, axi);
    wmon = new(wsbox, axi, wcov);  // pass wcov to write_monitor
    rmon = new(rsbox, axi, rcov);  // pass rcov to read_monitor
    sb   = new(wsbox, rsbox);
    cov  = new();  // instantiate coverage
  endfunction

  // Run task to start everything
  task run;
    fork
      wgen.run();
      rgen.run();
      wdrv.run();
      rdrv.run();
      wmon.run();
      rmon.run();
      sb.run();
      sample_write_cov();  // Coverage sampling forked
      sample_read_cov();   // Coverage sampling forked
    join_none
  endtask

  // Coverage sampling tasks
  task sample_read_cov();
    read_txn tx;
    forever begin
      rcov.get(tx);
      cov.sample_read(tx);
    end
  endtask

  task sample_write_cov();
    write_txn tx;
    forever begin
      wcov.get(tx);
      cov.sample_write(tx);
    end
  endtask
endclass
