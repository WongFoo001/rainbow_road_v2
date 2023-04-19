`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simple directed testbench for clock_div.vhd module
//
// Implements 50% duty cycle divided clock.
/////////////////////////////////////////////////////////////////////////////////

module clock_div_tb();
  // Inputs
  logic clock_i, resetn_i;
  // Outputs
  logic clock_div_25Mhz_o;
  
  // Design under test
  clock_div DUT (
    .clock_i           ( clock_i           ),
    .resetn_i          ( resetn_i          ),
    .clock_div_25Mhz_o ( clock_div_25Mhz_o )
  );

  // Clock generation - nominal source clock is 100 MHz
  // 100 MHz -> 10ns period
  initial begin
    clock_i = 0;
    forever begin
      #5; // Half target period
      clock_i = ~clock_i;
    end
  end

  // Other stimulus
  initial begin
    resetn_i = 0;
    #20;
    resetn_i = 1;
    #1000;
    $finish();
  end
endmodule
