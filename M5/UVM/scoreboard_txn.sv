typedef enum { READ_TXN, WRITE_TXN } txn_type_e;

class scoreboard_txn extends uvm_object;
  txn_type_e txn_type;
  write_txn wtx;
  read_txn  rtx;

  `uvm_object_utils(scoreboard_txn)

  function new(string name = "scoreboard_txn");
    super.new(name);
  endfunction
endclass

