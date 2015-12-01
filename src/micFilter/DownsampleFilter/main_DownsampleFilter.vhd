-- ==============================================================
--                  Decimation FIR Filter, N_default=5000
--
--  Output y is sum of n samples of input x multplied by factor.
--  With default values y is average of 5000 samples of x.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DownsampleFilter is
generic (
			DownSampleRate : integer := 2500
			);
port (	clk 	: IN STD_LOGIC;                                      -- clock
		rst 	: IN STD_LOGIC;                                      -- reset
		x 		: IN STD_LOGIC_VECTOR (15 downto 0);                 -- input sample
		y 		: OUT STD_LOGIC_VECTOR (15 downto 0) := x"0000";		 -- output sample
		
		DownSampleMult: IN STD_LOGIC_VECTOR (31 DOWNTO 0)		-- 53687 multiplication factor (4.28)
		);   
end;

architecture behav_DownsampleFilter of DownsampleFilter is 
    --- Parameters -----------------------------------------
	signal factor : signed (31 downto 0);     -- multiplication factor 
	--- Signals -- ---------------------------------------    
	signal sample, reg : signed (15 downto 0):= x"0000";                
	signal acc, mul : signed (31 downto 0):= x"00000000";
	signal i : INTEGER := 0;												-- counter variable
    --- Components ---------------------------------------
    component Multiplier16x32_32
	port (	DIN1 	: IN signed (15 downto 0);
			DIN2	: IN signed (31 downto 0);
			DOUT 	: OUT signed (31 downto 0) := x"00000000");
    end component;

begin
	factor <= signed(DownSampleMult);
    multiply : component Multiplier16x32_32
    port map (	DIN1	=> sample,
				DIN2 	=> factor,
				DOUT 	=> mul);
	
    process(clk)
    begin
        if (clk'event and clk ='1') then	-- rising edge
            if (rst = '1') then
                i <= 0;
            else
				if (i = (DownSampleRate-1)) then
					i <= 0;               
				else
					i <= i+1;
				end if;
			end if;
			sample <= signed(x);
        end if;
    end process;
	
	process(clk)
    begin
        if (clk'event and clk ='0') then	-- falling edge
			if (i = 0) then
				acc <= mul;
				reg <= acc(31 downto 16);
			else
				acc <= acc + mul;
			end if;
        end if;
    end process;

	y <= std_logic_vector(reg);

end behav_DownsampleFilter;
