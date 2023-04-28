----------------------------------------------------------------------------------
-- Package file for rainbow_road_top.vhd
-- 
-- Defines top-level constants and component declarations for instantiation
-- in the top-level module
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package rainbow_road_pkg is
  -- 1 sec constant, assumes 100 MHz clock
  constant COLOR_CHANGE_COUNT_C : integer := 100000000;
  -- vga clock divider constant 100 MHz -> 25 MHz
  constant VGA_CLOCK_CONST_C    : integer := 2;

  -- VGA clock divider component
  component clock_div is
    generic (
      CLOCK_DIV_C : integer := VGA_CLOCK_CONST_C);
    Port ( 
      clock_i           : in std_logic;
      resetn_i          : in std_logic;

      clock_valid_o     : out std_logic;
      clock_div_25Mhz_o : out std_logic);
  end component;

  -- VGA controller component
  component vga_controller is
    Port ( 
      pix_clock_i   : in std_logic;
      resetn_i      : in std_logic;
    
      -- vertical sync outputs
      vsync_o       : out std_logic;
      vsync_count_o : out std_logic_vector(8 downto 0);
      -- horizontal sync outputs
      hsync_o       : out std_logic;
      hsync_count_o : out std_logic_vector(9 downto 0));
  end component;
end rainbow_road_pkg;
