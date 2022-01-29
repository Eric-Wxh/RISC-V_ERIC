debImport "-f" "filelist.f"
debLoadSimResult \
           /home/eric/Desktop/ic_pro/riscv/riscv_DDCA/riscv_single/sim/tb_rvsingle.fsdb
wvCreateWindow
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {10 13 1 17 1 1} -backward
wvAddSignal -win $_nWave2 "/tb_rvsingle/clk" "/tb_rvsingle/reset" \
           "/tb_rvsingle/pc\[31:0\]" "/tb_rvsingle/ALU_Result\[31:0\]"
wvSetPosition -win $_nWave2 {("G1" 0)}
wvSetPosition -win $_nWave2 {("G1" 4)}
wvSetPosition -win $_nWave2 {("G1" 4)}
wvSetCursor -win $_nWave2 51099.948298 -snap {("G2" 0)}
wvSelectGroup -win $_nWave2 {G2}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_rvsingle.dut" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_rvsingle.dut" -delim "."
srcHBSelect "tb_rvsingle.dut" -win $_nTrace1
srcHBSelect "tb_rvsingle.dut.rvsingle" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_rvsingle.dut.rvsingle" -delim "."
srcHBSelect "tb_rvsingle.dut.rvsingle" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {15 22 1 1 1 1} -backward
wvSetPosition -win $_nWave2 {("G1" 0)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 "tb_rvsingle/dut/rvsingle/Width"
wvAddSignal -win $_nWave2 "/tb_rvsingle/dut/rvsingle/Instr\[31:0\]" \
           "/tb_rvsingle/dut/rvsingle/pc\[31:0\]" \
           "/tb_rvsingle/dut/rvsingle/rd_data\[31:0\]" \
           "/tb_rvsingle/dut/rvsingle/ALU_Result\[31:0\]" \
           "/tb_rvsingle/dut/rvsingle/Mem_Write" \
           "/tb_rvsingle/dut/rvsingle/Write_Data\[31:0\]"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 6)}
wvSetPosition -win $_nWave2 {("G2" 6)}
wvUnknownSaveResult -win $_nWave2 -clear
wvSetCursor -win $_nWave2 48711.534296 -snap {("G3" 0)}
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 4 5 6 )} 
wvSelectGroup -win $_nWave2 {G3}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcHBSelect "tb_rvsingle.dut" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_rvsingle.dut" -delim "."
srcHBSelect "tb_rvsingle.dut" -win $_nTrace1
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_rvsingle.dut"
schSelect -win $_nSchema3 -inst "rvsingle"
schPushViewIn -win $_nSchema3
schSelect -win $_nSchema3 -inst "controller"
schPushViewIn -win $_nSchema3
schLastView -win $_nSchema3
schSelect -win $_nSchema3 -inst "datapath"
schPushViewIn -win $_nSchema3
schLastView -win $_nSchema3
debExit
