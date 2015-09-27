-- ==========================================================
--                  Multiplier
--
--  Multiplies a signed 16 bit and a signed 32 bit input. 
--  Output has 32 bit.
-- ==========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity Multiplier16x32_32 is
   port(	DIN1	: in signed (15 downto 0);	        			-- Data input (16 bit, 4.12)
			DIN2	: in signed (31 downto 0);          			-- Coefficient input (32 bit, 4.28)
			DOUT	: out signed (31 downto 0):=(others=>'0'));		-- Data output (32 bit, 4.28)
end entity Multiplier16x32_32;
 
architecture behav_Multiplier16x32_32 of Multiplier16x32_32 is
    signal tmp: signed (47 downto 0);
begin
   tmp <= DIN1 * DIN2;
   DOUT <= resize(tmp, 44)(43 downto 12);
end architecture behav_Multiplier16x32_32;














