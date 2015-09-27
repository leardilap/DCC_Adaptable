-- ======================================================================
--                  RAM block
--
--  Creates read-only RAM block with 'mem_size' elements of size 'dwidth'. 
--	Read access is controlled by CLK and CE to enable/disable access. Has 
--	a memory access guard to make sure the memory address is inside 
--	the RAM block. 
--  RAM is initialized with values read from a data file.
-- ======================================================================

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use work.txt_util.all;
use IEEE.NUMERIC_STD.ALL;

entity rRAM_Lx32 is 
    generic(	mem_type   : string := "block"; 
				dwidth     : integer := 32; 
				awidth     : integer := 8; 
				mem_size   : integer := 256;
				c_file : string := "X:\c\cpfeiffer\Projects\Microphonics\Vivado\SIM_FILES\coef256.dat"); 
    port (	Addr	: in unsigned(awidth-1 downto 0); 	-- Adress
			CE		: in std_logic; 					-- Clock enable
			Clk		: in std_logic;						-- Clock input
			q 		: out signed(dwidth-1 downto 0):=(others=>'0'));	-- Data output
end entity; 

architecture behav_rRAMLx32 of rRAM_Lx32 is 

	signal Addr_tmp : unsigned(awidth-1 downto 0); 
	
	-- Init BRAM --
	type mem_array is array (0 to mem_size-1) of signed (dwidth-1 downto 0); 
	impure function init_mem(coef_file : in string) return mem_array is
        file tapsf : text open read_mode is coef_file;
        variable l : line;
        variable s: string(1 to 32);
        variable temp_mem : mem_array;
    begin
        for i in mem_array'range loop
            readline(tapsf,l);
            read(l, s);
            temp_mem(i) := signed(to_std_logic_vector(s));
        end loop;
        return temp_mem;
    end function;
	signal ram : mem_array := init_mem(c_file);
	attribute ram_style : string;
	attribute ram_style of ram : signal is mem_type;

begin 
	memory_access_guard: process (Addr) 
	begin
		Addr_tmp <= Addr;
	--synthesis translate_off
		if (to_integer(Addr) > mem_size-1) then
			Addr_tmp <= (others => '0');
		else 
			Addr_tmp <= Addr;
		end if;
	--synthesis translate_on
	end process;

	read_memory: process (Clk)  
	begin 
		if (Clk'event and Clk = '1') then
			if (CE = '1') then 
				q <= ram(to_integer(Addr_tmp)); 
			end if;
		end if;
	end process;
end behav_rRAMLx32;