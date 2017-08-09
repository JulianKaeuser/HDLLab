set DC_LIB_DIR		"/cad/synopsys/libs/TSMC_40nm/digital/Front_End/timing_power_noise/CCS"
set SYNOPSYS_HOME	"/cad/synopsys/tools/syn_vE-2010.12-SP1"
set DC_LIB_NAME		"TSMC 40nm LP"

#**************************************#
set PATH "/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab"
set PROJECT_NAME "decoder"
set FILE_NAME "irdec"
set MODULE_NAME "irdecode"
set FILE_LIST {irdec.v irdefines.v f_flageval.v}
set PROJECT_PATH "${PATH}/sources/rtl/${PROJECT_NAME}/testbench"
# set your own values here
#**************************************#

set REP_PATH "${PATH}/reports/${PROJECT_NAME}"
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
