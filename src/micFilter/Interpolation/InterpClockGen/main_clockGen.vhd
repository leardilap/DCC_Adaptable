-------------------------------------------------------------------
--               Interpolation Clock Generator                   --
--                                                               --
--  Generates clocks for multiple stage interpolation. Up to     --
--  five clocks can be generated. Each clock is define by the    --
--  duration of its high and low period as multilples of clk_in. --
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InterpClkGen is
	Generic (	lPeriod1	: INTEGER := 4;		    -- Low period (in multiple of clk_in periods)
                hPeriod1    : INTEGER := 4;         -- High period (in multiple of clk_in periods)
                lPeriod2    : INTEGER := 4;
                hPeriod2    : INTEGER := 4;
                lPeriod3    : INTEGER := 4;
                hPeriod3    : INTEGER := 4;
                lPeriod4    : INTEGER := 4;
                hPeriod4    : INTEGER := 4);
Port (  clk_in            : in STD_LOGIC;           -- Input clock
        rst               : in STD_LOGIC;           -- Reset
        clk_1             : out STD_LOGIC := '0';   -- Output clock 1
        clk_2             : out STD_LOGIC := '0';   -- Output clock 2
        clk_3             : out STD_LOGIC := '0';   -- Output clock 3
        clk_4             : out STD_LOGIC := '0');  -- Output clock 4
end InterpClkGen;

architecture behav_intClkGen of InterpClkGen is
    --- Constants ---------------------------------------
    constant clk1l : INTEGER := lPeriod1-1;
    constant clk1p : INTEGER := clk1l+hPeriod1;
    constant clk2l : INTEGER := lPeriod2-1;
    constant clk2p : INTEGER := clk2l+hPeriod2;
    constant clk3l : INTEGER := lPeriod3-1;
    constant clk3p : INTEGER := clk3l+hPeriod3;
    constant clk4l : INTEGER := lPeriod4-1;
    constant clk4p : INTEGER := clk4l+hPeriod4;
    --- Signals -----------------------------------------
    signal clk1, clk2, clk3, clk4 : STD_LOGIC := '0';
    signal count1 : INTEGER RANGE 0 TO (clk1p+1) := 0; 		-- counter variables
    signal count2 : INTEGER RANGE 0 TO (clk2p+1) := 0; 
    signal count3 : INTEGER RANGE 0 TO (clk3p+1) := 0; 
    signal count4 : INTEGER RANGE 0 TO (clk4p+1) := 0; 
begin
    process(clk_in)
    begin
        if (clk_in'event and clk_in='1') then
            if (rst = '1') then
                count1 <= 0;
                count2 <= 0;
                count3 <= 0;
                count4 <= 0;
            else
                -- Clock 1 --
                if (count1 <= clk1l) then
                    clk1 <= '0';
                else
                    clk1 <= '1';
                end if;
                if (count1 >= clk1p) then
                    count1 <= 0;
                else
                    count1 <= count1+1;
                end if;       
                -- Clock 2 --
                if (count2 <= clk2l) then
                    clk2 <= '0';
                else
                    clk2 <= '1';
                end if;
                if (count2 >= clk2p) then
                    count2 <= 0;
                else
                    count2 <= count2+1;
                end if;       
                -- Clock 3 --
                if (count3 <= clk3l) then
                    clk3 <= '0';
                else
                    clk3 <= '1';
                end if;
                if (count3 >= clk3p) then
                    count3 <= 0;
                else
                    count3 <= count3+1;
                end if;
                -- Clock 4 --
                if (count4 <= clk4l) then
                    clk4 <= '0';
                else
                    clk4 <= '1';
                end if;
                if (count4 >= clk4p) then
                    count4 <= 0;
                else
                    count4 <= count4+1;
                end if;       
            end if;
        end if;
    end process;  
	
    clk_1 <= clk1;
    clk_2 <= clk2;
    clk_3 <= clk3;
    clk_4 <= clk4;
end behav_intClkGen;