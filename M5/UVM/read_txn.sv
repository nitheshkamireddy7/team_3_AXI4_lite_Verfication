class read_txn extends uvm_sequence_item;
  rand bit [3:0] ARADDR;
  logic [31:0] RDATA;

  constraint ARADDR_range { ARADDR inside {0, 4, 8, 12}; }

  `uvm_object_utils(read_txn)

  function new(string name = "read_txn");
    super.new(name);
  endfunction
endclass

