-- ======================================================================
--                  RAM block
--
--  Creates RAM block with 'mem_size' elements of size 'dwidth'. Read
--  and write access is controlled by one clock ('Clk'). 
--	Both use a clock enable ('rCE','wCE') to enable/disable access. 
--	Write uses input 'd' and read output 'q'. Both operations have a 
--	memory access guard to make sure the memory address is inside 
--	the RAM block.
-- ======================================================================

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity rwRAM_Lx16 is 
    generic(	mem_type   : string := "block"; 
				dwidth     : integer := 16; 
				awidth     : integer := 8; 
				mem_size   : integer := 256); 
    port (	Clk		: in std_logic;							    -- Clock input
			rAddr	: in unsigned(awidth-1 downto 0); 	        -- Read/write adress
			rCE 	: in std_logic; 							-- Read clock enable
			q		: out signed(dwidth-1 downto 0) := (others=>'0');-- Data output
			wAddr	: in unsigned(awidth-1 downto 0); 	        -- Read/write adress
			wCE		: in std_logic; 							-- Write clock enable
			d		: in signed(dwidth-1 downto 0));	        -- Data input
end entity; 

architecture behav_rwRAMLx16 of rwRAM_Lx16 is 

	signal rAddr_tmp, wAddr_tmp : unsigned(awidth-1 downto 0); 
	
	type mem_array is array (0 to mem_size-1) of signed (dwidth-1 downto 0); 
	signal ram : mem_array := (others=>(others=>'0'));
	attribute ram_style : string;
	attribute ram_style of ram : signal is mem_type;

begin 
	write_memory_access_guard: process (wAddr) 
	begin
		wAddr_tmp <= wAddr;
	--synthesis translate_off
		if (to_integer(wAddr) > mem_size-1) then
			wAddr_tmp <= (others => '0');
		else 
			wAddr_tmp <= wAddr;
		end if;
	--synthesis translate_on
	end process;
	
	read_memory_access_guard: process (rAddr) 
    begin
        rAddr_tmp <= rAddr;
    --synthesis translate_off
        if (to_integer(rAddr) > mem_size-1) then
            rAddr_tmp <= (others => '0');
        else 
            rAddr_tmp <= rAddr;
        end if;
    --synthesis translate_on
    end process;

	read_memory: process (Clk)  
	begin 
		if (Clk'event and Clk = '1') then
			if (rCE = '1') then 
				q <= ram(to_integer(rAddr_tmp)); 
			end if;
			if (wCE = '1') then 
				ram(to_integer(wAddr_tmp)) <= d; 
			end if;
		end if;
	end process;
end behav_rwRAMLx16;