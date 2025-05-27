class read_driver extends uvm_driver #(read_txn);

  virtual axi_if axi;

  `uvm_component_utils(read_driver)

  function new(string name = "read_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "axi", axi)) begin
      `uvm_fatal("READ_DRV", "Virtual interface not set")
    end
  endfunction

  task run_phase(uvm_phase phase);
    read_txn rtx;

    forever begin
      seq_item_port.get_next_item(rtx);

      @(posedge axi.ACLK);
      axi.ARADDR  <= rtx.ARADDR;
      axi.ARVALID <= 1;
      axi.RREADY  <= 0;

      //`uvm_info(get_full_name(), $sformatf("ARADDR = %0d", rtx.ARADDR), UVM_LOW)


      wait (axi.ARREADY);

      @(posedge axi.ACLK);
      axi.ARVALID <= 0;

      wait (axi.RVALID);
      rtx.RDATA = axi.RDATA;

      //@(posedge axi.ACLK);
      axi.RREADY <= 1;

      @(posedge axi.ACLK);
      axi.RREADY <= 0;

      seq_item_port.item_done();
    end
  endtask

endclass

