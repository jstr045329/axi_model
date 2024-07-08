`ifndef __INTERRUPTION__
`define __INTERRUPTION__

package interruption;

typedef int interruption_t [int];
function interruption_t interruption(int num_interruptions, vector_len, max_interruption_length);
    interruption_t y;
    int length_of_one_interruption;
    int starting_place;
    int interruptions_left;
    y = '{-1: 0};
    interruptions_left = num_interruptions;
    if (num_interruptions == 0) return y;
    // Test interruptions close to the extreme ends of the transaction:
    if ($urandom_range(0, 1024) < 128) begin 
        y[1] = 0;
        interruptions_left--;
    end

    if (($urandom_range(0, 1024) < 256) && (interruptions_left > 0)) begin
        y[2] = 0;
        interruptions_left--;
    end

    if (($urandom_range(0, 1024) < 512) && (interruptions_left > 0)) begin 
        y[3] = 0;
        interruptions_left--;
    end

    if (($urandom_range(0, 1024) < 512) && (interruptions_left > 0)) begin 
        y[vector_len-3] = 0;
        interruptions_left--;
    end

    if (($urandom_range(0, 1024) < 512) && (interruptions_left > 0)) begin 
        y[vector_len-2] = 0;
        interruptions_left--;
    end

    if (($urandom_range(0, 1024) < 512) && (interruptions_left > 0)) begin 
        y[vector_len-1] = 0;
        interruptions_left--;
    end

    // Add interruptions of random lengths at random locations:
    for (int ii = 0; ii < num_interruptions; ii++) begin 
        if (interruptions_left <= 0) begin 
            return y;
        end
        length_of_one_interruption = $urandom_range(1, max_interruption_length);
        starting_place = $urandom_range(4, vector_len-4);
        for (int nth_bit_of_interruption = 1; nth_bit_of_interruption <= length_of_one_interruption; nth_bit_of_interruption++) begin 
            y[starting_place - nth_bit_of_interruption] = 0;
            interruptions_left--;
            // TODO: Adjust thresholds
            // TODO: Verify you get the correct number of interruptions
        end
    end
    return y;
endfunction

endpackage

`endif

