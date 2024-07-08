// Testbench for axis_rotate
// Testbench variant: 01
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps
import axi_model_pkg::axi_master_model;
import axi_model_pkg::axi_slave_model;
import interruption::*;

module axi_model_tb_05;

axi_model_tb_01 #(
    .MAX_INTERRUPTIONS(3),
    .MIN_POWER_OF_2(5),
    .MAX_POWER_OF_2(7),
    .RAND_SEED(3393937),
    .TX_MAX_DELAY_BETWEEN_TRANSACTIONS(17),
    .RX_MAX_DELAY_BETWEEN_TRANSACTIONS(42)
) axi_model_tb_04_inst ();

endmodule

