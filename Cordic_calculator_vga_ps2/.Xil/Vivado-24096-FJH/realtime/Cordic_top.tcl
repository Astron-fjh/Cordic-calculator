# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_resetSystemStats
    rt::HARTNDb_startSystemStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "E:/Vivado/Cordic_calculator_vga_ps2/.Xil/Vivado-24096-FJH/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7a35tcpg236-1
     file delete -force synth_hints.os

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog {
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/RAM_set.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/bcd2bin.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/bin2bcd_54bits.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/clk_div.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/cordic_sin_cos.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/display.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/int2float.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/keyBoard.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/keyBoard_state.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/seg7.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/seg_select.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/vga_640_480.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/vga_initials.v
      E:/Vivado/Cordic_calculator_vga_ps2/Cordic_calculator.srcs/sources_1/new/Cordic_top.v
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top Cordic_top
    rt::set_parameter enableIncremental true
    set rt::reportTiming false
    rt::set_parameter elaborateOnly true
    rt::set_parameter elaborateRtl true
    rt::set_parameter eliminateRedundantBitOperator false
    rt::set_parameter elaborateRtlOnlyFlow true
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter merge_flipflops true
    rt::set_parameter srlDepthThreshold 3
    rt::set_parameter rstSrlDepthThreshold 4
# MODE: 
    rt::set_parameter webTalkPath {}
    rt::set_parameter enableSplitFlowPath "E:/Vivado/Cordic_calculator_vga_ps2/.Xil/Vivado-24096-FJH/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_rtlelab -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
