#########################################################################
#################      Gate Level Simulation Script         #############
#########################################################################
##### Integrated Electronic Systems Lab                    ##############
##### TU Darmstadt                                         ##############
#########################################################################


# Create a library for standard cells and fill it(only needed once)
vlib tsmc40
vlib work
vlog -work tsmc40 /cad/synopsys/libs/TSMC_40nm/digital/Front_End/verilog/tcbn45gsbwp12t_200a/tcbn45gsbwp12t.v

# Compile the gate level netlist, memory compiler and testbench into the library work
vlog -work work /home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/rtl/instruction_decode/ohne_ALU/designs/top7_gl.v /home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/testbench/memory.sv /home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/testbench/testbench.sv

# Perform the simulation with timing information annotated from the sdf file
vsim -L tsmc40 -sdftyp /top7_i=/home/vhdlp9/HDLLab/HDL_Lab_2017/HDL_Lab/sources/designs/mapped/cpu_timing.sdf -novopt work.testbench
