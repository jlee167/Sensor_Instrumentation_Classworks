# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a75tfgg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.cache/wt [current_project]
set_property parent.project_path C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okBTPipeOut.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okCoreHarness.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okLibrary.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okPipeIn.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okPipeOut.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okWireIn.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/lab4_framework.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okTriggerIn.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okWireOut.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okBTPipeIn.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okRegisterBridge.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/okTriggerOut.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/SPI.v
  C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/capacitor.v
}
read_ip -quiet C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/ila/ila.xci
set_property used_in_implementation false [get_files -all c:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/ila/ila_v6_2/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/ila/ila_ooc.xdc]
set_property is_locked true [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/ila/ila.xci]

read_ip -quiet C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xci
set_property used_in_implementation false [get_files -all c:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_ooc.xdc]
set_property is_locked true [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xci]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/i2c_core/new/i2c_core_ooc.xdc
set_property used_in_implementation false [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/i2c_core/new/i2c_core_ooc.xdc]

read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/i2c_driver/new/i2c_driver_ooc.xdc
set_property used_in_implementation false [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/i2c_driver/new/i2c_driver_ooc.xdc]

read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/clkDivCustom24bit/new/clkDivCustom24bit_ooc.xdc
set_property used_in_implementation false [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/clkDivCustom24bit/new/clkDivCustom24bit_ooc.xdc]

read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/concat_1to4_withAddr/new/concat_1to4_withAddr_ooc.xdc
set_property used_in_implementation false [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/concat_1to4_withAddr/new/concat_1to4_withAddr_ooc.xdc]

read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/mux4to1_withAddr/new/mux4to1_withAddr_ooc.xdc
set_property used_in_implementation false [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/mux4to1_withAddr/new/mux4to1_withAddr_ooc.xdc]

read_xdc C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/xem7310.xdc
set_property used_in_implementation false [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/xem7310.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top pipeIn_PipeOut_framework -part xc7a75tfgg484-1


write_checkpoint -force -noxdef pipeIn_PipeOut_framework.dcp

catch { report_utilization -file pipeIn_PipeOut_framework_utilization_synth.rpt -pb pipeIn_PipeOut_framework_utilization_synth.pb }
