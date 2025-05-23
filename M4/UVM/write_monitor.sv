
class write_monitor extends uvm_monitor;

  virtual axi_if axi;
  uvm_analysis_port #(scoreboard_txn) ap;

  `uvm_component_utils(write_monitor)

  function new(string name = "write_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "axi", axi)) begin
      `uvm_fatal("MON", "Virtual interface not set via config DB")
    end
  endfunction

  task run_phase(uvm_phase phase);
    write_txn wtx;
    scoreboard_txn sb_tx;
    bit [31:0] addr, data;
    bit [3:0] strb;

    forever begin
      wait (axi.AWVALID && axi.AWREADY);
      addr = axi.AWADDR;

      wait (axi.WVALID && axi.WREADY);
      strb = axi.WSTRB;
      data = axi.WDATA;

      @(posedge axi.ACLK);

      wtx = write_txn::type_id::create("wtx");
      wtx.AWADDR = addr;
      wtx.WSTRB  = strb;
      wtx.WDATA  = data;

      sb_tx = scoreboard_txn::type_id::create("sb_tx");
      sb_tx.txn_type = WRITE_TXN;
      sb_tx.wtx = wtx;

      ap.write(sb_tx);
    end
  endtask

endclass
