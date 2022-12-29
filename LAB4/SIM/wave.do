onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/INPUT_switch
add wave -noupdate /tb/enaY
add wave -noupdate /tb/enaALUFN
add wave -noupdate /tb/enaX
add wave -noupdate /tb/Yin
add wave -noupdate /tb/Xin
add wave -noupdate /tb/ALUFN_out
add wave -noupdate /tb/ALUout
add wave -noupdate /tb/Nflag
add wave -noupdate /tb/Cflag
add wave -noupdate /tb/Zflag
add wave -noupdate /tb/Icache
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {689746 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {197558 ps} {1181934 ps}
