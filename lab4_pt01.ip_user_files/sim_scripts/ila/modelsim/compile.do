vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../../lab4_pt01.srcs/sources_1/ip/ila/hdl/verilog" "+incdir+../../../../lab4_pt01.srcs/sources_1/ip/ila/hdl/verilog" \
"C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../lab4_pt01.srcs/sources_1/ip/ila/hdl/verilog" "+incdir+../../../../lab4_pt01.srcs/sources_1/ip/ila/hdl/verilog" \
"../../../../lab4_pt01.srcs/sources_1/ip/ila/sim/ila.v" \

vlog -work xil_defaultlib \
"glbl.v"

