-- ======================================================================
--                  RAM block
--
--  Creates RAM block with 'mem_size' elements of size 'dwidth'. Read
--  and write access is controlled by individual clocks ('rClk','wClk'). 
--	Both use a clock enable ('rCE','wCE') to enable/disable access. 
--	Write uses input 'd' and read output 'q'. Both operations have a 
--	memory access guard to make sure the memory address is inside 
--	the RAM block.
-- ======================================================================

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity DualClkRam is 
    generic(	mem_type   : string := "block";                 -- Memory type
				dwidth     : integer := 32;                     -- Data width
				awidth     : integer := 10;                     -- Address width
				mem_size   : integer := 1000);                  -- Memory size
    port (	rAddr	: in std_logic_vector(awidth-1 downto 0); 	-- Read adress
			rCE		: in std_logic; 							-- Read clock enable
			rClk	: in std_logic;								-- Clock input
			q		: out std_logic_vector(dwidth-1 downto 0) := (others=>'0');	-- Data output
			wAddr	: in std_logic_vector(awidth-1 downto 0); 	-- Write adress
			wCE		: in std_logic; 							-- Write clock enable
			wClk	: in std_logic; 							-- Clock input
			d		: in std_logic_vector(dwidth-1 downto 0)); 	-- Data input
end entity; 

architecture behav_DualClkRam of DualClkRam is 
	signal rAddr_tmp, wAddr_tmp : std_logic_vector(awidth-1 downto 0); 	
	type mem_array is array (0 to mem_size-1) of std_logic_vector (dwidth-1 downto 0); 
	shared variable ram : mem_array := (others=>(others=>'0'));
	attribute ram_style : string;
	attribute ram_style of ram : variable is mem_type;
begin 
	memory_access_guard_read: process (rAddr) 
	begin
		if (CONV_INTEGER(rAddr) > mem_size-1) then
			rAddr_tmp <= (others => '0');
		else 
			rAddr_tmp <= rAddr;
		end if;
	end process;
	
	memory_access_guard_write: process (wAddr) 
	begin
		if (CONV_INTEGER(wAddr) > mem_size-1) then
			wAddr_tmp <= (others => '0');
		else 
			wAddr_tmp <= wAddr;
		end if;
	end process;

	read_memory: process (rClk)  
	begin 
		if (rClk'event and rClk = '1') then
			if (rCE = '1') then 
				q <= ram(CONV_INTEGER(rAddr_tmp)); 
			end if;
		end if;
	end process;

	write_memory: process (wClk)  
	begin 
		if (wClk'event and wClk = '1') then
			if (wCE = '1') then 
				ram(CONV_INTEGER(wAddr_tmp)) := d; 
			end if;
		end if;
	end process;
end behav_DualClkRam;