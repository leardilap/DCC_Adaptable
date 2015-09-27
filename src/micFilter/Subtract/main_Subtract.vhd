---------------------------------------------------------------
--                  Subtracter                               --
--                                                           --
--  Subtracts a signed 16 bit input ('DIN1') from another    --
--	one ('DIN2') that is multiplied by a generic factor.     --
---------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity Subtract is
   generic( factor      : INTEGER RANGE 0 TO 65565 := 4096);          -- Multiplication factor for negative input := 4111 DIN2 Factor (4.12)
   port(	clk 		: in STD_LOGIC;                                     -- Clock
			DIN1, DIN2	: in STD_LOGIC_VECTOR(15 downto 0);		          -- Data inputs (16 bit)
			DOUT		: out STD_LOGIC_VECTOR (15 downto 0) := x"0000");	 -- Data output (16 bit)
end entity Subtract;
 
architecture behav_Subtract of Subtract is
    --- Constants -------------------------------
    constant m : signed := to_signed(factor,16);
    --- Signals ---------------------------------
    signal tmp : signed ( 15 downto 0) := (others=>'0');
    signal mul : signed ( 31 downto 0) := (others=>'0');
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            tmp <= signed(DIN1) - mul(27 downto 12);
        end if;
    end process;
	
    DOUT <= STD_LOGIC_VECTOR(tmp);
    mul <= m * signed(DIN2);
end architecture behav_Subtract;