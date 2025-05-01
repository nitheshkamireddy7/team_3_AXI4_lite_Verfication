class scoreboard;
  mailbox #(write_txn) wsbox;
  mailbox #(read_txn)  rsbox;

  
  bit [31:0] memory_model [0:3];

  function new(mailbox #(write_txn) wsbox, mailbox #(read_txn) rsbox);
    this.wsbox = wsbox;
    this.rsbox = rsbox;
  endfunction

  task run;
    fork
      
      forever begin
        write_txn wtx;
        wsbox.get(wtx);

        bit [31:0] old_data = memory_model[wtx.AWADDR];
        bit [31:0] new_data = old_data;

        
        if (wtx.WSTRB[0]) new_data[7:0]   = wtx.WDATA[7:0];
        if (wtx.WSTRB[1]) new_data[15:8]  = wtx.WDATA[15:8];
        if (wtx.WSTRB[2]) new_data[23:16] = wtx.WDATA[23:16];
        if (wtx.WSTRB[3]) new_data[31:24] = wtx.WDATA[31:24];

        memory_model[wtx.AWADDR] = new_data;

        $display("SCOREBOARD WRITE: Addr = %0h | WSTRB = %b | Old = %h | New = %h",
                  wtx.AWADDR, wtx.WSTRB, old_data, new_data);
      end

      // -------- READ TRANSACTION CHECKING --------
      forever begin
        read_txn rtx;
        rsbox.get(rtx);

        bit [31:0] expected = memory_model[rtx.ARADDR];

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
