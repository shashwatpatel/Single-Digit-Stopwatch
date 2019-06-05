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

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7a100tcsg324-1
  set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir {C:/Users/ee-student/Downloads/Lab 5-20190502T185932Z-001/Lab 5/Lab 5.cache/wt} [current_project]
  set_property parent.project_path {C:/Users/ee-student/Downloads/Lab 5-20190502T185932Z-001/Lab 5/Lab 5.xpr} [current_project]
  set_property ip_cache_permissions disable [current_project]
  add_files -quiet {{C:/Users/ee-student/Downloads/Lab 5-20190502T185932Z-001/Lab 5/Lab 5.runs/synth_1/stopwatch.dcp}}
  read_xdc C:/Users/ee-student/Downloads/Nexys4DDR_Master.xdc
  link_design -top stopwatch -part xc7a100tcsg324-1
  write_hwdef -file stopwatch.hwdef
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
  write_checkpoint -force stopwatch_opt.dcp
  report_drc -file stopwatch_drc_opted.rpt
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
  write_checkpoint -force stopwatch_placed.dcp
  report_io -file stopwatch_io_placed.rpt
  report_utilization -file stopwatch_utilization_placed.rpt -pb stopwatch_utilization_placed.pb
  report_control_sets -verbose -file stopwatch_control_sets_placed.rpt
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
  write_checkpoint -force stopwatch_routed.dcp
  report_drc -file stopwatch_drc_routed.rpt -pb stopwatch_drc_routed.pb -rpx stopwatch_drc_routed.rpx
  report_methodology -file stopwatch_methodology_drc_routed.rpt -rpx stopwatch_methodology_drc_routed.rpx
  report_timing_summary -warn_on_violation -max_paths 10 -file stopwatch_timing_summary_routed.rpt -rpx stopwatch_timing_summary_routed.rpx
  report_power -file stopwatch_power_routed.rpt -pb stopwatch_power_summary_routed.pb -rpx stopwatch_power_routed.rpx
  report_route_status -file stopwatch_route_status.rpt -pb stopwatch_route_status.pb
  report_clock_utilization -file stopwatch_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force stopwatch_routed_error.dcp
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
  catch { write_mem_info -force stopwatch.mmi }
  write_bitstream -force -no_partial_bitfile stopwatch.bit 
  catch { write_sysdef -hwdef stopwatch.hwdef -bitfile stopwatch.bit -meminfo stopwatch.mmi -file stopwatch.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

