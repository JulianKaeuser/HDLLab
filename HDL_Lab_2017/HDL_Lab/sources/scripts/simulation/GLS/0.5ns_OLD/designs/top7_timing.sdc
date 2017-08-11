###################################################################

# Created by write_sdc on Thu Aug 10 18:24:07 2017

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clk]  -name CLOCK  -period 0.5  -waveform {0 0.25}
