###################################################################

# Created by write_sdc on Fri Aug 11 13:24:22 2017

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clock]  -name CLOCK  -period 0.7  -waveform {0 0.35}
