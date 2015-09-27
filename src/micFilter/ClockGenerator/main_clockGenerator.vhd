-------------------------------------------------------------------
--						Clock Generator							 --
--															     --
--	Generates clock that is defined by a low and a high period   --
--	as multiples of input clock (clk_in) periods.                --
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clockGenerator is
	Generic (	lPeriod	: INTEGER := 4;		           -- Low period (in multiple of clk_in periods)
				hPeriod	: INTEGER := 4);		       -- High period (in multiple of clk_in periods)
    Port ( 	clk_in			: in STD_LOGIC;            -- Input clock
			rst 			: in STD_LOGIC;            -- Reset
			clk_out 		: out STD_LOGIC := '0');   -- Output clock
end clockGenerator;

architecture behav_clockGenerator of clockGenerator is
	--- Constants -------------------------
	constant clkl : INTEGER := lPeriod-1;
	constant clkp : INTEGER := clkl+hPeriod;
	--- Signals ---------------------------
    signal clk_tmp : STD_LOGIC := '0';
    signal count : INTEGER := 0;        				-- counter variable
begin
    process(clk_in)
    begin
    if (clk_in'event and clk_in='1') then
        if (rst = '1') then
            count <= 0;
        else
			-- Clock --
			if (count <= clkl) then
				clk_tmp <= '0';
			else
				clk_tmp <= '1';
			end if;
			if (count >= clkp) then
				count <= 0;
			else
				count <= count+1;
			end if;
        end if;
    end if;
    end process;   
	
    clk_out <= clk_tmp;
end behav_clockGenerator;
