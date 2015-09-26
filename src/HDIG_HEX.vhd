----------------------------------------------------------------------------------
-- Copyright (c) 2014, Luis Ardila
-- E-mail: leardilap@unal.edu.co
--
-- Description:
--
-- Revisions: 
-- Date        	Version    	Author    		Description
-- 12/10/2014    	1.0    		Luis Ardila    File created
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY HDIG_HEX IS
	PORT (
		HDIG			: IN 	STD_LOGIC_VECTOR (3 DOWNTO 0);
		HEX			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
END HDIG_HEX;

ARCHITECTURE HDIG_HEX_ARCH OF HDIG_HEX IS
BEGIN

--0 turns ON and 1 turns OFF

	HEX <= "1000000" WHEN HDIG = x"0" ELSE
			 "1111001" WHEN HDIG = x"1" ELSE
			 "0100100" WHEN HDIG = x"2" ELSE
			 "0110000" WHEN HDIG = x"3" ELSE
			 "0011001" WHEN HDIG = x"4" ELSE
			 "0010010" WHEN HDIG = x"5" ELSE
			 "0000010" WHEN HDIG = x"6" ELSE
			 "1111000" WHEN HDIG = x"7" ELSE
			 "0000000" WHEN HDIG = x"8" ELSE
			 "0010000" WHEN HDIG = x"9" ELSE
			 "0001000" WHEN HDIG = x"A" ELSE
			 "0000011" WHEN HDIG = x"B" ELSE
			 "1000110" WHEN HDIG = x"C" ELSE
			 "0100001" WHEN HDIG = x"D" ELSE
			 "0000110" WHEN HDIG = x"E" ELSE
			 "0001110" WHEN HDIG = x"F" ELSE
			 "1111111";

END HDIG_HEX_ARCH;