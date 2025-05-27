#vlog -lint -cover bcef +define+AXI_BUG AXI_RTL.sv
vlog -lint -cover bcef AXI_RTL.sv
vlog test_top.sv
vsim -coverage work.test_top +voptargs="acc"
add wave -position insertpoint sim:/test_top/axi/*
run -all
