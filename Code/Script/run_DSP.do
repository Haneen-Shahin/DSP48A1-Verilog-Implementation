vlib work
vlog DSP48A1.v register.v DSP_tb.v
vsim -voptargs=+acc work.DSP_tb
add wave *
run -all 
#quit -sim
