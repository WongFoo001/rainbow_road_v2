`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simple directed testbench for rainbow_road_top.vhd module
/////////////////////////////////////////////////////////////////////////////////

module rainbow_road_top_tb();
  logic clock_100MHz_i, resetn_i;
  logic vga_vsync_o, vga_hsync_o;
  logic [3:0] vga_red_o, vga_blue_o, vga_green_o;

  rainbow_road_top DUT (
    .clock_100MHz_i(clock_100MHz_i),
    .resetn_i      (resetn_i),

    // VGA outputs
    .vga_red_o     (vga_red_o),
    .vga_blue_o    (vga_blue_o),
    .vga_green_o   (vga_green_o),

    .vga_vsync_o   (vga_vsync_o),
    .vga_hsync_o   (vga_hsync_o)
  );

  // Clock generation - nominal 100 MHz
  // -> 10ns period
  initial begin
    clock_100MHz_i = 0;
    forever begin
      #5; // Half target period
      clock_100MHz_i = ~clock_100MHz_i;
    end
  end

  // Other stimulus
  initial begin
    resetn_i = 1;
    #50ns
    resetn_i = 0;
    #50ns;
    resetn_i = 1;
    #50ms;
    $finish();
  end
endmodule
