-- =======================================================================
--              Microphonics Filter (by Christoph Pfeiffer)
--
--  Configurable microphonic noise cancellation filter.
-- ======================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity micFilter is
	GENERIC (	adFil_length : Integer := 500;		-- Adaptive Filter - Length
				adFil_aWidth : Integer := 9;				-- Adaptive Filter - Address Width
				adFil_pTH 	: Integer := 2048;			-- Adaptive Filter - Positive Threshold (4.12)
				adFil_nTH 	: Integer := -2048;			-- Adaptive Filter - Negative Threshold (4.12)
				adFil_weight : Integer := 26844;			-- Adaptive Filter - Weight mu (4.28)
				FIR_cFile 	: string := "D:\Dropbox\HS-KA\STM3\ProyectB\micFilter\taps256.dat";    -- FIR Filter - Coefficient File Path
				FIR_length 	: INTEGER := 257;           -- FIR Filter - Length
				FIR_aWidth	: INTEGER := 15;				-- FIR Filter - Address Width
				DsFil_div   : INTEGER := 2500;          -- Downsample Filter - Downsample Rate
				DsFil_mul  	: Integer := 107374;        -- Downsample Filter - Factor (4.28)
				clkGen_lP	: INTEGER := 1250;		    -- Clock Generator - Low Period
				clkGeN_hP	: INTEGER := 1250;		    -- Clock Generator - High Period
				FIFO_aWidth  : integer := 19;           -- FIFO Buffer - Address Width
				FIFO_length  : integer := 340151;       -- FIFO Buffer - Length
				IntX4_cFile : string := "D:\Dropbox\HS-KA\STM3\ProyectB\micFilter\i4Taps.dat"; -- InterpolationX4 - Coefficient File Path
				IntX5_cFile1 : string := "D:\Dropbox\HS-KA\STM3\ProyectB\micFilter\i5Taps.dat"; -- InterpolationX5 - Coefficient File Path
				IntX5_cFile2 : string := "D:\Dropbox\HS-KA\STM3\ProyectB\micFilter\i5Taps.dat";--2.dat"; -- InterpolationX5 - Coefficient File Path
				IntX5_cFile3 : string := "D:\Dropbox\HS-KA\STM3\ProyectB\micFilter\i5Taps.dat";--3.dat"; -- InterpolationX5 - Coefficient File Path
				IntX5_cFile4 : string := "D:\Dropbox\HS-KA\STM3\ProyectB\micFilter\i5Taps.dat";--4.dat"; -- InterpolationX5 - Coefficient File Path
				intClkGen_lP1	: INTEGER := 3;		    -- Interp Clock Generator - Clk1 Low Period
            intClkGen_hP1	: INTEGER := 2;		    -- Interp Clock Generator - Clk1 High Period
				intClkGen_lP2	: INTEGER := 13;			-- Interp Clock Generator - Clk2 Low Period
            intClkGen_hP2	: INTEGER := 12;			-- Interp Clock Generator - Clk2 High Period
				intClkGen_lP3	: INTEGER := 63;			-- Interp Clock Generator - Clk3 Low Period
            intClkGen_hP3	: INTEGER := 62;			-- Interp Clock Generator - Clk3 High Period
				intClkGen_lP4	: INTEGER := 313;			-- Interp Clock Generator - Clk4 Low Period
            intClkGen_hP4	: INTEGER := 312;			-- Interp Clock Generator - Clk4 High Period
				Sub_factor      : INTEGER RANGE 0 TO 65565 := 4111 -- Subtract - DIN2 Factor (4.12)
				);
	PORT (	adj 		: in STD_LOGIC;											-- Coefficient update halt input bit (low = stop update)
			clk_in 		: in STD_LOGIC;											-- Clock input (nom. 25 MHz)
			cntl			: in STD_logic_vector (31 downto 0);
			gamma 		: in STD_LOGIC_VECTOR ( 15 downto 0 );					-- Detector signal input s(k)
			mic 		: in STD_LOGIC_VECTOR ( 15 downto 0 );					-- Mechanical sensor signal input v(q)
			rst 		: in STD_LOGIC;											-- Synchronous reset input
			gamma_corr 	: out STD_LOGIC_VECTOR ( 15 downto 0 ) := x"0000";		-- Filter output y(k)
			clk_outp 	: out STD_LOGIC := '0';
			fir_memory_s2_address		: out std_logic_vector(14 downto 0); 	 			
			fir_memory_s2_clken			: out std_logic;
			fir_memory_s2_readdata		: in std_logic_vector(31 downto 0); 	
			fir_memory_clk2_clk			: out std_logic;
			interpo_4_0_s2_address 		: out std_logic_vector (4 downto 0);	
			interpo_4_0_s2_clken			: out std_logic;		
			interpo_4_0_s2_readdata		: in std_logic_vector(31 downto 0);
			interpo_4_0_clk2_clk			: out std_logic;
			interpo_5_0_s2_address 		: out std_logic_vector (5 downto 0);	
			interpo_5_0_s2_clken			: out std_logic;		
			interpo_5_0_s2_readdata		: in std_logic_vector(31 downto 0);
			interpo_5_0_clk2_clk			: out std_logic;
			interpo_5_1_s2_address 		: out std_logic_vector (5 downto 0);	
			interpo_5_1_s2_clken			: out std_logic;		
			interpo_5_1_s2_readdata		: in std_logic_vector(31 downto 0);
			interpo_5_1_clk2_clk			: out std_logic;
			interpo_5_2_s2_address 		: out std_logic_vector (5 downto 0);	
			interpo_5_2_s2_clken			: out std_logic;		
			interpo_5_2_s2_readdata		: in std_logic_vector(31 downto 0);
			interpo_5_2_clk2_clk			: out std_logic;
			interpo_5_3_s2_address 		: out std_logic_vector (5 downto 0);	
			interpo_5_3_s2_clken			: out std_logic;		
			interpo_5_3_s2_readdata		: in std_logic_vector(31 downto 0);
			interpo_5_3_clk2_clk			: out std_logic;
			adapt_fir_mem_s2_address 	: out std_logic_vector(8 downto 0);
			adapt_fir_mem_s2_write		: out std_logic;
			adapt_fir_mem_s2_writedata	: out std_logic_vector(31 downto 0);
			adapt_fir_mem_clk2_clk		: out std_logic			
			
	);								
  end micFilter;

