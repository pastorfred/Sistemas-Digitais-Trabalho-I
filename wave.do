onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /tb_ondeestou/a1/clock
add wave -noupdate -label reset /tb_ondeestou/a1/reset
add wave -noupdate -label x -radix decimal /tb_ondeestou/a1/x
add wave -noupdate -label y -radix decimal /tb_ondeestou/a1/y
add wave -noupdate -label achar /tb_ondeestou/a1/achar
add wave -noupdate -label prog /tb_ondeestou/a1/prog
add wave -noupdate -label address -radix decimal /tb_ondeestou/a1/address
add wave -noupdate -label ponto /tb_ondeestou/a1/ponto
add wave -noupdate -label fim /tb_ondeestou/a1/fim
add wave -noupdate -label sala -radix decimal /tb_ondeestou/a1/sala
add wave -noupdate -label salas -radix decimal /tb_ondeestou/a1/salas
add wave -noupdate -label EA /tb_ondeestou/a1/EA
add wave -noupdate -label PE /tb_ondeestou/a1/PE
add wave -noupdate -label xbusca -radix decimal /tb_ondeestou/a1/xbusca
add wave -noupdate -label ybusca -radix decimal /tb_ondeestou/a1/ybusca
add wave -noupdate -label x0 -radix decimal /tb_ondeestou/a1/x0
add wave -noupdate -label y0 -radix decimal /tb_ondeestou/a1/y0
add wave -noupdate -label x1 -radix decimal /tb_ondeestou/a1/x1
add wave -noupdate -label y1 -radix decimal /tb_ondeestou/a1/y1
add wave -noupdate -label deltax -radix decimal /tb_ondeestou/a1/deltax
add wave -noupdate -label deltay -radix decimal /tb_ondeestou/a1/deltay
add wave -noupdate -label check_sala -radix decimal /tb_ondeestou/a1/check_sala
add wave -noupdate -label cont_sala -radix decimal /tb_ondeestou/a1/cont_sala
add wave -noupdate -label count -radix decimal /tb_ondeestou/a1/count
add wave -noupdate -label N_SALAS /tb_ondeestou/a1/N_SALAS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3942879 ps} 0} {{Cursor 2} {12491069 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {14820750 ps}
