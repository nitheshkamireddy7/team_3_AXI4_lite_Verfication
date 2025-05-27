class write_driver extends uvm_driver #(write_txn);

virtual axi_if axi;

`uvm_component_utils(write_driver)

function new(string name = "write_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
  uvm_config_db#(virtual axi_if)::get(this,"","axi",axi);
endfunction

task run_phase(uvm_phase phase);
    write_txn wtx;
    seq_item_port.get_next_item(wtx);

      // Drive address and data
      @(posedge axi.ACLK);
      @(posedge axi.ACLK);

      axi.AWADDR  <= 12;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= 4'b0001;
      axi.AWVALID <= 0;
      axi.WVALID  <= 1;
      axi.BREADY  <= 0;
       @(posedge axi.ACLK);
      axi.AWADDR  <= 12;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= 4'b0001;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;
      axi.BREADY  <= 1;
      

     

      // Wait for both AWREADY and WREADY handshake
      wait (axi.AWREADY && axi.WREADY);

      
      

      // Wait for BVALID and assert BREADY
      wait (axi.BVALID);
      @(posedge axi.ACLK);
      axi.BREADY <= 0;
       @(posedge axi.ACLK);
      axi.BREADY <= 1;

      
     seq_item_port.item_done();
      // Drive address and data
      @(posedge axi.ACLK);
    seq_item_port.get_next_item(wtx);
      @(posedge axi.ACLK);

      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 0;
      axi.BREADY  <= 0;
       @(posedge axi.ACLK);
      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;
      axi.BREADY  <= 1;
      

     

      // Wait for both AWREADY and WREADY handshake
      wait (axi.AWREADY && axi.WREADY);

      
      

      // Wait for BVALID and assert BREADY
      wait (axi.BVALID);
      @(posedge axi.ACLK);
      axi.BREADY <= 1;
      seq_item_port.item_done();
      


      


    forever begin
  
 seq_item_port.get_next_item(wtx);
 `uvm_info(get_full_name(),
  $sformatf("[WRITE_TXN] Addr=0x%0h | STRB=0b%04b | Data=0x%08h",
    wtx.AWADDR, wtx.WSTRB, wtx.WDATA),
  UVM_LOW)

      // Drive address and data
      @(posedge axi.ACLK);
      axi.AWADDR  <= wtx.AWADDR;
      axi.WDATA   <= wtx.WDATA;
      axi.WSTRB   <= wtx.WSTRB;
      axi.AWVALID <= 1;
      axi.WVALID  <= 1;
      axi.BREADY  <= 0;

     

      // Wait for both AWREADY and WREADY handshake
      wait (axi.AWREADY && axi.WREADY);

      
      

      // Wait for BVALID and assert BREADY
      wait (axi.BVALID);
      @(posedge axi.ACLK);
      axi.BREADY <= 1;

       seq_item_port.item_done();
    end
  endtask
endclass
