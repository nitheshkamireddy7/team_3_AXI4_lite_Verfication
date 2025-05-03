class write_generator;
  mailbox #(write_txn) wbox;
  write_txn wtx;
  function new(mailbox #(write_txn) wbox);
    this.wbox = wbox;
  endfunction
  task run;
    
    repeat(20) begin
    wtx = new();
    
    if(wtx.randomize()) begin 
      wbox.put(wtx);
    end
      $display("write_transcation : Addr - %h , strobe - %h , data - %h",wtx.AWADDR,wtx.WSTRB,wtx.WDATA);
    end
  endtask
endclass
