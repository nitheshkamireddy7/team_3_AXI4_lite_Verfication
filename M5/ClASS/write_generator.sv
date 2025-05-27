class write_generator;
  mailbox #(write_txn) wbox;
  write_txn wtx;

  function new(mailbox #(write_txn) wbox);
    this.wbox = wbox;
  endfunction

  task run;
    // === Directed Stimulus ===
    bit [3:0] addrs[] = {0, 4, 8}; // Sample valid aligned addresses

    // Low-range (0–15)
    wtx = new();
    wtx.AWADDR = addrs[$urandom_range(0, 2)];
    wtx.WSTRB  = 4'b1111;
    wtx.WDATA  = 10;  // LOW bin
    wbox.put(wtx);
    $display("[DIRECTED] write_txn: Addr=%h Strobe=%h Data=%h", wtx.AWADDR, wtx.WSTRB, wtx.WDATA);

    // Mid-range (16–255)
    wtx = new();
    wtx.AWADDR = addrs[$urandom_range(0, 2)];
    wtx.WSTRB  = 4'b1111;
    wtx.WDATA  = 128; // MID bin
    wbox.put(wtx);
    $display("[DIRECTED] write_txn: Addr=%h Strobe=%h Data=%h", wtx.AWADDR, wtx.WSTRB, wtx.WDATA);

    // High-range (256–65535)
    wtx = new();
    wtx.AWADDR = addrs[$urandom_range(0, 2)];
    wtx.WSTRB  = 4'b1111;
    wtx.WDATA  = 4096; // HIGH bin
    wbox.put(wtx);
    $display("[DIRECTED] write_txn: Addr=%h Strobe=%h Data=%h", wtx.AWADDR, wtx.WSTRB, wtx.WDATA);

    // === Random Stimulus ===
    repeat (197) begin
      wtx = new();
      if (wtx.randomize()) begin
        wbox.put(wtx);
        $display("[RANDOM] write_txn: Addr=%h Strobe=%h Data=%h", wtx.AWADDR, wtx.WSTRB, wtx.WDATA);
      end
    end
  endtask
endclass
