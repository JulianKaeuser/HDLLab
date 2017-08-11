#########################################################################
#################      Gate Level Simulation Script         #############
#########################################################################
##### Integrated Electronic Systems Lab                    ##############
##### TU Darmstadt                                         ##############
#########################################################################


# Create a library for standard cells and fill it(only needed once)
# vlib tsmc40
# vlib work
# vlog -work tsmc40 /cad/synopsys/libs/TSMC_40nm/digital/Front_End/verilog/tcbn45gsbwp12t_200a/tcbn45gsbwp12t.v

# Compile the gate level netlist, memory compiler and testbench into the library work
vlog -work work /home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/scripts/simulation/GLS/0.70ns_FINAL/designs/top20_gl.v /home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/testbench/memory.sv /home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/rtl/instruction_decode/ohne_ALU/testbench21.sv

# Perform the simulation with timing information annotated from the sdf file
vsim -L tsmc40 -sdftyp /UUT=/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/scripts/simulation/GLS/0.70ns_FINAL/designs/top20_timing.sdf -novopt work.testbench21
do wave21.do
run 20us
