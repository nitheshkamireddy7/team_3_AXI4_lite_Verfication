class read_agent extends uvm_agent;

  read_driver     driver;
  read_monitor    monitor;
  read_sequencer  sequencer;

  `uvm_component_utils(read_agent)

  function new(string name = "read_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    monitor = read_monitor::type_id::create("monitor", this);

    if (is_active == UVM_ACTIVE) begin
      driver    = read_driver::type_id::create("driver", this);
      sequencer = read_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

