class write_agent extends uvm_agent;

  write_driver     driver;
  write_monitor    monitor;
  write_sequencer  sequencer;

  `uvm_component_utils(write_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    monitor = write_monitor::type_id::create("monitor", this);

    if (is_active == UVM_ACTIVE) begin
      driver    = write_driver::type_id::create("driver", this);
      sequencer = write_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

