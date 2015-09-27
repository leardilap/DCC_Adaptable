-- ==========================================================
--                  Multiplier
--
--  Multiplies input sample DIN with coefficient input COEFF. 
-- ==========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity iMultiplier is
   port(	DIN			: in signed(15 downto 0);		-- Data input (16 bit, 4.12)
			COEFF			: in signed (31 downto 0);	-- Coefficient input (32 bit, 4.28)
			DOUT		: out signed (31 downto 0) := x"00000000");	-- Data output (32 bit, 4.28)
end entity iMultiplier;
 
architecture behav_iMultiplier of iMultiplier is
begin
	process(DIN,COEFF)
		variable mul : signed(47 downto 0);
	begin
		mul := DIN*COEFF;
		DOUT <= resize(mul,44)(43 downto 12);
	end process;
end architecture behav_iMultiplier;