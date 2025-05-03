vlog tb_top.sv
vsim -gui work.tb_top -voptargs=+acc
add wave -position insertpoint sim:/tb_top/dut/*
run -all
