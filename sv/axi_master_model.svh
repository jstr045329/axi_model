// This class strives to model the interface specified in:
// AMBA AXI Stream Protocol Specification.pdf
import axi_model_pkg::axi_model;

class axi_master_model extends axi_model;

bit [TDATA_WIDTH-1:0] input_buffer [$];

function new();
    super.new();
    input_buffer = {};
endfunction

function clear_input_buffer();
    input_buffer = {};
endfunction

function push(logic [TDATA_WIDTH-1:0] x);
    input_buffer = {input_buffer, x};
endfunction

task drive_transaction_nondestructive();
    tvalid = 1'b1;
    while (tready == 1'b0) begin 
        @(posedge aclk);
    end
    for (int ii = 0; ii < input_buffer.size(); ii++) begin 
        tdata = input_buffer[ii];
        @(posedge aclk);
    end
    tvalid = 1'b0;
    @(posedge aclk);
endtask

task drive_transaction_destructive();
    // Note: This transaction can be thrown off if another process
    // writes to input_buffer at the same time input_buffer.size() 
    // == 1. tlast can be strobed illegally in that case. Therefore 
    // this class is not recommended for simultaneous read-write
    // situations.
    //
    // One option is for the write process to check the buffer size.
    // As long as write process only writes when buffer size is greater
    // than, say, 10, everything should be fine.
    int ii = 0;
    logic just_left_interruption;
    tvalid = 1'b1;
    @(posedge aclk);
    just_left_interruption = 1'b0;

    while ((tready == 1'b0) || (input_buffer.size() == 0)) begin 
        @(posedge aclk);
    end

    while (input_buffer.size() > 0) begin 
        while (when_to_interrupt.exists(ii)) begin 
            tvalid = 1'b0;
            @(posedge aclk);
            ii++;
            just_left_interruption = 1'b1;
        end
       
        if (just_left_interruption) begin 
            tvalid = 1'b1;
            just_left_interruption = 1'b0;
            @(posedge aclk);
        end
         
        if (tready == 1'b0) begin 
            @(posedge tready);
        end

        tdata = input_buffer[0];
        tlast = (input_buffer.size() == 1) ? 1'b1 : 1'b0;
        input_buffer = input_buffer[1:$];
        @(posedge aclk);
        if (tlast) begin 
            tlast = 0;
            tdata = 0;
            tvalid = 0;
            tstrb = 0;
            tkeep = 0;
            tid = 0;
            tdest = 0;
            tuser = 0;
            twakeup = 0;
        end
        ii++;
    end
    tvalid = 1'b0;
    @(posedge aclk);
endtask

endclass

