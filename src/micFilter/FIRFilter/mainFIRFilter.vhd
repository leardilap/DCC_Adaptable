-- ======================================================================
--                  Generic FIR Filter
--
--  Creates 16-bit wide, sequential FIR Filter (32bit coefficients) of 
--  generic length. Coefficients are read in from a text file as string 
--	lines (32 bit binary values). Start input starts a calculation cycle. 
--	Each cycle takes about fLength +1 clock cycles.
--  Synchronous high on start starts cycle. 
-- ======================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIRFilter is
    Generic ( 
				fLength : INTEGER := 512;                               -- Filter length
				aWidth	: INTEGER := 15);                                -- Address width
    Port ( 	clk 	: in STD_LOGIC;                                     -- Clock
			rst 	: in STD_LOGIC;                                     -- Reset
			start 	: in STD_LOGIC;                                     -- Start input (sampling clock)
			x 		: in STD_LOGIC_VECTOR (15 downto 0);                -- Input sample 
			y 		: out STD_LOGIC_VECTOR (15 downto 0) := x"0000";
			fir_memory_s2_address		: out std_logic_vector(14 downto 0); 	 			
			fir_memory_s2_clken			: out std_logic;
			fir_memory_s2_readdata		: in std_logic_vector(31 downto 0); 	
			fir_memory_clk2_clk			: out std_logic
	);   -- Output sample
end FIRFilter;

architecture behav_mainFIRFilter of FIRFilter is
	--- Signals --------------------------------------------------------------
    signal shiftRegRAddr, shiftRegWAddr : unsigned(aWidth-1 downto 0) := (others => '0');
    signal b_tmp : signed(31 downto 0) := (others => '0');
    signal shiftRegIn, shiftRegOut, acc_tmp, x_tmp, tmp, x_in_tmp : signed(15 downto 0) := (others => '0');
    signal count : INTEGER := 0;																				-- counter variable
    signal accRst, runMAC, srrCE, srwCE, start_flag, done, clk_n : STD_LOGIC := '0';
    --- Components -----------------------------------------------------------
    -- Taps RAM block --
    component rwRAM_Lx16    
	generic(	mem_type   : string := "block"; 
				dwidth     : integer := 16; 
				awidth     : integer := 8; 
				mem_size   : integer := 256); 
    port (Clk       : in std_logic;
          rAddr     : in unsigned(aWidth-1 downto 0);
          rCE       : in std_logic;
          q         : out signed(15 downto 0) := (others=>'0');
          wAddr     : in unsigned(aWidth-1 downto 0); 
          wCE       : in std_logic; 
          d         : in signed(15 downto 0));
    end component;
    -- Multiply accumulator --
    component MAC       
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           run      : in STD_LOGIC;
           b        : in SIGNED (31 downto 0);
           x        : in SIGNED (15 downto 0);
           acc_out  : out SIGNED (15 downto 0));
    end component;
	--------------------------------------------------------
begin
	clk_n <= not clk;
	fir_memory_clk2_clk <= not clk;
	
    shiftReg : component rwRAM_Lx16
	generic map(	mem_type    => "block",
					awidth     => aWidth,
					mem_size   => fLength)
    port map (	Clk 	=> clk_n,
				rAddr 	=> shiftRegRAddr,
				rCE 	=> srrCE,
				q 		=> shiftRegOut,
				wAddr 	=> shiftRegWAddr,
				wCE 	=> srwCE,
				d 		=> shiftRegIn);
    
    MAC1 : component MAC
    port map ( clk 		=> clk_n,
               rst		=> accRst,
               run 		=> runMAC,
               b 		=> b_tmp,
               x 		=> x_tmp,
               acc_out 	=> acc_tmp);
	--------------------------------------------
     process (clk)
     begin
        if (clk'event and clk = '1') then
            if (rst = '1') then
                count <= 0;
                accRst <= '1';
				start_flag <= '0';
			elsif(start = '1' and start_flag = '0') then
				start_flag <= '1';
				count <= (fLength+1);
				accRst <= '0';
				runMAC <= '0';
                x_in_tmp <= signed(x);
			elsif(start_flag = '1' and done = '0') then		
				if(count > 0) then
					count <= count - 1;
				else
					tmp <= acc_tmp;
					done <= '1';
				end if;  
				
				if (count <= (fLength+1) and count >= 3) then
					srrCE <= '1';
					shiftRegRAddr <= to_unsigned(count-3,aWidth);
					fir_memory_s2_clken <= '1';
					fir_memory_s2_address <= std_logic_vector(to_unsigned(count-2,aWidth));
				elsif (count = 2) then
					srrCE <= '0';
					fir_memory_s2_clken <= '1';
					fir_memory_s2_address <= std_logic_vector(to_unsigned(count-2,aWidth));
				else
					srrCE <= '0';
					fir_memory_s2_clken <= '0';
				end if; 
				
				if (count <= fLength and count > 1) then
					srwCE <= '1';
					runMAC <= '1';
					shiftRegWAddr <= to_unsigned(count-1,aWidth);
					shiftRegIn <= shiftRegOut;
					x_tmp <= shiftRegOut;
					b_tmp <= signed(fir_memory_s2_readdata);
				elsif (count = 1) then
					srwCE <= '1';
					runMAC <= '1';
					shiftRegWAddr <= to_unsigned(0,aWidth);
					shiftRegIn <= x_in_tmp;
					x_tmp <= x_in_tmp;
					b_tmp <= signed(fir_memory_s2_readdata);
				else    
					runMAC <= '0';
					srwCE <= '0';
				end if;      				
			elsif(start_flag = '1' and start = '0' and done = '1') then
				accRst <= '1';
				start_flag <= '0';
				done <= '0';
			end if;	
		end if;
     end process;
     
     y <= std_logic_vector(tmp);
end behav_mainFIRFilter;