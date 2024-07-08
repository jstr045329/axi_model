// Testbench for axis_rotate
// Testbench variant: 01
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps
import axi_model_pkg::axi_master_model;
import axi_model_pkg::axi_slave_model;
import interruption::*;

module axi_model_tb_04;

axi_model_tb_01 #(
    .MAX_INTERRUPTIONS(1),
    .MIN_POWER_OF_2(4),
    .MAX_POWER_OF_2(8),
    .RAND_SEED(404),
    .TX_MAX_DELAY_BETWEEN_TRANSACTIONS(128),
    .RX_MAX_DELAY_BETWEEN_TRANSACTIONS(128)
) axi_model_tb_04_inst ();

endmodule

