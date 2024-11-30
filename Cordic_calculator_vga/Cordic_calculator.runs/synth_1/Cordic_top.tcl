# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param simulator.modelsimInstallPath D:/modeltech64_2020.4/win64
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/Vivado/Cordic_calculator/Cordic_calculator.cache/wt [current_project]
set_property parent.project_path E:/Vivado/Cordic_calculator/Cordic_calculator.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]
set_property ip_output_repo e:/Vivado/Cordic_calculator/Cordic_calculator.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/RAM_set.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/bcd2bin.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/bin2bcd_54bits.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/clk_div.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/cordic_sin_cos.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/display.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/int2float.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/key_scan.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/seg7.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/seg_select.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/switch2bcd.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/vga_640_480.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/vga_initials.v
  E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/sources_1/new/Cordic_top.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/constrs_1/new/Cordic_calculator.xdc
set_property used_in_implementation false [get_files E:/Vivado/Cordic_calculator/Cordic_calculator.srcs/constrs_1/new/Cordic_calculator.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top Cordic_top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Cordic_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Cordic_top_utilization_synth.rpt -pb Cordic_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
