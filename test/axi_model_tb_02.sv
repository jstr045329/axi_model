// Testbench for axis_rotate
// Testbench variant: 01
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps
import axi_model_pkg::axi_master_model;
import axi_model_pkg::axi_slave_model;
import interruption::*;

module axi_model_tb_02;

axi_model_tb_01 #(
    .MAX_INTERRUPTIONS(1),
    .MIN_POWER_OF_2(4),
    .MAX_POWER_OF_2(8),
    .RAND_SEED(404)
) axi_model_tb_01_inst ();

endmodule