architecture micFilter_behav of micFilter is
	--- Signals --------------------------------------------------------
	signal reset, adjust : std_logic := '0';
	signal clk_25M, clk_10k, clk_i1, clk_i2, clk_i3, clk_i4 : std_logic := '0';
	signal s_in, s_10k, s_HP, s_buf, v_in, pHat, pHat_i1, pHat_i2, pHat_i3, pHat_i4, pHat_25M, y_out : std_logic_vector(15 downto 0) := x"0000";
	
	--- Components -----------------------------------------------------
	-- Adaptive Filter --
	component AdaptiveFilter is
	generic ( 	weight 	: INTEGER;				     
				pTh		: INTEGER; 					        
				nTh		: INTEGER; 				        
				aWidth	: INTEGER;						        
				fLength	: INTEGER);					        	        
	port (	clk 	: in STD_LOGIC;
			rst 	: in STD_LOGIC;
			start 	: in STD_LOGIC;
			v 		: in STD_LOGIC_VECTOR ( 15 downto 0 );
			s 		: in STD_LOGIC_VECTOR ( 15 downto 0 );
			adj 	: in STD_LOGIC;
			p_hat 	: out STD_LOGIC_VECTOR ( 15 downto 0 );
			adapt_fir_mem_s2_address 	: out std_logic_vector(8 downto 0);
			adapt_fir_mem_s2_write		: out std_logic;
			adapt_fir_mem_s2_writedata	: out std_logic_vector(31 downto 0);
			adapt_fir_mem_clk2_clk		: out std_logic
	);
	end component;
	
	-- FIR Filter --
	component FIRFilter is
	generic ( 
				fLength : INTEGER;                            
				aWidth	: INTEGER);                             
	port (	clk 	: in STD_LOGIC;
			rst 	: in STD_LOGIC;
			start 	: in STD_LOGIC;
			x 		: in STD_LOGIC_VECTOR ( 15 downto 0 );
			y 		: out STD_LOGIC_VECTOR ( 15 downto 0 );
			fir_memory_s2_address		: out std_logic_vector(14 downto 0); 	 			
			fir_memory_s2_clken			: out std_logic;
			fir_memory_s2_readdata		: in std_logic_vector(31 downto 0); 	
			fir_memory_clk2_clk			: out std_logic
	);
	end component;
	
	-- Downsample Filter --
	component DownsampleFilter is
	generic (   div         : INTEGER;                           
				mul_factor  : Integer);                                        
	port (	clk 	: in STD_LOGIC;
			rst 	: in STD_LOGIC;
			x 		: in STD_LOGIC_VECTOR ( 15 downto 0 );
			y 		: out STD_LOGIC_VECTOR ( 15 downto 0 ));
	end component;
	
	-- Clock Generator --
	component clockGenerator is
	generic (	lPeriod	: INTEGER;		        
				hPeriod	: INTEGER);		         
	port (	clk_in 	: in STD_LOGIC;
			rst 	: in STD_LOGIC;
			clk_out : out STD_LOGIC);
	end component;
	
	-- FIFO Buffer --
	component FIFO is
	generic ( 	data_width     : integer;                    
				address_width  : integer;                             
				buffer_length  : integer);                                                          
	port (	clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			d0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
			q0 : out STD_LOGIC_VECTOR ( 15 downto 0 ));
	end component;
	
	-- Subtract --										
	component Subtract is
	generic( factor      : INTEGER RANGE 0 TO 65565);    
	port (	clk : in STD_LOGIC;
			DIN1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
			DIN2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
			DOUT : out STD_LOGIC_VECTOR ( 15 downto 0 ));
	end component;
  
	-- Interpolation X4 --
	component InterpolationX4 is
	generic( c_file : string);
	port (	clk	: in STD_LOGIC;
				clk25M	: in STD_LOGIC;
			rst : in STD_LOGIC;
			cntl : in STD_LOGIC;
			x 	: in STD_LOGIC_VECTOR ( 15 downto 0 );
			y 	: out STD_LOGIC_VECTOR ( 15 downto 0 );
			s2_address 		: out std_logic_vector (4 downto 0);	
			s2_clken			: out std_logic;		
			s2_readdata		: in std_logic_vector(31 downto 0);
			clk2_clk			: out std_logic);
	end component;
	
	-- Interpolation X5 --
	component InterpolationX5 is
	generic( c_file : string);
	port (	clk	: in STD_LOGIC;
				clk25M	: in STD_LOGIC;
			rst : in STD_LOGIC;
			cntl : in STD_LOGIC;
			x 	: in STD_LOGIC_VECTOR ( 15 downto 0 );
			y 	: out STD_LOGIC_VECTOR ( 15 downto 0 );
			s2_address 		: out std_logic_vector (5 downto 0);	
			s2_clken			: out std_logic;		
			s2_readdata		: in std_logic_vector(31 downto 0);
			clk2_clk			: out std_logic);
  end component;
  
	-- Interpolation Clock Generator --
	component InterpClkGen is
	generic (	lPeriod1	: INTEGER;		   
                hPeriod1    : INTEGER;        
                lPeriod2    : INTEGER;
                hPeriod2    : INTEGER;
                lPeriod3    : INTEGER;
                hPeriod3    : INTEGER;
                lPeriod4    : INTEGER;
                hPeriod4    : INTEGER);
	port (	clk_in 	: in STD_LOGIC;
			rst		: in STD_LOGIC;
			clk_1 	: out STD_LOGIC;
			clk_2 	: out STD_LOGIC;
			clk_3 	: out STD_LOGIC;
			clk_4 	: out STD_LOGIC);
	end component;
  
