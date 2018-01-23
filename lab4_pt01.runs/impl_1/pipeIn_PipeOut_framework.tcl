proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7a75tfgg484-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.cache/wt [current_project]
  set_property parent.project_path C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.xpr [current_project]
  set_property ip_output_repo C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.runs/synth_1/pipeIn_PipeOut_framework.dcp
  read_ip -quiet C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/ila/ila.xci
  set_property is_locked true [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/ila/ila.xci]
  read_ip -quiet C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xci
  set_property is_locked true [get_files C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xci]
  read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/i2c_core/new/i2c_core_ooc.xdc
  read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/i2c_driver/new/i2c_driver_ooc.xdc
  read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/clkDivCustom24bit/new/clkDivCustom24bit_ooc.xdc
  read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/concat_1to4_withAddr/new/concat_1to4_withAddr_ooc.xdc
  read_xdc -mode out_of_context C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/mux4to1_withAddr/new/mux4to1_withAddr_ooc.xdc
  read_xdc C:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/new/xem7310.xdc
  link_design -top pipeIn_PipeOut_framework -part xc7a75tfgg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force pipeIn_PipeOut_framework_opt.dcp
  catch { report_drc -file pipeIn_PipeOut_framework_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force pipeIn_PipeOut_framework_placed.dcp
  catch { report_io -file pipeIn_PipeOut_framework_io_placed.rpt }
  catch { report_utilization -file pipeIn_PipeOut_framework_utilization_placed.rpt -pb pipeIn_PipeOut_framework_utilization_placed.pb }
  catch { report_control_sets -verbose -file pipeIn_PipeOut_framework_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force pipeIn_PipeOut_framework_routed.dcp
  catch { report_drc -file pipeIn_PipeOut_framework_drc_routed.rpt -pb pipeIn_PipeOut_framework_drc_routed.pb -rpx pipeIn_PipeOut_framework_drc_routed.rpx }
  catch { report_methodology -file pipeIn_PipeOut_framework_methodology_drc_routed.rpt -rpx pipeIn_PipeOut_framework_methodology_drc_routed.rpx }
  catch { report_power -file pipeIn_PipeOut_framework_power_routed.rpt -pb pipeIn_PipeOut_framework_power_summary_routed.pb -rpx pipeIn_PipeOut_framework_power_routed.rpx }
  catch { report_route_status -file pipeIn_PipeOut_framework_route_status.rpt -pb pipeIn_PipeOut_framework_route_status.pb }
  catch { report_clock_utilization -file pipeIn_PipeOut_framework_clock_utilization_routed.rpt }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file pipeIn_PipeOut_framework_timing_summary_routed.rpt -rpx pipeIn_PipeOut_framework_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force pipeIn_PipeOut_framework_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  catch { write_mem_info -force pipeIn_PipeOut_framework.mmi }
  write_bitstream -force pipeIn_PipeOut_framework.bit 
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx pipeIn_PipeOut_framework.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

