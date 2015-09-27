-- ==========================================================================
--                  MAC
--
--  Multiply-Accumulator with 16-bit(4.12) data and 32-bit(4.28) coefficient
--	input. Executes MAC every clock cycle while run is high. Reset input rst
--	resets sets the accumulated value to zero.
-- ==========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MAC is
    Port ( 	clk		: in STD_LOGIC;                -- Clock
			rst 	: in STD_LOGIC;                -- Reset
			run 	: in STD_LOGIC;                -- Start run
			b 		: in SIGNED (31 downto 0);     -- Multiplication factor
			x 		: in SIGNED (15 downto 0);     -- Input value
			acc_out : out SIGNED (15 downto 0));   -- Accumulator output
end MAC;

architecture behav_MAC of MAC is

        signal mul : SIGNED (47 downto 0) := (others=>'0');
        signal acc, acc_tmp, b_tmp : SIGNED (31 downto 0) := (others=>'0');
        signal x_tmp : SIGNED (15 downto 0) := (others=>'0');
begin
        mul <= b*x;										-- multiply
        acc_tmp <= acc + resize(mul,44)(43 downto 12);	-- accumulate
        
        process (clk)
        begin
            if (clk'event and clk = '1') then
                if (rst = '1') then
                    acc <= (others=>'0');
                elsif (run = '1') then
                    acc <= acc_tmp;
                end if;
            end if;
        end process;

        acc_out <= acc(31 downto 16);
end behav_MAC;
