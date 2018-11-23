# DVE Simulation Rebuild/Restart Options
# Saved on Fri Nov 23 13:45:39 2018
set SIMSETUP::REBUILDOPTION 1
set SIMSETUP::REBUILDCMD {vcs -f filelist +define+S50 +define+VERBOSE +define+SDR_16BIT +incdir+./rtl +incdir+./rtl/model +incdir+./test_environment2 -sverilog -full64 -debug_access+all -timescale=1ns/10ps -PP -assert}
set SIMSETUP::REBUILDDIR {}
set SIMSETUP::RESTOREBP 1
set SIMSETUP::RESTOREDUMP 1
set SIMSETUP::RESTOREFORCE 1
set SIMSETUP::RESTORESPECMAN 0
