// Testbench for axis_rotate
// Testbench variant: 01
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps
import axi_model_pkg::axi_master_model;
import axi_model_pkg::axi_slave_model;
import interruption::*;

module axi_model_tb_01;

parameter MAX_INTERRUPTIONS = 0;
parameter MIN_POWER_OF_2 = 4;
parameter MAX_POWER_OF_2 = 5;
parameter RAND_SEED = 42;
parameter TX_MAX_DELAY_BETWEEN_TRANSACTIONS = 0;
parameter RX_MAX_DELAY_BETWEEN_TRANSACTIONS = 0;

parameter TDATA_WIDTH=32;
parameter TKEEP_WIDTH=4;
parameter TSTRB_WIDTH=4;
parameter TID_WIDTH=8;
parameter TDEST_WIDTH=8;
parameter TUSER_WIDTH=8;
parameter TX_INTERRUPT_CHOICE = 0;
parameter RX_INTERRUPT_CHOICE = 0;

axi_master_model data_source;
axi_slave_model data_sink;

int points_possible;
int points_earned;
logic aclk;
logic aresetn;
int test_stage;
logic [TDATA_WIDTH-1:0] s_axis_tdata;
logic s_axis_tlast;
logic s_axis_tready;
logic s_axis_tvalid;
logic [TKEEP_WIDTH-1:0] s_axis_tkeep;
logic [TSTRB_WIDTH-1:0] s_axis_tstrb;
logic [TUSER_WIDTH-1:0] s_axis_tuser;
logic [TID_WIDTH-1:0] s_axis_tid;
logic [TDEST_WIDTH-1:0] s_axis_tdest;
logic s_axis_twakeup;
int input_record [$];
int mm = 0;
int new_idx = 0;
logic done_reading;
int tx_delay;
int rx_delay;

//----------------------------------------------------------------------------------------------------------------------
//                                                    Drive Clock
//----------------------------------------------------------------------------------------------------------------------
initial begin 
    aclk = 1'b1;
    forever begin 
        #5 aclk = ~aclk;
    end
end

always_comb begin 
    if (data_source != null) begin 
        data_source.aclk = aclk;
        data_source.tready = s_axis_tready;
        // s_axis_tready <= data_source.tready; // Note: This one has an unblocking assignment. Not sure if added latency will create problems. 
        data_sink.aclk = aclk;
    end
end
//----------------------------------------------------------------------------------------------------------------------
//                                                        UUT
//----------------------------------------------------------------------------------------------------------------------
always @(posedge aclk) begin 
    if (aresetn == 1'b0) begin 
        s_axis_tdata <= 0;
        s_axis_tlast <= 0;
        s_axis_tvalid <= 0;
        s_axis_tkeep <= 0;
        s_axis_tstrb <= 0;
        s_axis_tuser <= 0;
        s_axis_tid <= 0;
        s_axis_tdest <= 0;
        s_axis_twakeup <= 0;
        s_axis_tready <= 0;
    end else begin 
        s_axis_tdata <= data_source.tdata;
        s_axis_tlast <= data_source.tlast;
        s_axis_tvalid <= data_source.tvalid;
        s_axis_tkeep <= data_source.tkeep;
        s_axis_tstrb <= data_source.tstrb;
        s_axis_tuser <= data_source.tuser;
        s_axis_tid <= data_source.tid;
        s_axis_tdest <= data_source.tdest;
        s_axis_twakeup <= data_source.twakeup;
        s_axis_tready <= data_sink.tready;
    end
end

// TODO: Think about whether I need to add delay here
always_comb begin 
    if (data_source != null) begin 
        data_source.tready = s_axis_tready;
    end
end

always_comb begin 
    if (data_sink != null) begin 
        data_sink.tdata = s_axis_tdata;
        data_sink.tlast = s_axis_tlast; 
        data_sink.tvalid = s_axis_tvalid; 
        data_sink.tkeep = s_axis_tkeep; 
        data_sink.tstrb = s_axis_tstrb; 
        data_sink.tuser = s_axis_tuser; 
        data_sink.tid = s_axis_tid; 
        data_sink.tdest = s_axis_tdest; 
        data_sink.twakeup = s_axis_twakeup; 
    end
end

//----------------------------------------------------------------------------------------------------------------------
//                                                   Stim Process
//----------------------------------------------------------------------------------------------------------------------
initial begin 
    //----------------------------------------------------------------------------------------------------------------------
    //                                                   Test Stage 0
    //----------------------------------------------------------------------------------------------------------------------
    test_stage <= 0;
    aresetn <= 1'b0;
    data_source = new();
    input_record = {};
    #100 aresetn <= 1'b1;
    #1000;
    $urandom(RAND_SEED);
    for (int kk = MIN_POWER_OF_2; kk <= MAX_POWER_OF_2; kk++) begin
        for (int max_interruptions = 0; max_interruptions <= MAX_INTERRUPTIONS; max_interruptions++) begin 
            test_stage++;
            $display($sformatf("******************************** Starting a %d Transaction ******************************", 2**kk));
            data_source.when_to_interrupt = interruption(max_interruptions, 2**kk, 8);
            $display("Here are the interruptions:");
            $display(data_source.when_to_interrupt);
            for (int ii = 0; ii < (2**kk); ii++) begin 
                mm = $urandom();
                data_source.push(mm);
                // TODO: Drive other input buses randomly, then calculate correct answer
                // if (ii > 0) input_record = {input_record, mm}; 
                input_record = {input_record, mm}; 
            end
            // #10 data_source.drive_transaction_destructive();
            if (TX_MAX_DELAY_BETWEEN_TRANSACTIONS > 0) begin 
                tx_delay = $urandom_range(1, 128);
                for (int ww = 0; ww < tx_delay; ww++) begin 
                    @(posedge aclk);
                end
            end
            data_source.drive_transaction_destructive();
            // TODO: Add a parameter that chooses number of clocks between transaction
        end
    end
    while (~done_reading) @(posedge aclk);
    #100 $stop;
end

initial begin 
    done_reading = 0;
    data_sink = new();
    for (int kk = MIN_POWER_OF_2; kk <= MAX_POWER_OF_2; kk++) begin 
        for (int max_interruptions = 0; max_interruptions <= MAX_INTERRUPTIONS; max_interruptions++) begin 
            data_sink.when_to_interrupt = interruption(max_interruptions, 2**kk, 5);
            data_sink.slurp();
            if (RX_MAX_DELAY_BETWEEN_TRANSACTIONS > 0) begin 
                rx_delay = $urandom_range(1, 128);
                for (int qq = 0; qq < tx_delay; qq++) begin 
                    @(posedge aclk);
                end
            end
        end
    end
    $display("Correct Answer             Dest Buffer ");
    $display("---------------------------------------");
    for (int kk = 0; kk < data_sink.output_buffer.size(); kk++) begin 
        $display($sformatf("%08d           %08h           %08h", kk, input_record[kk], data_sink.output_buffer[kk]));
    end

    data_sink.output_buffer = {};
    done_reading = 1;
    #100;
end

endmodule

