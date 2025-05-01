class scoreboard;
  mailbox #(write_txn) wsbox;
  mailbox #(read_txn)  rsbox;

  bit [31:0] memory_model [0:3];  // 4 memory locations

  // Constructor
  function new(mailbox #(write_txn) wsbox, mailbox #(read_txn) rsbox);
    this.wsbox = wsbox;
    this.rsbox = rsbox;
  endfunction

  // Run task
  task run;
    write_txn wtx;
    read_txn rtx;
    bit [31:0] old_data;
    bit [31:0] new_data;
    bit [31:0] expected;

    fork
      // WRITE TRANSACTION
      forever begin
      $display("SCOREBOARD: waiting for write txn...");
      wsbox.get(wtx);
      $display("SCOREBOARD: got write txn Addr=%0d", wtx.AWADDR);

        
        old_data = memory_model[wtx.AWADDR];
        new_data = old_data;

        // Apply byte-enable strobe
        if (wtx.WSTRB[0]) new_data[7:0]   = wtx.WDATA[7:0];
        if (wtx.WSTRB[1]) new_data[15:8]  = wtx.WDATA[15:8];
        if (wtx.WSTRB[2]) new_data[23:16] = wtx.WDATA[23:16];
        if (wtx.WSTRB[3]) new_data[31:24] = wtx.WDATA[31:24];

        memory_model[wtx.AWADDR] = new_data;

        $display("SCOREBOARD WRITE: Addr = %0h | WSTRB = %b | Old = %h | New = %h",
                  wtx.AWADDR, wtx.WSTRB, old_data, new_data);
      end

      // READ TRANSACTION
      forever begin
        rsbox.get(rtx);
        expected = memory_model[rtx.ARADDR];

        if (rtx.RDATA !== expected) begin
          $display("SCOREBOARD MISMATCH: Addr = %0h | Expected = %h | Got = %h",
                    rtx.ARADDR, expected, rtx.RDATA);
        end else begin
          $display("SCOREBOARD PASS: Addr = %0h | Data = %h", rtx.ARADDR, rtx.RDATA);
        end
      end
    join_none
  endtask
endclass
