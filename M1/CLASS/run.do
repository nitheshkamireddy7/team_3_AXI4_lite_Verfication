# Create and map work library
vlib work
vmap work work

# Compile design and testbench files
vlog AXI_slave.sv
vlog AXI_master_tb.sv

# Launch simulation with GUI and full signal visibility
vsim -gui -voptargs=+acc work.tb_axi_lite_slave

# Add DUT signals to the wave window
add wave -position insertpoint sim:/tb_axi_lite_slave/dut/*

# Run the testbench
run -all

# Optionally open the waveform viewer
view wave

