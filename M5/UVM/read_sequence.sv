class read_seq extends uvm_sequence #(read_txn);

  `uvm_object_utils(read_seq)

  function new(string name = "read_seq");
    super.new(name);
  endfunction

  task body();
    read_txn rtx;

    repeat (200) begin
      rtx = read_txn::type_id::create("rtx");
      start_item(rtx);
      assert(rtx.randomize());
      finish_item(rtx);

    //  `uvm_info(get_full_name(), $sformatf("read_transaction : Addr = %h", rtx.ARADDR), UVM_LOW)

    end
  endtask

endclass

