----------------------------------------------------------------------------------
-- Simple parameterized clock divider
-- default division is 1/4x
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.NUMERIC_STD.all;

entity clock_div is
  Port ( 
    clock_i           : in std_logic;
    resetn_i          : in std_logic;

    clock_div_25Mhz_o : out std_logic
  );
end clock_div;

architecture rtl of clock_div is
  --signal clock_value_r : std_logic;
  signal clock_count_r : unsigned (1 downto 0);
begin
-- Down counter
process (clock_i)
begin
  if (rising_edge(clock_i)) then
    -- active-low reset event
    if (resetn_i = '0') then
      clock_count_r <= (others => '0');
    elsif (clock_count_r(1) = '1') then
      clock_count_r <= (others => '0');
    else 
      clock_count_r <= clock_count_r + 1;
    end if;
  end if;
end process;

-- Invert clock every 2 cycles
--clock_value_r <= not clock_value_r when clock_count_r(1) = '1' else clock_value_r;

-- Drive output 
clock_div_25Mhz_o <= not clock_div_25Mhz_o when clock_count_r(1) = '1' else clock_div_25Mhz_o;
--clock_div_25Mhz_o <= clock_value_r;
end rtl;
