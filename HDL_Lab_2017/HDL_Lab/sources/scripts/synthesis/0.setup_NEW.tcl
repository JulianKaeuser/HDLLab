set DC_LIB_DIR		"/cad/synopsys/libs/TSMC_40nm/digital/Front_End/timing_power_noise/CCS"
set SYNOPSYS_HOME	"/cad/synopsys/tools/syn_vE-2010.12-SP1"
set DC_LIB_NAME		"TSMC 40nm LP"

#**************************************#
set PATH "/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab"
set PROJECT_NAME "instruction_decode"
set FILE_NAME "top20"
set MODULE_NAME "top20"
set PROJECT_PATH "${PATH}/sources/rtl/${PROJECT_NAME}/ohne_ALU"
set RTL_FOLDER ${PATH}/sources/rtl
set FILE_LIST {top20.v
		irdec.v
		irdefines.v
		f_flageval.v
		/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/rtl/regfile/register_file_v2.v
		/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/rtl/Instruction_Fetch/Instruction_Fetch_v2.v
		/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/rtl/memory_simple/memory_interface_simple.v
		/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/rtl/ALU_VARIABLE/ALU_VARIABLE.v}
# set your own values here
#**************************************#

set REP_PATH "${PATH}/reports/top"
file mkdir ${REP_PATH}
set TOP_LEVEL_MODULE "${MODULE_NAME}"

set search_path			[concat $search_path				\
								$DC_LIB_DIR					\
								$SYNOPSYS_HOME/libraries/syn		\
								${PROJECT_PATH}				\                        # Give path of RTL files here
						]

set target_library		[concat $DC_LIB_DIR/tcbn45gsbwp12t_200a/tcbn45gsbwp12ttc_ccs.db]

set symbol_library		""

set synthetic_library	[concat dw_foundation.sldb	\
								standard.sldb		\
						]

set link_library		[concat	*					\
								$target_library 	\
								$synthetic_library	\
								\
						]
					
						
set designer "The worlds greatest!"

set_host_options -max_cores 16

# Define aliases
alias h history
alias rc report_constraint -all_violators
