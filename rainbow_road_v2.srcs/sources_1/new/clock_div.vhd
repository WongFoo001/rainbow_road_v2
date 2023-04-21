----------------------------------------------------------------------------------
-- Simple 1/4x clock divider
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.NUMERIC_STD.all;

entity clock_div is
  Generic (
    CLOCK_DIV_C : integer := 2
  );
  
  Port ( 
    clock_i           : in std_logic;
    resetn_i          : in std_logic;

    clock_div_25Mhz_o : out std_logic
  );
end clock_div;

architecture rtl of clock_div is
  signal clock_count_r : integer := 1;
  signal clock_div_r   : std_logic;
begin
-- First clock stage
process (clock_i)
begin
  if (rising_edge(clock_i)) then
    -- active-low reset event
    if (resetn_i = '0') then
      -- reset counter
      clock_count_r <= 0;
      -- reset divided clock
      clock_div_r <= '0';
    
    -- Roll counter over at division
    elsif (clock_count_r = CLOCK_DIV_C-1) then
      clock_count_r <= 0;
      -- invert clock_div signal
      clock_div_r <= not clock_div_r;
    
    else 
      -- increment counter
      clock_count_r <= clock_count_r + 1;
      -- drive clock_div constant
      clock_div_r <= clock_div_r;
    end if;
  end if;
end process;

-- Drive output 
clock_div_25Mhz_o <= clock_div_r;

end rtl;
