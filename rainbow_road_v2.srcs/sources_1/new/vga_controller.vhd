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
    pix_clock_i : in std_logic;
    resetn_i    : in std_logic;
    
    vsync_o     : out std_logic;
    hsync_o     : out std_logic
  );
end vga_controller;

architecture Behavioral of vga_controller is
  -- ************************
  -- Hor/Ver sync state enum
  -- ************************
  type SYNC_STATE is (
    BACK_PORCH  ,
    ACTIVE      ,
    SYNC_PULSE  ,
    FRONT_PORCH   
  );

  -- Horizontal sync signals 
  signal hsync_curr_state_r : SYNC_STATE;
  signal hsync_next_state_s : SYNC_STATE;
  signal hsync_count_r      : integer;
  signal hsync_count_s      : integer;

  -- Vertical sync signals
  signal vsync_tick_s       : std_logic;
  signal vsync_curr_state_r : SYNC_STATE;
  signal vsync_next_state_s : SYNC_STATE;
  signal vsync_count_r      : integer;
  signal vsync_count_s      : integer;
begin
  ---------------------------------------------
  ---------------------------------------------
  ----------- HORIZONTAL SYNC LOGIC -----------
  ---------------------------------------------
  ---------------------------------------------
  -- hsync state machine and counter registers
  process (pix_clock_i)
  begin
    if (rising_edge(pix_clock_i)) then
      -- active-low reset
      if (resetn_i = '0') then
        hsync_curr_state_r <= BACK_PORCH;
        hsync_count_r      <= 1;
      else 
        hsync_curr_state_r <= hsync_next_state_s;
        hsync_count_r      <= hsync_count_s;
      end if;
    end if;
  end process;

  -- hsync state machine and counter combinational logic
  process (all) 
  begin
    case (hsync_curr_state_r) is
      ----------------
      -- BACK PORCH --
      ----------------
      when BACK_PORCH => 
        if (hsync_count_r = 48) then
          -- transition states
          hsync_next_state_s <= ACTIVE;
          -- reset counter
          hsync_count_s <= 1; 
        else
          -- defaults
          hsync_next_state_s <= hsync_curr_state_r;
          -- reset counter
          hsync_count_s <= hsync_count_r + 1; 
        end if;
      ------------
      -- ACTIVE --
      ------------
      when ACTIVE => 
        if (hsync_count_r = 640) then
          -- transition states
          hsync_next_state_s <= SYNC_PULSE;
          -- reset counter
          hsync_count_s <= 1; 
        else
          -- defaults
          hsync_next_state_s <= hsync_curr_state_r;
          -- reset counter
          hsync_count_s <= hsync_count_r + 1; 
        end if;
      -----------------
      -- FRONT_PORCH --
      -----------------
      when FRONT_PORCH => 
        if (hsync_count_r = 16) then
          -- transition states
          hsync_next_state_s <= SYNC_PULSE;
          -- reset counter
          hsync_count_s <= 1; 
        else
          -- defaults
          hsync_next_state_s <= hsync_curr_state_r;
          -- reset counter
          hsync_count_s <= hsync_count_r + 1; 
        end if;  
      ----------------
      -- SYNC_PULSE --
      ----------------
      when SYNC_PULSE => 
        if (hsync_count_r = 96) then
          -- transition states
          hsync_next_state_s <= BACK_PORCH;
          -- reset counter
          hsync_count_s <= 1; 
        else
          -- defaults
          hsync_next_state_s <= hsync_curr_state_r;
          -- reset counter
          hsync_count_s <= hsync_count_r + 1; 
        end if;
    end case;
  end process;
  ---------------------------------------------
  ---------------------------------------------
  ------------ VERTICAL SYNC LOGIC ------------
  ---------------------------------------------
  ---------------------------------------------
  -- Increment vertical sync when horizontal sync rolls over!
  vsync_tick_s <= '1' when (hsync_count_r = 0 and hsync_curr_state_r = BACK_PORCH) else '0'     
  
  -- vsync state machine and counter registers
  process (pix_clock_i)
  begin
    if (rising_edge(pix_clock_i)) then
      -- active-low reset
      if (resetn_i = '0') then
        vsync_curr_state_r <= BACK_PORCH;
        vsync_count_r      <= 1;
      elsif (vsync_tick_s = '1') then
        vsync_curr_state_r <= vsync_next_state_s;
        vsync_count_r      <= vsync_count_s;
      else
        vsync_curr_state_r <= vsync_curr_state_r;
        vsync_count_r      <= vsync_count_r;
      end if;
    end if;
  end process;

  -- vsync state machine and counter combinational logic
  process (all) 
  begin
    case (vsync_curr_state_r) is
      ----------------
      -- BACK PORCH --
      ----------------
      when BACK_PORCH => 
        if (vsync_count_r = 33) then
          -- transition states
          vsync_next_state_s <= ACTIVE;
          -- reset counter
          vsync_count_s <= 1; 
        else
          -- defaults
          vsync_next_state_s <= vsync_curr_state_r;
          -- reset counter
          vsync_count_s <= vsync_count_r + 1; 
        end if;
      ------------
      -- ACTIVE --
      ------------
      when ACTIVE => 
        if (vsync_count_r = 480) then
          -- transition states
          vsync_next_state_s <= SYNC_PULSE;
          -- reset counter
          vsync_count_s <= 1; 
        else
          -- defaults
          vsync_next_state_s <= vsync_curr_state_r;
          -- reset counter
          vsync_count_s <= vsync_count_r + 1; 
        end if;
      -----------------
      -- FRONT_PORCH --
      -----------------
      when FRONT_PORCH => 
        if (vsync_count_r = 10) then
          -- transition states
          vsync_next_state_s <= SYNC_PULSE;
          -- reset counter
          vsync_count_s <= 1; 
        else
          -- defaults
          vsync_next_state_s <= vsync_curr_state_r;
          -- reset counter
          vsync_count_s <= vsync_count_r + 1; 
        end if;
      ----------------
      -- SYNC_PULSE --
      ----------------
      when SYNC_PULSE => 
        if (vsync_count_r = 2) then
          -- transition states
          vsync_next_state_s <= BACK_PORCH;
          -- reset counter
          vsync_count_s <= 1; 
        else
          -- defaults
          vsync_next_state_s <= vsync_curr_state_r;
          -- reset counter
          vsync_count_s <= vsync_count_r + 1; 
        end if;
    end case;
  end process;

end Behavioral;

