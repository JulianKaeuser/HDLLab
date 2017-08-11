

#Synthesis step
compile_ultra

# Before saving out the post-sysnthesis netlist, the instance names need to be converted to legal verilog
change_names -rules verilog -hierarchy

# create design folder
mkdir ${PROJECT_PATH}/designs

# writse mapped .ddc file:
write -hierarchy -format ddc -output ${PROJECT_PATH}/designs/${TOP_LEVEL_MODULE}.ddc

# export mapped design as verilog netlist file for gate-level simulation:
write -hierarchy -format verilog -output ${PROJECT_PATH}/designs/${TOP_LEVEL_MODULE}_gl.v

# export timing annotations:
write_sdf ${PROJECT_PATH}/designs/${TOP_LEVEL_MODULE}_timing.sdf
write_sdc ${PROJECT_PATH}/designs/${TOP_LEVEL_MODULE}_timing.sdc
