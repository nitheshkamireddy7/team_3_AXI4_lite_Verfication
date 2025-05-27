class write_sequencer extends uvm_sequencer #(write_txn);

`uvm_component_utils(write_sequencer)

function new(string name = "write_sequencer",uvm_component parent);
super.new(name,parent);
endfunction
endclass
