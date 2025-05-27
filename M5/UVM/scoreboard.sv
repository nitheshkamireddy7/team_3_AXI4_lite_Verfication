class axi_scoreboard extends uvm_component;

  uvm_analysis_imp #(scoreboard_txn, axi_scoreboard) sb_imp;

  bit [31:0] memory_model [0:3];
  int check_count = 0;
  int total_checks = 200;

  `uvm_component_utils(axi_scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    sb_imp = new("sb_imp", this);
  endfunction

  // Analysis imp write method: gets called when monitor sends txn
  function void write(scoreboard_txn tx);
    if (tx.txn_type == WRITE_TXN) begin
      int waddr = tx.wtx.AWADDR >> 2;
      if (waddr < 4) begin
        bit [31:0] new_data = memory_model[waddr];

        if (tx.wtx.WSTRB[0]) new_data[7:0]   = tx.wtx.WDATA[7:0];
        if (tx.wtx.WSTRB[1]) new_data[15:8]  = tx.wtx.WDATA[15:8];
        if (tx.wtx.WSTRB[2]) new_data[23:16] = tx.wtx.WDATA[23:16];
        if (tx.wtx.WSTRB[3]) new_data[31:24] = tx.wtx.WDATA[31:24];

        memory_model[waddr] = new_data;
      end
    end
    else if (tx.txn_type == READ_TXN) begin
      int raddr = tx.rtx.ARADDR >> 2;
      bit [31:0] expected = memory_model[raddr];

      if (tx.rtx.RDATA !== expected)
        `uvm_error("SCOREBOARD",$sformatf("[FAIL] Addr=0x%0h | Expected=0x%08h | Actual=0x%08h",tx.rtx.ARADDR, expected, tx.rtx.RDATA))

      else
        `uvm_info(get_full_name(),$sformatf("[SCOREBOARD] PASS | Addr=0x%0h | Data=0x%08h", tx.rtx.ARADDR, tx.rtx.RDATA),UVM_LOW)



      check_count++;
      if (check_count >= total_checks) begin
        `uvm_info("SB", "Finished checking all transactions", UVM_NONE)
        $finish;
      end
    end
  endfunction

endclass
