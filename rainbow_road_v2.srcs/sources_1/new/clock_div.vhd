----------------------------------------------------------------------------------
-- Simple parameterized clock divider
-- default division is 1/4x
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity clock_div is
  generic (
    CLK_DIV_C             : INTEGER := 4;
    CLK_DIV_COUNT_WIDTH_C : INTEGER := 3
  );
  Port ( 
    clock_i     : in std_logic;
    resetn_i    : in std_logic;

    clock_div_o : out std_logic
  );
end clock_div;

architecture rtl of clock_div is
  signal clock_count_r : UNSIGNED(CLK_DIV_COUNT_WIDTH_C downto 0);
begin
-- down counter
process (clock_i) 
begin
  if (rising_edge(clock_i)) then
    -- active-low reset
    if (resetn_i = '0' or clock_count_r = '0') then
      clock_count_r <= to_unsigned(CLK_DIV_C, clock_count_r'length);
    else
      clock_count_r <= clock_count_r - '1';
    end if;
  end if;
end process;
-- drive divided clock
process (all) 
begin
  if (clock_count_r = 0) then
    clock_div_o <= not clock_div_o;
  end if ;
end process;
end Behavioral;
