class read_monitor extends uvm_monitor;

  virtual axi_if axi;
  uvm_analysis_port #(scoreboard_txn) ap; 

  `uvm_component_utils(read_monitor)

  function new(string name = "read_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "axi", axi)) begin
      `uvm_fatal("READ_MON", "Virtual interface not set")
    end
  endfunction

  task run_phase(uvm_phase phase);
  read_txn rtx;
  scoreboard_txn sb_tx;
  bit [3:0] addr;

  forever begin
    wait (axi.ARVALID && axi.ARREADY);
    addr = axi.ARADDR;

    wait (axi.RVALID && axi.RREADY);
    rtx = read_txn::type_id::create("rtx");
    rtx.ARADDR = addr;
    rtx.RDATA  = axi.RDATA;

    sb_tx = scoreboard_txn::type_id::create("sb_tx");
    sb_tx.txn_type = READ_TXN;
    sb_tx.rtx = rtx;

    ap.write(sb_tx);

    @(posedge axi.ACLK);
    wait (!(axi.RVALID && axi.RREADY));
  end
endtask


endclass
