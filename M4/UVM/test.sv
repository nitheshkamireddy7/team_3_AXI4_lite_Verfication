class axi_test extends uvm_test;

  `uvm_component_utils(axi_test)

  axi_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), "Printing UVM Component Hierarchy:", UVM_NONE)
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    write_seq wseq;
    read_seq  rseq;

    phase.raise_objection(this);

    `uvm_info("AXI_TEST", "Starting write and read sequences", UVM_MEDIUM)

    wseq = write_seq::type_id::create("wseq");
    rseq = read_seq::type_id::create("rseq");

    fork
      wseq.start(env.wagent.sequencer);
      rseq.start(env.ragent.sequencer);
    join

    phase.drop_objection(this);
  endtask

endclass
