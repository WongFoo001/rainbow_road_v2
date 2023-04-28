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

    clock_valid_o     : out std_logic;
    clock_div_25Mhz_o : out std_logic
  );
end clock_div;

architecture rtl of clock_div is
  signal clock_count_r : integer := 1;
  signal clock_div_r   : std_logic;

  signal clock_valid_r : std_logic;
  signal clock_train_r : integer;
  --signal clock_valid_next : std_logic;
begin
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

-- clock valid and training process
process (clock_i)
begin
  if (rising_edge(clock_i)) then
    if (resetn_i = '0') then
      -- reset clock valid
      clock_valid_r <= '0';
      -- reset clock training count
      clock_train_r <= 0;
    else
      if (clock_train_r < 40) then
        clock_train_r <= clock_train_r + 1;
        clock_valid_r <= clock_valid_r;
      else
        clock_train_r <= clock_train_r;
        clock_valid_r <= '1';
      end if;
    end if;
  end if;
end process;

-- Drive clock output 
clock_div_25Mhz_o <= clock_div_r;

-- Drive valid output 
clock_valid_o <= clock_valid_r;
--clock_valid_o <= '0' when not resetn_i else '1';
end rtl;
