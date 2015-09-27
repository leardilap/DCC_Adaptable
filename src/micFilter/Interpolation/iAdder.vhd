-- ==========================================================
--                  Adder
--
--  Adds two input samples DIN. 
-- ==========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity iAdder is
    Port ( DIN1 : in SIGNED (31 downto 0);
           DIN2 : in SIGNED (31 downto 0);
           DOUT : out SIGNED (31 downto 0) := (others => '0'));
end iAdder;

architecture Behavioral of iAdder is
begin
    DOUT <= DIN1 + DIN2;
end Behavioral;
