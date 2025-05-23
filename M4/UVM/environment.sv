class axi_env extends uvm_env;

  write_agent wagent;
  read_agent  ragent;
  axi_scoreboard scoreboard;
  axi_coverage coverage;

  `uvm_component_utils(axi_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wagent     = write_agent::type_id::create("wagent", this);
    ragent     = read_agent::type_id::create("ragent", this);
    scoreboard = axi_scoreboard::type_id::create("scoreboard", this);
    coverage   = axi_coverage::type_id::create("coverage", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wagent.monitor.ap.connect(scoreboard.sb_imp);
    ragent.monitor.ap.connect(scoreboard.sb_imp);

    wagent.monitor.ap.connect(coverage.analysis_export);
    ragent.monitor.ap.connect(coverage.analysis_export);
  endfunction

endclass
