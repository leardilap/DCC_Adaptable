-- =======================================================================
--              Adaptive Filter (by Christoph Pfeiffer)
--
--  Adaptive FIR filter with fLenght coefficients ('H_hat'). Synchronous
--	high on 'start' starts a cycle of the FIR filter with the option
--	to also adjust ('adj') the coefficients. Coefficients, input 
--	signals 'v' and 's' and output 'p_hat' are of fixed-point format 
--	with 4 integer and 12 fractional bits (Coefficents: 32bit, 4.28). 
--  The inputs are saved during the first clock.
--	The sequential FIR filter filters the input signal 'V' ('v' is a 
--  sample of 'V') with coefficients 'H_hat'. Output 'p_hat' is:	
--	
--			p_hat = SUM(V[i]*H_hat[i], i=0..fLength-1)
--	
--	If 'adj' is high (and adjustment isn't held or V not yet filled) 
--  the coefficients are adjusted by 'V' multiplied by the error 'e' 
--  and the weight 'mu':
--
--			H[i] = H[i] + mu * e * V[i] 	| i = 0..fLength-1
--
--	If input sample 's' exceeds 'threshold' the coefficients are held
--	(i.e. adjustment is disabled) for the next 10 cycles. 
--
--	One filter cycle takes fLength+4 (FIR filter) + fLength+3 (Coefficient 
--	update) = (2*fLength)+7 clock periods.
-- ======================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AdaptiveFilter is
generic ( 	weight 	: INTEGER := 2684355;				        -- mu (4.28; default=0.01)
			pTh		: INTEGER:= 8192; 					        -- positive threshold (4.12; default=2)
			nTh		: INTEGER := -8192; 				        -- negative threshold (4.12; default=-2)
			aWidth	: INTEGER := 9;						        -- Address width
			fLength	: INTEGER := 500);					        -- Filter length
port (	clk 	: IN STD_LOGIC;							        -- Clock
        rst 	: IN STD_LOGIC;							        -- Synchronous reset
        start 	: IN STD_LOGIC;							        -- Start filter cycle
		v 		: IN STD_LOGIC_VECTOR (15 downto 0);	        -- Mechanical sensor signal input
		s 		: IN STD_LOGIC_VECTOR (15 downto 0);	        -- Detector signal input
		adj 	: IN STD_LOGIC;						            -- Adjust input bit
        p_hat 	: OUT STD_LOGIC_VECTOR (15 downto 0):=x"0000";
			adapt_fir_mem_s2_address 	: out std_logic_vector(8 downto 0);
			adapt_fir_mem_s2_write		: out std_logic;
			adapt_fir_mem_s2_writedata	: out std_logic_vector(31 downto 0);
			adapt_fir_mem_clk2_clk		: out std_logic
	);	-- Signal output
end;


architecture behav_genAdF of AdaptiveFilter is 
    --- Constants ----------------------------------------------------------------------
	-- Calculation constants --
    constant mu : signed (31 downto 0) := to_signed(weight,32); 					            -- mu 
	constant threshold : signed (15 downto 0) := to_signed(pTh,16); 					        -- threshold
	constant neg_threshold : signed (15 downto 0) := to_signed(nTh,16); 				        -- negative threshold	
	-- System constants --
	constant constA_0 : unsigned (aWidth-1 downto 0) := to_unsigned(0,aWidth); 	                     
	constant constA_1 : unsigned (aWidth-1 downto 0) := to_unsigned(1,aWidth); 	              
	constant constA_2 : unsigned (aWidth-1 downto 0) := to_unsigned(2,aWidth); 	                
	constant constA_3 : unsigned (aWidth-1 downto 0) := to_unsigned(3,aWidth); 	                
	constant constA_4 : unsigned (aWidth-1 downto 0) := to_unsigned(4,aWidth); 	                
	constant constA_fLm1 : unsigned (aWidth-1 downto 0) := to_unsigned(fLength-1,aWidth); 	        
	constant constA_fL : unsigned (aWidth-1 downto 0) := to_unsigned(fLength,aWidth); 	        
	constant constA_fLp1 : unsigned (aWidth-1 downto 0) := to_unsigned(fLength+1,aWidth); 	         
	constant constA_fLp2 : unsigned (aWidth-1 downto 0) := to_unsigned(fLength+2,aWidth); 	                   
	constant const32_0 : signed (31 downto 0) := (others=>'0');                                 
 
    --- Signals --------------------------------------------------------------------
	-- aWidth signals --
	signal V_rAdd, V_wAdd, H_rAdd, H_wAdd : unsigned (aWidth-1 downto 0) := (others=>'0');		
    signal i : unsigned (aWidth-1 downto 0) := (others=>'0');			 						-- counter variable					    	
	-- Integer signals --
	signal hold, fill : INTEGER := 0;                                                           	
	-- 32 bit vsignals
	signal H_q, H_d : std_logic_vector(31 downto 0) := (others=>'0');		                   
	signal m2, mul, e_mu, H_tmp, acc, acc_tmp : signed(31 downto 0):= (others=>'0');            	
	-- 16 bit signals --
	signal V_q, V_d : std_logic_vector(15 downto 0) := (others=>'0');		                  
    signal m1, error, v_tmp, s_tmp, p_hat_tmp : signed(15 downto 0) := (others=>'0');				
	-- Flags --
	signal V_rCE, V_wCE, H_rCE, H_wCE, adj_flag, hold_flag, full, start_flag, clk_n : std_logic := '0';		
	signal FIR_flag : std_logic := '1';		
														
	--- Components ----------------------------------------------------------------
	-- RAM memory block --
    component DualClkRam --_Lengthx16
	generic(	dwidth 	   : integer; 
				awidth     : integer; 
				mem_size   : integer);
    port (	rAddr   : in std_logic_vector(aWidth-1 downto 0);     
			rCE     : in std_logic;                             
			rClk    : in std_logic;                            
			q       : out std_logic_vector(dwidth-1 downto 0) := (others=>'0');    
			wAddr   : in std_logic_vector(aWidth-1 downto 0);     
			wCE     : in std_logic;                             
			wClk    : in std_logic;                             
			d       : in std_logic_vector(dwidth-1 downto 0));
    end component;  
	-- Multiplier (16bit x 32bit) --
    component Multiplier16x32_32
    port(	DIN1	: in signed (15 downto 0);            
			DIN2	: in signed (31 downto 0);           
			DOUT	: out signed (31 downto 0));
    end component Multiplier16x32_32;
	------------------------------------------------------------
begin
	clk_n <= not clk;
    V_i : component DualClkRam
	generic map( 	dwidth 	=> 16,
					awidth  => aWidth, 
					mem_size => fLength)
    port map (	rAddr 	=>STD_LOGIC_VECTOR(V_rAdd),	
				rCE 	=> V_rCE,						
				rClk 	=> clk_n,					
				q 		=> V_q,
				wAddr 	=> STD_LOGIC_VECTOR(V_wAdd),	
				wCE 	=> V_wCE,						
				wClk 	=> clk_n,						
				d 		=> V_d);	
	H_hat : component DualClkRam
	generic map( 	dwidth 	=> 32,
					awidth  => aWidth, 
					mem_size => fLength)
    port map (	rAddr 	=>STD_LOGIC_VECTOR(H_rAdd), 	
				rCE 	=> H_rCE,						
				rClk 	=> clk_n,					
				q 		=> H_q,
				wAddr	=> STD_LOGIC_VECTOR(H_wAdd),	
				wCE 	=> H_wCE,						
				wClk 	=> clk_n,						
				d 		=> H_d);    
    myMul : component Multiplier16x32_32
    port map (	DIN1 	=> m1,                        
				DIN2 	=> m2,                        
				DOUT 	=> mul);				
    myEMu : component Multiplier16x32_32
    port map (	DIN1 	=> error,                        
				DIN2 	=> mu,                        
				DOUT 	=> e_mu);
	---------------------------------------------------	
	FIR : process(clk, start)
    begin
		if (clk'event and clk =  '1') then
			if (rst = '1') then
				FIR_flag <= '1';
				adj_flag <= '0';
				start_flag <= '0';
				full <= '0';
				fill <= 0;
			elsif(start  = '1' and start_flag = '0') then
			    ------- Initialize cycle -------
			    i <= constA_fLp2;
                FIR_flag <= '0';
                start_flag <= '1';
                adj_flag <='1';
                acc <= const32_0;
                -- save inputs --
                s_tmp <= signed(s);
                v_tmp <= signed(v);
                -- s exceeds threshold? --
                if ( signed(s) > threshold or signed(s) < neg_threshold) then
                    hold <= 10;   -- hold for 10 cycles
                end if;
                -- v storage full? --
                if (fill<fLength) then
                    full <= '0';
                    fill <= fill+1;
                else
                    full <='1';
                end if;
                -- hold coefficients? --
                if (hold > 0) then        
                    hold <= hold - 1;
                    hold_flag <= '1';
                else
                    hold_flag <= '0';
                end if;      			
			------- FIR Filter -------
			elsif (FIR_flag = '0') then	
				-- read V[i-1] and H_hat[i] --
				if (i >= constA_3) then
					V_rAdd <= (i-constA_4);
					V_rCE <= '1';
					H_rAdd <= (i-constA_3);
					H_rCE <= '1';
				else
					V_rCE <= '0';
					H_rCE <= '0';
				end if;
				-- V[i] <= V[i-1]; V[i-1]*H-hat[i] --
				if (i <= constA_fLp1 and i >= constA_3) then
					V_wAdd <= (i-constA_2);
					V_wCE <= '1';
					V_d <= V_q;
					m1 <= signed(V_q);
					m2 <= signed(H_q);
				-- V[0] <= v; V[0]*H-hat[0] --
				elsif (i = constA_2) then		
					V_wAdd <= (i-constA_2);
					V_wCE <= '1';
					V_d <= STD_LOGIC_VECTOR(v_tmp);
					m1 <= signed(v_tmp);
                    m2 <= signed(H_q);
				else
					V_wCE <= '0';
				end if;	
				-- accumulate --
				if (i <= constA_fL and i >= constA_1) then
					acc <= acc_tmp;
				end if;	
				-- final step of FIR cycle --				
				if (i <= constA_0) then
					p_hat_tmp <= acc(31 downto 16);
					FIR_flag <= '1';
					-- adjust coefficients? --
					if (adj = '1' AND full = '1' AND hold_flag = '0') then
					   adj_flag <= '1';
					else
					   adj_flag <= '0';
					end if;
			    else
			        i <= i - constA_1; 
				end if;					
			------- Coefficient adjustment -------	
			elsif (adj_flag = '1') then
				i <= i + constA_1;
				-- read V[i] --
				if (i <= constA_fLm1) then 
					V_rAdd <= (i);
					V_rCE <= '1';
				else
					V_rCE <= '0';
				end if;	
				-- mul = e*mu*V[i]; read H[i] --
				if (i >= constA_1 and i <= constA_fL) then
				    m1 <= signed(V_q);
                    m2 <= e_mu;		
					H_rAdd <= (i-constA_1);
					H_rCE <= '1';
				else
					H_rCE <= '0';
				end if;		
				-- H[i] <= H_tmp --	
				if (i >= constA_2 and i <= constA_fLp1) then
					H_d <= STD_LOGIC_VECTOR(H_tmp);
					H_wAdd <= (i-constA_2);
					H_wCE <= '1';
				else
					H_wCE <= '0';
				end if;		
				-- final step of adj cycle --
				if (i >= constA_fLp2) then	
					adj_flag <= '0';
				end if;
		    else
		      if(start = '0') then
		          start_flag <= '0';
		      end if;
			end if;
        end if;
    end process;	
	
	error <= s_tmp - p_hat_tmp;		-- e = s - p_hat
	acc_tmp <= acc + mul;			-- accumulate
	H_tmp	<= signed(H_q) + mul;
	p_hat <= STD_LOGIC_VECTOR(p_hat_tmp);
	
	adapt_fir_mem_s2_address 	<= STD_LOGIC_VECTOR(H_wAdd);
	adapt_fir_mem_s2_write		<=	H_wCE;
	adapt_fir_mem_s2_writedata	<= H_d;
	adapt_fir_mem_clk2_clk		<= clk;
	
end behav_genAdF;