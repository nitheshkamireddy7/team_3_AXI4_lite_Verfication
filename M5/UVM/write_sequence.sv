class write_seq extends uvm_sequence #(write_txn);
   
  `uvm_object_utils(write_seq)

  write_txn wtx;

  function new(string name = "write_seq");
    super.new(name);
  endfunction

  task body();
    repeat (200) begin
      wtx = write_txn::type_id::create("wtx");
      start_item(wtx);
      assert(wtx.randomize());
      
 //   `uvm_info(get_full_name(), $sformatf("Driving TXN: addr=%0h, strb=%b, data=%h",
   //                                  wtx.AWADDR, wtx.WSTRB, wtx.WDATA), UVM_LOW)


      finish_item(wtx);
    end
  endtask

endclass
