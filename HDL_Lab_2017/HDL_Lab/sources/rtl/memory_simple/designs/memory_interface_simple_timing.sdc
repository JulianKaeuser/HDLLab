###################################################################

# Created by write_sdc on Fri Aug 11 09:11:30 2017

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clock]  -name CLOCK  -period 0.5  -waveform {0 0.25}
