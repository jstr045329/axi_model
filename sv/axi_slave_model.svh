// This class strives to model the interface specified in:
// AMBA AXI Stream Protocol Specification.pdf
import axi_model_pkg::axi_model;

class axi_slave_model extends axi_model;

bit [TDATA_WIDTH-1:0] output_buffer [$];
logic prev_tvalid;

function new();
    super.new();
    output_buffer = {};
    tready = 1'b0;
endfunction

function clear_output_buffer();
    output_buffer = {};
endfunction

function int output_buffer_size();
    return output_buffer.size();
endfunction

function safe2peek();
    return output_buffer.size() > 0;
endfunction

function safe2pop();
    return safe2peek();
endfunction

function [TDATA_WIDTH-1:0] peek();
    logic [TDATA_WIDTH-1:0] tmp;
    tmp = 0;
    if (output_buffer.size() > 0) begin 
        tmp = output_buffer[0];
    end
    return tmp;
endfunction

function [TDATA_WIDTH-1:0] pop();
    logic [TDATA_WIDTH-1:0] tmp;
    tmp = 0;
    if (output_buffer.size() > 0) begin
        tmp = output_buffer[0];
        output_buffer = output_buffer[1:$];
    end
    return tmp;
endfunction

// This task waits until tvalid and tready are both asserted, and then stores
// contents in output buffer.
task slurp();
    int ii = 0;
    tready = 1'b1;
    while (~tvalid) @(posedge aclk);
    while (1) begin
        @(posedge aclk);
        prev_tvalid <= tvalid;
        ii++;
        if (~tvalid) begin 
            // TODO: Check the standard. When tvalid is de-asserted, do you grab tdata for that clk and then 
            // pause the next clock? 
            @(posedge aclk);
            continue;
        end else begin
            output_buffer = {output_buffer, tdata};
            if (tlast) begin 
                return;
            end
        end
    end
endtask

endclass

