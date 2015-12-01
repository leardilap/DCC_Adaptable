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
Generic (	intClkGen_lP1	  : INTEGER := 3;		    -- Low period (in multiple of clk_in periods)
				intClkGen_hP1    : INTEGER := 5;         -- High period (in multiple of clk_in periods)
				intClkGen_lP2    : INTEGER := 13;
				intClkGen_hP2    : INTEGER := 25;
				intClkGen_lP3    : INTEGER := 63;
				intClkGen_hP3    : INTEGER := 125;
				intClkGen_lP4    : INTEGER := 313;
				intClkGen_hP4    : INTEGER := 625);			
Port (  clk_in            : in STD_LOGIC;           -- Input clock
        rst               : in STD_LOGIC;           -- Reset
        clk_1             : out STD_LOGIC := '0';   -- Output clock 1
        clk_2             : out STD_LOGIC := '0';   -- Output clock 2
        clk_3             : out STD_LOGIC := '0';   -- Output clock 3
        clk_4             : out STD_LOGIC := '0'		
	);  -- Output clock 4
end InterpClkGen;

architecture behav_intClkGen of InterpClkGen is

    --- Signals -----------------------------------------
    signal clk1, clk2, clk3, clk4 : STD_LOGIC := '0';
    signal count1 : INTEGER RANGE 0 TO 4095 := 0; 		-- counter variables
    signal count2 : INTEGER RANGE 0 TO 4095 := 0; 
    signal count3 : INTEGER RANGE 0 TO 4095 := 0; 
    signal count4 : INTEGER RANGE 0 TO 4095 := 0; 
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
                if (count1 < intClkGen_lP1) then
                    clk1 <= '0';
                else
                    clk1 <= '1';
                end if;
                if (count1 >= intClkGen_hP1) then
                    count1 <= 0;
                else
                    count1 <= count1+1;
                end if;       
                -- Clock 2 --
                if (count2 < intClkGen_lP2) then
                    clk2 <= '0';
                else
                    clk2 <= '1';
                end if;
                if (count2 >= intClkGen_hP2) then
                    count2 <= 0;
                else
                    count2 <= count2+1;
                end if;       
                -- Clock 3 --
                if (count3 < intClkGen_lP3) then
                    clk3 <= '0';
                else
                    clk3 <= '1';
                end if;
                if (count3 >= intClkGen_hP3) then
                    count3 <= 0;
                else
                    count3 <= count3+1;
                end if;
                -- Clock 4 --
                if (count4 < intClkGen_lP4) then
                    clk4 <= '0';
                else
                    clk4 <= '1';
                end if;
                if (count4 >= intClkGen_hP4) then
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