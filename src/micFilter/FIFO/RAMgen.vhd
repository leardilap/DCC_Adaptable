-- ======================================================================
--                  RAM block
--
--  Creates RAM block with 'mem_size' elements of size 'dwidth'. Read
--  and write access is controlled by the input clock ('rwClk') and 
--	clock enables ('rCE','wCE'). Write uses input 'd' and read output 
--	'q'. Uses memory access guard to make sure the memory address is 
--	inside the RAM block.
-- ======================================================================

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity RAMgen is 
    generic(	mem_type   : string := "block"; 				-- Memory type
				dwidth     : integer := 16; 					-- Data width
				awidth     : integer := 20; 					-- Address width
				mem_size   : integer := 500000); 				-- Memory size
    port (	rwAddr	: in std_logic_vector(awidth-1 downto 0); 	-- Read/write adress
			rCE		: in std_logic; 							-- Read clock enable
			rwClk	: in std_logic;							    -- Clock input
			q		: out std_logic_vector(dwidth-1 downto 0);	-- Data output
			wCE		: in std_logic; 							-- Write clock enable
			d		: in std_logic_vector(dwidth-1 downto 0));  -- Data input
end entity; 

architecture behav_RAMgen of RAMgen is 
	signal rwAddr_tmp : std_logic_vector(awidth-1 downto 0); 
	type mem_array is array (0 to mem_size-1) of std_logic_vector (dwidth-1 downto 0); 
	signal ram : mem_array := (others=>(others=>'0'));
	attribute ram_style : string;
	attribute ram_style of ram : signal is mem_type;
begin 
	memory_access_guard: process (rwAddr) 
	begin
		rwAddr_tmp <= rwAddr;
	--synthesis translate_off
		if (CONV_INTEGER(rwAddr) > mem_size-1) then
			rwAddr_tmp <= (others => '0');
		else 
			rwAddr_tmp <= rwAddr;
		end if;
	--synthesis translate_on
	end process;

	rw_memory: process (rwClk)  
	begin 
		if (rwClk'event and rwClk = '1') then
			if (rCE = '1') then 
				q <= ram(CONV_INTEGER(rwAddr_tmp)); 
			end if;
			if (wCE = '1') then 
				ram(CONV_INTEGER(rwAddr_tmp)) <= d; 
			end if;
		end if;
	end process;
end behav_RAMgen;