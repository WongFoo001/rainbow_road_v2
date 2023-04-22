`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simple directed testbench for vga_controller.vhd module
//
// Implements 640 x 480 25.175 MHz vga controller
/////////////////////////////////////////////////////////////////////////////////

module vga_controller_tb();
  // Inputs
  logic pix_clock_i, resetn_i;
  // Outputs
  logic vsync_o, hsync_o;
  logic [8:0] vsync_count_o;
  logic [9:0] hsync_count_o;

  // Design under test
  vga_controller DUT (
    .pix_clock_i   ( pix_clock_i   ),
    .resetn_i      ( resetn_i      ),
    .vsync_o       ( vsync_o       ), 
    .vsync_count_o ( vsync_count_o ),
    .hsync_o       ( hsync_o       ),
    .hsync_count_o ( hsync_count_o )
  );

  // Clock generation - nominal pixel clock is 25.175 MHz
  // 25 MHz -> 40ns period
  initial begin
    pix_clock_i = 0;
    forever begin
      #2; // Half target period
      pix_clock_i = ~pix_clock_i;
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
