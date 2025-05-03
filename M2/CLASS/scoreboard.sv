class scoreboard;
  mailbox #(write_txn) wsbox;
  mailbox #(read_txn)  rsbox;

  bit [31:0] memory_model [0:3];  // 4 memory locations
  int total_checks = 20;          
  int check_count  = 0;

  // Constructor
  function new(mailbox #(write_txn) wsbox, mailbox #(read_txn) rsbox);
    this.wsbox = wsbox;
    this.rsbox = rsbox;
  endfunction

  // Run task
  task run;
    write_txn wtx;
    read_txn  rtx;
    bit [31:0] old_data;
    bit [31:0] new_data;
    bit [31:0] expected;
    int waddr_idx, raddr_idx;

    fork
      // WRITE TRANSACTION THREAD
      forever begin
        wsbox.get(wtx);
        waddr_idx = wtx.AWADDR >> 2;

        if (waddr_idx >= 0 && waddr_idx < 4) begin
          old_data = memory_model[waddr_idx];
          new_data = old_data;

          if (wtx.WSTRB[0]) new_data[7:0]   = wtx.WDATA[7:0];
          if (wtx.WSTRB[1]) new_data[15:8]  = wtx.WDATA[15:8];
          if (wtx.WSTRB[2]) new_data[23:16] = wtx.WDATA[23:16];
          if (wtx.WSTRB[3]) new_data[31:24] = wtx.WDATA[31:24];

          memory_model[waddr_idx] = new_data;

          //$display("SCOREBOARD WRITE: Addr=0x%0h (Idx=%0d) | WSTRB=%b | Old=0x%08h | New=0x%08h",
                  // wtx.AWADDR, waddr_idx, wtx.WSTRB, old_data, new_data);
        end else begin
          $display("SCOREBOARD ERROR: Invalid write address 0x%0h (Idx=%0d)", 
                   wtx.AWADDR, waddr_idx);
        end
      end

      // READ TRANSACTION THREAD
      forever begin
        rsbox.get(rtx);
        raddr_idx = rtx.ARADDR >> 2;

        if (raddr_idx >= 0 && raddr_idx < 4) begin
          expected = memory_model[raddr_idx];

          if (rtx.RDATA !== expected) begin
            $display("SCOREBOARD MISMATCH: Addr=0x%0h (Idx=%0d) | Expected=0x%08h | Got=0x%08h",
                     rtx.ARADDR, raddr_idx, expected, rtx.RDATA);
          end else begin
           $display("Scoreboard PASS: Addr=0x%0h | Data=0x%08h | Expected from reference model=0x%08h",
         rtx.ARADDR, rtx.RDATA, expected);

          end
        end else begin
          $display("SCOREBOARD ERROR: Invalid read address 0x%0h (Idx=%0d)",
                   rtx.ARADDR, raddr_idx);
        end

        check_count++;
        if (check_count >= total_checks) begin
          $display("SCOREBOARD: Completed %0d checks. Simulation done!", check_count);
          $finish;
        end
      end
    join_none
  endtask
endclass
