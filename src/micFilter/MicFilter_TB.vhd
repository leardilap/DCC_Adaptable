library ieee;
use ieee.std_logic_1164.all;

entity tb_micFilter is
end tb_micFilter;

architecture tb of tb_micFilter is

    component micFilter
        port (adj        : in std_logic;
              clk_in     : in std_logic;
              gamma      : in std_logic_vector (15 downto 0 );
              mic        : in std_logic_vector (15 downto 0 );
              rst        : in std_logic;
              gamma_corr : out std_logic_vector (15 downto 0 );
              clk_outp   : out std_logic);
    end component;

    signal adj        : std_logic := '0';
    signal clk_in     : std_logic := '0';
    signal gamma      : std_logic_vector (15 downto 0 ) := (others => '0');
    signal mic        : std_logic_vector (15 downto 0 ) := (others => '0');
    signal rst        : std_logic := '0';
    signal gamma_corr : std_logic_vector (15 downto 0 ) := (others => '0');
    signal clk_outp   : std_logic := '0';

    constant clk_in_period : time := 5 ns; -- EDIT put right period here
  

begin

    dut : micFilter
    port map (adj        => adj,
              clk_in     => clk_in,
              gamma      => gamma,
              mic        => mic,
              rst        => rst,
              gamma_corr => gamma_corr,
              clk_outp   => clk_outp);

    clk_in <= not clk_in after clk_in_period/2;

    stimuli : process
    begin
		adj		<= '0';
		rst		<= '1';
        gamma 	<= (others => '0');
		mic		<= (others => '0');
		wait for clk_in_period*100;
		rst		<= '0';
        wait;
    end process;

end tb;