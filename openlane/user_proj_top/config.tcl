set script_dir [file dirname [file normalize [info script]]]

# User config
set ::env(ROUTING_CORES) 					8

set ::env(DESIGN_NAME) 						user_proj_top

set ::env(DESIGN_IS_CORE) 					0

# Change if needed
set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/multifsm.v
	$script_dir/../../verilog/rtl/spm.v
	$script_dir/../../verilog/rtl/shift_right.v
    $script_dir/../../verilog/rtl/spm_top.v
    $script_dir/../../verilog/rtl/user_proj_top.v"
	
# Fill this
set ::env(CLOCK_PERIOD) 					"8"
set ::env(CLOCK_PORT) 						"clk"
set ::env(RESET_PORT)                       "rst"

set ::env(FP_PIN_ORDER_CFG) 				$::env(DESIGN_DIR)/pin_order.cfg

set ::env(FP_SIZING) 						absolute
set ::env(DIE_AREA) 						"0 0 400 450"
set ::env(PL_TARGET_DENSITY) 				0.82

set ::env(GLB_RT_OBS) 						"met5 $::env(DIE_AREA)"
set ::env(GLB_RT_MAXLAYER) 					5

set ::env(CELL_PAD) 						0
set ::env(DIODE_INSERTION_STRATEGY) 		4