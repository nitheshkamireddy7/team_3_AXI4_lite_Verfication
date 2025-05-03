class read_generator;
  mailbox #(read_txn) rbox;
  read_txn rtx;

  function new(mailbox #(read_txn) rbox);
    this.rbox = rbox;
  endfunction

  task run;
    repeat(20) begin
      rtx = new();
      if(rtx.randomize()) begin
        rbox.put(rtx);
      end
      $display("read_transaction : Addr = %h", rtx.ARADDR);

    end
  endtask
endclass
