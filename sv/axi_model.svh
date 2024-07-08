// This class strives to model the interface specified in:
// AMBA AXI Stream Protocol Specification.pdf
`ifndef __AXI_MODEL__
`define __AXI_MODEL__

class axi_model;

parameter TDATA_WIDTH = 32;
parameter TSTRB_WIDTH = 8;
parameter TKEEP_WIDTH = 8;
parameter TID_WIDTH = 8;
parameter TDEST_WIDTH = 8;
parameter TUSER_WIDTH = 8;

bit aclk;
bit aresetn;
bit tvalid;
bit tready;
bit [TDATA_WIDTH-1:0] tdata;
bit [TSTRB_WIDTH-1:0] tstrb;
bit [TKEEP_WIDTH-1:0] tkeep;
bit tlast;
bit [TID_WIDTH-1:0] tid;
bit [TDEST_WIDTH-1:0] tdest;
bit [TUSER_WIDTH-1:0] tuser;
bit twakeup;

// The following hash table (int -> int) is being used as a hash set.
// Only the keys matter. Ignore the contents. 
int when_to_interrupt [int];

//----------------------------------------------------------------------------------------------------------------------
//                                                    Constructor
//----------------------------------------------------------------------------------------------------------------------
function new();
    aclk = 0;
    aresetn = 1;
    tvalid = 0;
    tready = 0;
    tdata = 0;
    tstrb = 0;
    tkeep = 0;
    tlast = 0;
    tid = 0;
    tdest = 0;
    tuser = 0;
    twakeup = 0;
    when_to_interrupt = '{-1: -1};
endfunction

endclass
`endif

