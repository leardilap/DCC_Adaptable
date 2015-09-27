-- ================================================================
--                  FIFO
--
--  Generic FIFO that uses a RAM memory block to store data. 
--	The FIFO is built as a ring buffer with generic length and 
--	data width.
-- ================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIFO is
generic ( 	data_width     : integer := 16;                                          -- Data width
			address_width  : integer := 19;                                          -- Address width
			buffer_length  : integer := 339761);                                     -- Buffer length
port (	clk 	: IN STD_LOGIC;							    		                 -- Read clock
		rst 	: IN STD_LOGIC;										                 -- Reset pointers
		d0 		: IN STD_LOGIC_VECTOR (data_width-1 downto 0);		                 -- Data input
		q0 		: OUT STD_LOGIC_VECTOR (data_width-1 downto 0) := (others => '0'));	 -- Data output
end entity;

architecture behav_gFIFO of FIFO is 
    --- Constants ------------------------------------------------------------------------
    constant constAddr_0 : unsigned (address_width-1 downto 0) := to_unsigned(0,address_width);
    constant constAddr_1 : unsigned (address_width-1 downto 0) := to_unsigned(1,address_width);
    constant b_length : unsigned (address_width-1 downto 0) := to_unsigned(buffer_length-1,address_width);
	--- Signals --------------------------------------------------------------------------
	signal pointer : unsigned (address_width-1 downto 0) := constAddr_0;
	--- Components -----------------------------------------------------------------------
	component RAMgen
	generic(	dwidth     : integer := data_width; 
				awidth     : integer := address_width; 
				mem_size   : integer := buffer_length); 
    port (	rwAddr   : in std_logic_vector(address_width-1 downto 0); 	
			rCE      : in std_logic; 							
			rwClk    : in std_logic;							
			q        : out std_logic_vector(data_width-1 downto 0);	
			wCE      : in std_logic; 													
			d        : in std_logic_vector(data_width-1 downto 0));
    end component;
	
begin
    memory : component RAMgen
    port map (	rwAddr 	=> std_logic_vector(pointer), 	
				rCE 	=> '1',						
				rwClk 	=> clk,					
				q 		=> q0,
				wCE 	=> '1',											
				d 		=> d0);
		
	process(clk)
    begin
        if (clk'event and clk = '1') then
            if (rst = '1') then
			     pointer <= constAddr_0;
		    elsif (pointer = b_length) then
		         pointer <= constAddr_0;			-- pointer = 0
		    else
		         pointer <= pointer+constAddr_1;	-- pointer++
			end if;
        end if;
    end process;

end behav_gFIFO;