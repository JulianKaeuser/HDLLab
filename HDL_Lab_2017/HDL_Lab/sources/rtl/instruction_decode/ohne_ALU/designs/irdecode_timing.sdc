###################################################################

# Created by write_sdc on Wed Aug  9 13:58:23 2017

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clock]  -name CLOCK  -period 1  -waveform {0 0.5}