begin
	---- Component instantiation --------------------------------------
	ClkGen_0: component clockGenerator      
	generic map(	lPeriod	=> clkGen_lP,		        
					hPeriod	=> clkGen_hP)		
	port map(	clk_in 	=> clk_25M,
				rst 	=> reset,
				clk_out => clk_10k);
				
	FIFO_0: component FIFO
	generic map( 	data_width     => 16,                    
					address_width  => FIFO_aWidth,                            
					buffer_length  => FIFO_length)     
    port map (	clk 	=> clk_25M,
				d0		=> s_in,
				q0		=> s_buf,
				rst 	=> reset);
	
	DownsampleFilter_0: component DownsampleFilter
	generic map(   	div			=> DsFil_div,                          
					mul_factor 	=> DsFil_mul)   
    port map (	clk 	=> clk_25M,
				rst 	=> reset,
				x 		=> s_in,
				y 		=> s_10k);
	
	FIRFilter_0: component FIRFilter
	generic map( 
					fLength 		=> FIR_length,                            
					aWidth			=> FIR_aWidth) 
    port map (	clk 	=> clk_25M,
				rst 	=> reset,
				start 	=> clk_10k,
				x		=> s_10k,
				y		=> s_HP,
				fir_memory_s2_address		=> fir_memory_s2_address,	 	 		
				fir_memory_s2_clken			=> fir_memory_s2_clken,		
				fir_memory_s2_readdata		=> fir_memory_s2_readdata,		
				fir_memory_clk2_clk			=> fir_memory_clk2_clk		
	);

	AdaptiveFilter_0: component AdaptiveFilter
	generic map( 	weight 	=> adFil_weight,			     
					pTh		=> adFil_pTH,				        
					nTh		=> adFil_nTH,				        
					aWidth	=> adFil_aWidth,						        
					fLength	=> adFil_length)
    port map (	adj 	=> adjust,
				clk 	=> clk_25M,
				p_hat 	=> pHat,
				rst 	=> reset,
				s 		=> s_HP,
				start 	=> clk_10k,
				v 		=> v_in,
				adapt_fir_mem_s2_address	=> adapt_fir_mem_s2_address,		
				adapt_fir_mem_s2_write		=> adapt_fir_mem_s2_write,				
				adapt_fir_mem_s2_writedata	=> adapt_fir_mem_s2_writedata,		
				adapt_fir_mem_clk2_clk		=> adapt_fir_mem_clk2_clk			
				);
	
	InterpClkGen_0: component InterpClkGen
	generic map(	lPeriod1	=> intClkGen_lP1,		   
					hPeriod1    => intClkGen_hP1,	       
					lPeriod2    => intClkGen_lP2,	
					hPeriod2    => intClkGen_hP2,	
					lPeriod3    => intClkGen_lP3,	
					hPeriod3    => intClkGen_hP3,	
					lPeriod4    => intClkGen_lP4,	
					hPeriod4    => intClkGen_hP4)
    port map (	clk_in 	=> clk_25M,
				rst 	=> reset,
				clk_1 	=> clk_i1,
				clk_2 	=> clk_i2,
				clk_3 	=> clk_i3,
				clk_4 	=> clk_i4);
				
	InterpolationX4_0: component InterpolationX4
	generic map( c_file	=> IntX4_cFile)
		port map (	clk => clk_i4,
						clk25M => clk_25M,
				rst => reset,
				cntl => cntl(0),
				x	=> pHat,
				y	=> pHat_i1,
				s2_address		=> interpo_4_0_s2_address,	
				s2_clken			=> interpo_4_0_s2_clken,	
				s2_readdata		=> interpo_4_0_s2_readdata,
				clk2_clk			=> interpo_4_0_clk2_clk
		);

	InterpolationX5_0: component InterpolationX5
	generic map( c_file	=> IntX5_cFile1)
    port map (	clk => clk_i3,
				clk25M => clk_25M,
				rst => reset,
				cntl => cntl(1),
				x	=> pHat_i1,
				y	=> pHat_i2,
				s2_address		=> interpo_5_0_s2_address,	
				s2_clken			=> interpo_5_0_s2_clken,	
				s2_readdata		=> interpo_5_0_s2_readdata,
				clk2_clk			=> interpo_5_0_clk2_clk
		);
				
	InterpolationX5_1: component InterpolationX5
	generic map( c_file	=> IntX5_cFile2)
    port map (	clk => clk_i2,
				clk25M => clk_25M,
				rst => reset,
				cntl => cntl(2),
				x	=> pHat_i2,
				y	=> pHat_i3,
				s2_address		=> interpo_5_1_s2_address,	
				s2_clken			=> interpo_5_1_s2_clken,	
				s2_readdata		=> interpo_5_1_s2_readdata,
				clk2_clk			=> interpo_5_1_clk2_clk
		);
	
	InterpolationX5_2: component InterpolationX5
	generic map( c_file	=> IntX5_cFile3)
    port map (	clk => clk_i1,
				clk25M => clk_25M,
				rst => reset,
				cntl => cntl(3),
				x	=> pHat_i3,
				y	=> pHat_i4,
				s2_address		=> interpo_5_2_s2_address,	
				s2_clken			=> interpo_5_2_s2_clken,	
				s2_readdata		=> interpo_5_2_s2_readdata,
				clk2_clk			=> interpo_5_2_clk2_clk
		);
	
	InterpolationX5_3: component InterpolationX5
	generic map( c_file	=> IntX5_cFile4)
    port map (	clk => clk_25M,
				clk25M => clk_25M,
				rst => reset,
				cntl => cntl(4),
				x	=> pHat_i4,
				y	=> pHat_25M,
				s2_address		=> interpo_5_3_s2_address,	
				s2_clken			=> interpo_5_3_s2_clken,	
				s2_readdata		=> interpo_5_3_s2_readdata,
				clk2_clk			=> interpo_5_3_clk2_clk
		);
				
	Subtract_0: component Subtract
	generic map( factor	=> Sub_factor)  			-- INTEGER RANGE 0 TO 65565 := 4111 -- Subtract - DIN2 Factor (4.12)
    port map (	DIN1	=> s_buf,
				DIN2	=> pHat_25M,
				DOUT	=> y_out,
				clk 	=> clk_25M);
	
	--- IOs -----------------------------------------------
	clk_25M <= clk_in;	
	clk_outp <= clk_25M;
	reset <= rst;
	adjust <= adj;
	s_in <= gamma;
	v_in <= mic;
	gamma_corr <= y_out;
	
end micFilter_behav;