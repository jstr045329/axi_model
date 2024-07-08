uut: sv/axis_rotate.sv
	vlib work
	vlog -reportprogress 300 -work work ./sv/axis_rotate.sv

my_axi_model: 
	vlog -reportprogress 300 -work work \
		./sv/axi_model.svh
	vlog -reportprogress 300 -work work \
		./sv/axi_model_pkg.svh
	vlog -reportprogress 300 -work work \
		./sv/axi_master_model.svh 
	vlog -reportprogress 300 -work work \
		./sv/axi_slave_model.svh
	vlog -reportprogress 300 -work work \
		./sv/axi_model_pkg.svh
	vlog -reportprogress 300 -work work \
		./sv/interruption.svh

model_tb_01: my_axi_model
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_01.sv
	vsim axi_model_tb_01

model_tb_02: my_axi_model
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_01.sv
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_02.sv
	vsim axi_model_tb_02 -c

model_tb_03: my_axi_model
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_01.sv
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_03.sv
	vsim axi_model_tb_03 -c

model_tb_04: my_axi_model
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_01.sv
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_04.sv
	vsim axi_model_tb_04

model_tb_05: my_axi_model
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_01.sv
	vlog -reportprogress 300 -work work \
		./test/axi_model_tb_05.sv
	vsim axi_model_tb_05

