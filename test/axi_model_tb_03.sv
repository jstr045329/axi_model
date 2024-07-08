// Testbench for axis_rotate
// Testbench variant: 01
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps
import axi_model_pkg::axi_master_model;
import axi_model_pkg::axi_slave_model;
import interruption::*;

module axi_model_tb_03;

axi_model_tb_01 #(
    .MAX_INTERRUPTIONS(2),
    .MIN_POWER_OF_2(4),
    .MAX_POWER_OF_2(5),
    .RAND_SEED(2727272)
) axi_model_tb_01_inst ();

endmodule

