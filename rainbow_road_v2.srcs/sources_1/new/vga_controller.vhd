----------------------------------------------------------------------------------
-- Simple VGA controller based off of industry standary
-- 640 x 480 @ 60 Hz refresh-rate.
-- System clock: 100 MHz
-- Pixel clock : 25.175 MHz
-- ****************************************************
-- Horizontal timing (line)
----------------------------
-- Part of Screen  | Pixels 
----------------------------
-- Visible screen  | 640
-- Front porch     | 16
-- Sync pulse      | 96
-- Back porch      | 48
----------------------------
-- Total per line  | 800
-- ****************************************************
-- ****************************************************
-- Vertical timing (frame)
---------------------------
-- Part of Screen  | Lines  
---------------------------
-- Visible screen  | 480
-- Front porch     | 10
-- Sync pulse      | 2
-- Back porch      | 33
----------------------------
-- Total per frame | 500
-- ****************************************************
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_controller is
  Port ( 
    clock_100MHz_i : in std_logic;
    resetn_i       : in std_logic;
    
    vsync_o      : out std_logic;
    hsync_o      : out std_logic
  );
end vga_controller;

architecture Behavioral of vga_controller is
  -- *****************************
  -- Horizontal sync state machine 
  -- *****************************

begin


end Behavioral;
