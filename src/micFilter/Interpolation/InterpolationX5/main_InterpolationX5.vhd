-- ==============================================================
--                  Interpolation FIR Filter
--
--	Interpolates input signal x by factor 5. Clock clk equals 
--  sampling frequency of the output signal. Input signal is 
--  sampled every 5th clk cycle. 
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use work.txt_util.all;

entity InterpolationX5 is
port (	clk	: in STD_LOGIC;
				clk25M	: in STD_LOGIC;
			rst : in STD_LOGIC;																			 -- Reset
			cntl : in STD_LOGIC;                                                       
		x 		: IN STD_LOGIC_VECTOR (15 downto 0);                                    -- Input sample
		y 		: OUT STD_LOGIC_VECTOR (15 downto 0) := x"0000";								 -- Output sample
		s2_address 		: out std_logic_vector (5 downto 0);	
		s2_clken			: out std_logic;		
		s2_readdata		: in std_logic_vector(31 downto 0);
		clk2_clk			: out std_logic);                      
end;


architecture behav_InterpolationX5 of InterpolationX5 is 
    -- Types --
	type array40_32_t is array (0 to 39) of SIGNED(31 downto 0);
	type array8_16_t is array (0 to 7) of SIGNED(15 downto 0);
	type array8_32_t is array (0 to 7) of SIGNED(31 downto 0);
	-- Constants --

   signal coef : array40_32_t := (others => (others => '0'));
	-- Signals --
	signal shiftReg : array8_16_t := (others=>(others=>'0'));
	signal b : array8_32_t := (others=>(others=>'0'));
	signal add1,add2,add3,add4,add12,add34,add1234 : SIGNED (31 downto 0):= (others=>'0');
	signal tmp : array8_32_t := (others=>(others=>'0'));
   signal reg : STD_LOGIC_VECTOR (15 downto 0):= (others=>'0');
	signal count : integer := 0;
	
	type state_type is (idle, loading, last);
	signal state : state_type;
	
	signal coef_cnt : integer range 0 to 39 := 0;
	signal cntl_buff : std_logic;
	-- Components --
	component iMultiplier
    port (	DIN 	: IN SIGNED (15 downto 0);
			COEFF 	: IN SIGNED (31 downto 0);
			DOUT 	: OUT SIGNED (31 downto 0) );
    end component;

	component iAdder is
    port ( DIN1 : in SIGNED (31 downto 0);
           DIN2 : in SIGNED (31 downto 0);
           DOUT : out SIGNED (31 downto 0));
	end component;
	----------------------------------------
	
begin

	---------------------------------------------------------------
	-- Update COEFF
	clk2_clk <= clk25M;
	s2_address <= std_logic_vector(to_unsigned(coef_cnt,6));
	process (clk25M)
	begin 
		if rising_edge(clk25M) then
			cntl_buff <= cntl;
			case state is 
			
				when idle => 
					
					if (cntl = '1' and cntl_buff = '0') then  -- rising_edge of control signal indicating to load coefF
						state <= loading;
						coef_cnt <= 0;
						s2_clken <= '1';
					else 
						state <= idle;
						s2_clken <= '0';
					end if; 
				
				when loading => 
					s2_clken <= '1';
					coef_cnt <= coef_cnt + 1;
					coef(coef_cnt-1) <= signed(s2_readdata);
					if (coef_cnt = 39) then
						state <= last;
						s2_clken <= '0';
					else	
						state <= loading;
					end if;
				when last => 
					coef(39) <= signed(s2_readdata);
					state <= idle;
					s2_clken <= '0';
				when others => 
					state <= idle;
					s2_clken <= '0';
			end case;
				
				
		end if;
		
	end process;




	Multiplier_0 : component iMultiplier
    port map (	DIN 	=> shiftReg(0),
				COEFF 	=> b(0),
				DOUT 	=> tmp(0));

    Multiplier_1 : component iMultiplier
    port map (	DIN 	=> shiftReg(1),
				COEFF 	=> b(1),
				DOUT 	=> tmp(1));
				
	Multiplier_2 : component iMultiplier
    port map (	DIN 	=> shiftReg(2),
				COEFF 	=> b(2),
				DOUT	=> tmp(2));	
			
	Multiplier_3 : component iMultiplier
    port map (	DIN 	=> shiftReg(3),
				COEFF 	=> b(3),
				DOUT 	=> tmp(3));
				
	Multiplier_4 : component iMultiplier
    port map (	DIN 	=> shiftReg(4),
				COEFF 	=> b(4),
				DOUT 	=> tmp(4));
				
	Multiplier_5 : component iMultiplier
    port map (	DIN 	=> shiftReg(5),
				COEFF 	=> b(5),
				DOUT 	=> tmp(5));
				
	Multiplier_6 : component iMultiplier
    port map (	DIN 	=> shiftReg(6),
				COEFF 	=> b(6),
				DOUT 	=> tmp(6));
	
	Multiplier_7 : component iMultiplier
    port map (  DIN     => shiftReg(7),
                COEFF     => b(7),
                DOUT     => tmp(7));
	------------------------------			
	Adder1 : component iAdder
    port map( 	DIN1 	=> tmp(0),
				DIN2 	=> tmp(1),
				DOUT 	=> add1);
	
	Adder2 : component iAdder
    port map( 	DIN1 	=> tmp(2),
				DIN2 	=> tmp(3),
				DOUT 	=> add2);
	
	Adder3 : component iAdder
    port map( 	DIN1 	=> tmp(4),
				DIN2 	=> tmp(5),
				DOUT 	=> add3);
	
	Adder4 : component iAdder
    port map( 	DIN1 	=> tmp(6),
				DIN2 	=> tmp(7),
				DOUT 	=> add4);
				
	Adder12 : component iAdder
    port map( 	DIN1 	=> add1,
				DIN2 	=> add2,
				DOUT 	=> add12);
				
	Adder34 : component iAdder
    port map( 	DIN1 	=> add3,
				DIN2 	=> add4,
				DOUT 	=> add34);
				
	Adder1234 : component iAdder
    port map( 	DIN1 	=> add12,
				DIN2 	=> add34,
				DOUT 	=> add1234);
	----------------------------------	
    process(clk)
    begin
        if (clk'event and clk =  '1') then
            if (rst = '1') then
				count <= 0;
				reg <= x"0000";
            else
				if (count>=4) then
					count <= 0;
				else
					count <= count+1;
				end if;
				if (count = 0) then	--shift
					shiftReg(7) <= shiftReg(6);
					shiftReg(6) <= shiftReg(5);
					shiftReg(5) <= shiftReg(4);
					shiftReg(4) <= shiftReg(3);
					shiftReg(3) <= shiftReg(2);
					shiftReg(2) <= shiftReg(1);
					shiftReg(1) <= shiftReg(0);
					shiftReg(0) <= signed(x);
				end if;
				
				b(0) <= coef(count);
				b(1) <= coef(5+count);
				b(2) <= coef(10+count);
				b(3) <= coef(15+count);
				b(4) <= coef(20+count);
				b(5) <= coef(25+count);
				b(6) <= coef(30+count);
				b(7) <= coef(35+count);
				
				reg <= std_logic_vector(add1234(31 downto 16));
			end if;
        end if;
    end process;
	
	y <= reg;
	
	
end behav_InterpolationX5;
