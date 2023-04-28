----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Custom package file
library work;
use work.rainbow_road_pkg.all;

entity rainbow_road_top is
  Port (
    clock_100MHz_i : in std_logic;
    resetn_i       : in std_logic;

    -- VGA outputs
    vga_red_o   : out std_logic_vector (3 downto 0);
    vga_blue_o  : out std_logic_vector (3 downto 0);
    vga_green_o : out std_logic_vector (3 downto 0);

    vga_vsync_o : out std_logic;
    vga_hsync_o : out std_logic
  );
end rainbow_road_top;

architecture Behavioral of rainbow_road_top is
  -- VGA clock signals
  signal vga_clock_s     : std_logic;
  signal vga_clk_valid_s : std_logic;

  -- VGA count signals
  signal vsync_count_s   : std_logic_vector (8 downto 0);
  signal hsync_count_s   : std_logic_vector (9 downto 0);

  -- VGA color signals
  --signal vga_red_r      : unsigned (3 downto 0);
  --signal vga_blue_r     : unsigned (3 downto 0);
  --signal vga_green_r    : unsigned (3 downto 0);

  -- VGA color change counter signals
  signal led_count_r     : integer; 
  signal led_count_next  : integer;
begin
  -- COLOR CHANGE COUNTER BEGIN
  -- combinational process
  process(all)
  begin
    -- roll count over at 1 sec
    if (led_count_r = 100_000_000) then
      -- reset LED count
      led_count_next <= 0;
    else 
      -- just increment counter
      led_count_next <= led_count_r + 1;
    end if;
  end process;

  -- flip-flop process
  process (clock_100MHz_i) 
  begin
    if (resetn_i = '0') then
      led_count_r <= 0;
    else
      led_count_r <= led_count_next;
    end if;
  end process;
  -- COLOR CHANGE COUNTER END

  -- VGA clock divider instantiation
  vga_clock_div_inst : clock_div
    generic map (
      CLOCK_DIV_C => VGA_CLOCK_CONST_C
    )
    port map (
      -- inputs
      clock_i           => clock_100MHz_i,
      resetn_i          => resetn_i,
      -- outputs
      clock_valid_o     => vga_clk_valid_s,
      clock_div_25Mhz_o => vga_clock_s
    );
  
  -- VGA controller instantiation
  vga_controller_inst: vga_controller
    port map (
      -- inputs
      pix_clock_i   => vga_clock_s,
      resetn_i      => vga_clk_valid_s,
      -- outputs
      vsync_o       => vga_vsync_o,
      vsync_count_o => vsync_count_s,
      hsync_o       => vga_hsync_o,
      hsync_count_o => hsync_count_s
    );
  
  -- Assign color outputs (temporarily)
  vga_red_o   <= (others => '0');
  vga_blue_o  <= (others => '0');
  vga_green_o(0) <= '0';
  vga_green_o(1) <= '1';
  vga_green_o(2) <= '1';
  vga_green_o(3) <= '0';
end Behavioral;
