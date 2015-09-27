	component de2i_150_qsys is
		port (
			clk_clk                                    : in  std_logic                     := 'X';             -- clk
			reset_reset_n                              : in  std_logic                     := 'X';             -- reset_n
			pcie_ip_reconfig_togxb_data                : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- data
			pcie_ip_refclk_export                      : in  std_logic                     := 'X';             -- export
			pcie_ip_test_in_test_in                    : in  std_logic_vector(39 downto 0) := (others => 'X'); -- test_in
			pcie_ip_pcie_rstn_export                   : in  std_logic                     := 'X';             -- export
			pcie_ip_clocks_sim_clk250_export           : out std_logic;                                        -- clk250_export
			pcie_ip_clocks_sim_clk500_export           : out std_logic;                                        -- clk500_export
			pcie_ip_clocks_sim_clk125_export           : out std_logic;                                        -- clk125_export
			pcie_ip_reconfig_busy_busy_altgxb_reconfig : in  std_logic                     := 'X';             -- busy_altgxb_reconfig
			pcie_ip_pipe_ext_pipe_mode                 : in  std_logic                     := 'X';             -- pipe_mode
			pcie_ip_pipe_ext_phystatus_ext             : in  std_logic                     := 'X';             -- phystatus_ext
			pcie_ip_pipe_ext_rate_ext                  : out std_logic;                                        -- rate_ext
			pcie_ip_pipe_ext_powerdown_ext             : out std_logic_vector(1 downto 0);                     -- powerdown_ext
			pcie_ip_pipe_ext_txdetectrx_ext            : out std_logic;                                        -- txdetectrx_ext
			pcie_ip_pipe_ext_rxelecidle0_ext           : in  std_logic                     := 'X';             -- rxelecidle0_ext
			pcie_ip_pipe_ext_rxdata0_ext               : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- rxdata0_ext
			pcie_ip_pipe_ext_rxstatus0_ext             : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus0_ext
			pcie_ip_pipe_ext_rxvalid0_ext              : in  std_logic                     := 'X';             -- rxvalid0_ext
			pcie_ip_pipe_ext_rxdatak0_ext              : in  std_logic                     := 'X';             -- rxdatak0_ext
			pcie_ip_pipe_ext_txdata0_ext               : out std_logic_vector(7 downto 0);                     -- txdata0_ext
			pcie_ip_pipe_ext_txdatak0_ext              : out std_logic;                                        -- txdatak0_ext
			pcie_ip_pipe_ext_rxpolarity0_ext           : out std_logic;                                        -- rxpolarity0_ext
			pcie_ip_pipe_ext_txcompl0_ext              : out std_logic;                                        -- txcompl0_ext
			pcie_ip_pipe_ext_txelecidle0_ext           : out std_logic;                                        -- txelecidle0_ext
			pcie_ip_rx_in_rx_datain_0                  : in  std_logic                     := 'X';             -- rx_datain_0
			pcie_ip_tx_out_tx_dataout_0                : out std_logic;                                        -- tx_dataout_0
			pcie_ip_reconfig_fromgxb_0_data            : out std_logic_vector(4 downto 0);                     -- data
			led_external_connection_export             : out std_logic_vector(3 downto 0);                     -- export
			button_external_connection_export          : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			fir_memory_s2_address                      : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- address
			fir_memory_s2_chipselect                   : in  std_logic                     := 'X';             -- chipselect
			fir_memory_s2_clken                        : in  std_logic                     := 'X';             -- clken
			fir_memory_s2_write                        : in  std_logic                     := 'X';             -- write
			fir_memory_s2_readdata                     : out std_logic_vector(31 downto 0);                    -- readdata
			fir_memory_s2_writedata                    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			fir_memory_s2_byteenable                   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			fir_memory_clk2_clk                        : in  std_logic                     := 'X';             -- clk
			fir_memory_reset2_reset                    : in  std_logic                     := 'X';             -- reset
			fir_memory_reset2_reset_req                : in  std_logic                     := 'X';             -- reset_req
			interpo_4_0_s2_address                     : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- address
			interpo_4_0_s2_chipselect                  : in  std_logic                     := 'X';             -- chipselect
			interpo_4_0_s2_clken                       : in  std_logic                     := 'X';             -- clken
			interpo_4_0_s2_write                       : in  std_logic                     := 'X';             -- write
			interpo_4_0_s2_readdata                    : out std_logic_vector(31 downto 0);                    -- readdata
			interpo_4_0_s2_writedata                   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			interpo_4_0_s2_byteenable                  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			interpo_4_0_clk2_clk                       : in  std_logic                     := 'X';             -- clk
			interpo_4_0_reset2_reset                   : in  std_logic                     := 'X';             -- reset
			interpo_4_0_reset2_reset_req               : in  std_logic                     := 'X';             -- reset_req
			interpo_5_0_s2_address                     : in  std_logic_vector(5 downto 0)  := (others => 'X'); -- address
			interpo_5_0_s2_chipselect                  : in  std_logic                     := 'X';             -- chipselect
			interpo_5_0_s2_clken                       : in  std_logic                     := 'X';             -- clken
			interpo_5_0_s2_write                       : in  std_logic                     := 'X';             -- write
			interpo_5_0_s2_readdata                    : out std_logic_vector(31 downto 0);                    -- readdata
			interpo_5_0_s2_writedata                   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			interpo_5_0_s2_byteenable                  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			interpo_5_0_clk2_clk                       : in  std_logic                     := 'X';             -- clk
			interpo_5_0_reset2_reset                   : in  std_logic                     := 'X';             -- reset
			interpo_5_0_reset2_reset_req               : in  std_logic                     := 'X';             -- reset_req
			interpo_5_1_clk2_clk                       : in  std_logic                     := 'X';             -- clk
			interpo_5_1_s2_address                     : in  std_logic_vector(5 downto 0)  := (others => 'X'); -- address
			interpo_5_1_s2_chipselect                  : in  std_logic                     := 'X';             -- chipselect
			interpo_5_1_s2_clken                       : in  std_logic                     := 'X';             -- clken
			interpo_5_1_s2_write                       : in  std_logic                     := 'X';             -- write
			interpo_5_1_s2_readdata                    : out std_logic_vector(31 downto 0);                    -- readdata
			interpo_5_1_s2_writedata                   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			interpo_5_1_s2_byteenable                  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			interpo_5_1_reset2_reset                   : in  std_logic                     := 'X';             -- reset
			interpo_5_1_reset2_reset_req               : in  std_logic                     := 'X';             -- reset_req
			interpo_5_2_s2_address                     : in  std_logic_vector(5 downto 0)  := (others => 'X'); -- address
			interpo_5_2_s2_chipselect                  : in  std_logic                     := 'X';             -- chipselect
			interpo_5_2_s2_clken                       : in  std_logic                     := 'X';             -- clken
			interpo_5_2_s2_write                       : in  std_logic                     := 'X';             -- write
			interpo_5_2_s2_readdata                    : out std_logic_vector(31 downto 0);                    -- readdata
			interpo_5_2_s2_writedata                   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			interpo_5_2_s2_byteenable                  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			interpo_5_2_clk2_clk                       : in  std_logic                     := 'X';             -- clk
			interpo_5_2_reset2_reset                   : in  std_logic                     := 'X';             -- reset
			interpo_5_2_reset2_reset_req               : in  std_logic                     := 'X';             -- reset_req
			interpo_5_3_s2_address                     : in  std_logic_vector(5 downto 0)  := (others => 'X'); -- address
			interpo_5_3_s2_chipselect                  : in  std_logic                     := 'X';             -- chipselect
			interpo_5_3_s2_clken                       : in  std_logic                     := 'X';             -- clken
			interpo_5_3_s2_write                       : in  std_logic                     := 'X';             -- write
			interpo_5_3_s2_readdata                    : out std_logic_vector(31 downto 0);                    -- readdata
			interpo_5_3_s2_writedata                   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			interpo_5_3_s2_byteenable                  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			interpo_5_3_clk2_clk                       : in  std_logic                     := 'X';             -- clk
			interpo_5_3_reset2_reset                   : in  std_logic                     := 'X';             -- reset
			interpo_5_3_reset2_reset_req               : in  std_logic                     := 'X';             -- reset_req
			adapt_fir_mem_s2_address                   : in  std_logic_vector(8 downto 0)  := (others => 'X'); -- address
			adapt_fir_mem_s2_chipselect                : in  std_logic                     := 'X';             -- chipselect
			adapt_fir_mem_s2_clken                     : in  std_logic                     := 'X';             -- clken
			adapt_fir_mem_s2_write                     : in  std_logic                     := 'X';             -- write
			adapt_fir_mem_s2_readdata                  : out std_logic_vector(31 downto 0);                    -- readdata
			adapt_fir_mem_s2_writedata                 : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			adapt_fir_mem_s2_byteenable                : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			adapt_fir_mem_clk2_clk                     : in  std_logic                     := 'X';             -- clk
			adapt_fir_mem_reset2_reset                 : in  std_logic                     := 'X';             -- reset
			adapt_fir_mem_reset2_reset_req             : in  std_logic                     := 'X';             -- reset_req
			micfilter_cntl_export                      : out std_logic_vector(31 downto 0);                    -- export
			micfilter_rst_export                       : out std_logic                                         -- export
		);
	end component de2i_150_qsys;

	u0 : component de2i_150_qsys
		port map (
			clk_clk                                    => CONNECTED_TO_clk_clk,                                    --                        clk.clk
			reset_reset_n                              => CONNECTED_TO_reset_reset_n,                              --                      reset.reset_n
			pcie_ip_reconfig_togxb_data                => CONNECTED_TO_pcie_ip_reconfig_togxb_data,                --     pcie_ip_reconfig_togxb.data
			pcie_ip_refclk_export                      => CONNECTED_TO_pcie_ip_refclk_export,                      --             pcie_ip_refclk.export
			pcie_ip_test_in_test_in                    => CONNECTED_TO_pcie_ip_test_in_test_in,                    --            pcie_ip_test_in.test_in
			pcie_ip_pcie_rstn_export                   => CONNECTED_TO_pcie_ip_pcie_rstn_export,                   --          pcie_ip_pcie_rstn.export
			pcie_ip_clocks_sim_clk250_export           => CONNECTED_TO_pcie_ip_clocks_sim_clk250_export,           --         pcie_ip_clocks_sim.clk250_export
			pcie_ip_clocks_sim_clk500_export           => CONNECTED_TO_pcie_ip_clocks_sim_clk500_export,           --                           .clk500_export
			pcie_ip_clocks_sim_clk125_export           => CONNECTED_TO_pcie_ip_clocks_sim_clk125_export,           --                           .clk125_export
			pcie_ip_reconfig_busy_busy_altgxb_reconfig => CONNECTED_TO_pcie_ip_reconfig_busy_busy_altgxb_reconfig, --      pcie_ip_reconfig_busy.busy_altgxb_reconfig
			pcie_ip_pipe_ext_pipe_mode                 => CONNECTED_TO_pcie_ip_pipe_ext_pipe_mode,                 --           pcie_ip_pipe_ext.pipe_mode
			pcie_ip_pipe_ext_phystatus_ext             => CONNECTED_TO_pcie_ip_pipe_ext_phystatus_ext,             --                           .phystatus_ext
			pcie_ip_pipe_ext_rate_ext                  => CONNECTED_TO_pcie_ip_pipe_ext_rate_ext,                  --                           .rate_ext
			pcie_ip_pipe_ext_powerdown_ext             => CONNECTED_TO_pcie_ip_pipe_ext_powerdown_ext,             --                           .powerdown_ext
			pcie_ip_pipe_ext_txdetectrx_ext            => CONNECTED_TO_pcie_ip_pipe_ext_txdetectrx_ext,            --                           .txdetectrx_ext
			pcie_ip_pipe_ext_rxelecidle0_ext           => CONNECTED_TO_pcie_ip_pipe_ext_rxelecidle0_ext,           --                           .rxelecidle0_ext
			pcie_ip_pipe_ext_rxdata0_ext               => CONNECTED_TO_pcie_ip_pipe_ext_rxdata0_ext,               --                           .rxdata0_ext
			pcie_ip_pipe_ext_rxstatus0_ext             => CONNECTED_TO_pcie_ip_pipe_ext_rxstatus0_ext,             --                           .rxstatus0_ext
			pcie_ip_pipe_ext_rxvalid0_ext              => CONNECTED_TO_pcie_ip_pipe_ext_rxvalid0_ext,              --                           .rxvalid0_ext
			pcie_ip_pipe_ext_rxdatak0_ext              => CONNECTED_TO_pcie_ip_pipe_ext_rxdatak0_ext,              --                           .rxdatak0_ext
			pcie_ip_pipe_ext_txdata0_ext               => CONNECTED_TO_pcie_ip_pipe_ext_txdata0_ext,               --                           .txdata0_ext
			pcie_ip_pipe_ext_txdatak0_ext              => CONNECTED_TO_pcie_ip_pipe_ext_txdatak0_ext,              --                           .txdatak0_ext
			pcie_ip_pipe_ext_rxpolarity0_ext           => CONNECTED_TO_pcie_ip_pipe_ext_rxpolarity0_ext,           --                           .rxpolarity0_ext
			pcie_ip_pipe_ext_txcompl0_ext              => CONNECTED_TO_pcie_ip_pipe_ext_txcompl0_ext,              --                           .txcompl0_ext
			pcie_ip_pipe_ext_txelecidle0_ext           => CONNECTED_TO_pcie_ip_pipe_ext_txelecidle0_ext,           --                           .txelecidle0_ext
			pcie_ip_rx_in_rx_datain_0                  => CONNECTED_TO_pcie_ip_rx_in_rx_datain_0,                  --              pcie_ip_rx_in.rx_datain_0
			pcie_ip_tx_out_tx_dataout_0                => CONNECTED_TO_pcie_ip_tx_out_tx_dataout_0,                --             pcie_ip_tx_out.tx_dataout_0
			pcie_ip_reconfig_fromgxb_0_data            => CONNECTED_TO_pcie_ip_reconfig_fromgxb_0_data,            -- pcie_ip_reconfig_fromgxb_0.data
			led_external_connection_export             => CONNECTED_TO_led_external_connection_export,             --    led_external_connection.export
			button_external_connection_export          => CONNECTED_TO_button_external_connection_export,          -- button_external_connection.export
			fir_memory_s2_address                      => CONNECTED_TO_fir_memory_s2_address,                      --              fir_memory_s2.address
			fir_memory_s2_chipselect                   => CONNECTED_TO_fir_memory_s2_chipselect,                   --                           .chipselect
			fir_memory_s2_clken                        => CONNECTED_TO_fir_memory_s2_clken,                        --                           .clken
			fir_memory_s2_write                        => CONNECTED_TO_fir_memory_s2_write,                        --                           .write
			fir_memory_s2_readdata                     => CONNECTED_TO_fir_memory_s2_readdata,                     --                           .readdata
			fir_memory_s2_writedata                    => CONNECTED_TO_fir_memory_s2_writedata,                    --                           .writedata
			fir_memory_s2_byteenable                   => CONNECTED_TO_fir_memory_s2_byteenable,                   --                           .byteenable
			fir_memory_clk2_clk                        => CONNECTED_TO_fir_memory_clk2_clk,                        --            fir_memory_clk2.clk
			fir_memory_reset2_reset                    => CONNECTED_TO_fir_memory_reset2_reset,                    --          fir_memory_reset2.reset
			fir_memory_reset2_reset_req                => CONNECTED_TO_fir_memory_reset2_reset_req,                --                           .reset_req
			interpo_4_0_s2_address                     => CONNECTED_TO_interpo_4_0_s2_address,                     --             interpo_4_0_s2.address
			interpo_4_0_s2_chipselect                  => CONNECTED_TO_interpo_4_0_s2_chipselect,                  --                           .chipselect
			interpo_4_0_s2_clken                       => CONNECTED_TO_interpo_4_0_s2_clken,                       --                           .clken
			interpo_4_0_s2_write                       => CONNECTED_TO_interpo_4_0_s2_write,                       --                           .write
			interpo_4_0_s2_readdata                    => CONNECTED_TO_interpo_4_0_s2_readdata,                    --                           .readdata
			interpo_4_0_s2_writedata                   => CONNECTED_TO_interpo_4_0_s2_writedata,                   --                           .writedata
			interpo_4_0_s2_byteenable                  => CONNECTED_TO_interpo_4_0_s2_byteenable,                  --                           .byteenable
			interpo_4_0_clk2_clk                       => CONNECTED_TO_interpo_4_0_clk2_clk,                       --           interpo_4_0_clk2.clk
			interpo_4_0_reset2_reset                   => CONNECTED_TO_interpo_4_0_reset2_reset,                   --         interpo_4_0_reset2.reset
			interpo_4_0_reset2_reset_req               => CONNECTED_TO_interpo_4_0_reset2_reset_req,               --                           .reset_req
			interpo_5_0_s2_address                     => CONNECTED_TO_interpo_5_0_s2_address,                     --             interpo_5_0_s2.address
			interpo_5_0_s2_chipselect                  => CONNECTED_TO_interpo_5_0_s2_chipselect,                  --                           .chipselect
			interpo_5_0_s2_clken                       => CONNECTED_TO_interpo_5_0_s2_clken,                       --                           .clken
			interpo_5_0_s2_write                       => CONNECTED_TO_interpo_5_0_s2_write,                       --                           .write
			interpo_5_0_s2_readdata                    => CONNECTED_TO_interpo_5_0_s2_readdata,                    --                           .readdata
			interpo_5_0_s2_writedata                   => CONNECTED_TO_interpo_5_0_s2_writedata,                   --                           .writedata
			interpo_5_0_s2_byteenable                  => CONNECTED_TO_interpo_5_0_s2_byteenable,                  --                           .byteenable
			interpo_5_0_clk2_clk                       => CONNECTED_TO_interpo_5_0_clk2_clk,                       --           interpo_5_0_clk2.clk
			interpo_5_0_reset2_reset                   => CONNECTED_TO_interpo_5_0_reset2_reset,                   --         interpo_5_0_reset2.reset
			interpo_5_0_reset2_reset_req               => CONNECTED_TO_interpo_5_0_reset2_reset_req,               --                           .reset_req
			interpo_5_1_clk2_clk                       => CONNECTED_TO_interpo_5_1_clk2_clk,                       --           interpo_5_1_clk2.clk
			interpo_5_1_s2_address                     => CONNECTED_TO_interpo_5_1_s2_address,                     --             interpo_5_1_s2.address
			interpo_5_1_s2_chipselect                  => CONNECTED_TO_interpo_5_1_s2_chipselect,                  --                           .chipselect
			interpo_5_1_s2_clken                       => CONNECTED_TO_interpo_5_1_s2_clken,                       --                           .clken
			interpo_5_1_s2_write                       => CONNECTED_TO_interpo_5_1_s2_write,                       --                           .write
			interpo_5_1_s2_readdata                    => CONNECTED_TO_interpo_5_1_s2_readdata,                    --                           .readdata
			interpo_5_1_s2_writedata                   => CONNECTED_TO_interpo_5_1_s2_writedata,                   --                           .writedata
			interpo_5_1_s2_byteenable                  => CONNECTED_TO_interpo_5_1_s2_byteenable,                  --                           .byteenable
			interpo_5_1_reset2_reset                   => CONNECTED_TO_interpo_5_1_reset2_reset,                   --         interpo_5_1_reset2.reset
			interpo_5_1_reset2_reset_req               => CONNECTED_TO_interpo_5_1_reset2_reset_req,               --                           .reset_req
			interpo_5_2_s2_address                     => CONNECTED_TO_interpo_5_2_s2_address,                     --             interpo_5_2_s2.address
			interpo_5_2_s2_chipselect                  => CONNECTED_TO_interpo_5_2_s2_chipselect,                  --                           .chipselect
			interpo_5_2_s2_clken                       => CONNECTED_TO_interpo_5_2_s2_clken,                       --                           .clken
			interpo_5_2_s2_write                       => CONNECTED_TO_interpo_5_2_s2_write,                       --                           .write
			interpo_5_2_s2_readdata                    => CONNECTED_TO_interpo_5_2_s2_readdata,                    --                           .readdata
			interpo_5_2_s2_writedata                   => CONNECTED_TO_interpo_5_2_s2_writedata,                   --                           .writedata
			interpo_5_2_s2_byteenable                  => CONNECTED_TO_interpo_5_2_s2_byteenable,                  --                           .byteenable
			interpo_5_2_clk2_clk                       => CONNECTED_TO_interpo_5_2_clk2_clk,                       --           interpo_5_2_clk2.clk
			interpo_5_2_reset2_reset                   => CONNECTED_TO_interpo_5_2_reset2_reset,                   --         interpo_5_2_reset2.reset
			interpo_5_2_reset2_reset_req               => CONNECTED_TO_interpo_5_2_reset2_reset_req,               --                           .reset_req
			interpo_5_3_s2_address                     => CONNECTED_TO_interpo_5_3_s2_address,                     --             interpo_5_3_s2.address
			interpo_5_3_s2_chipselect                  => CONNECTED_TO_interpo_5_3_s2_chipselect,                  --                           .chipselect
			interpo_5_3_s2_clken                       => CONNECTED_TO_interpo_5_3_s2_clken,                       --                           .clken
			interpo_5_3_s2_write                       => CONNECTED_TO_interpo_5_3_s2_write,                       --                           .write
			interpo_5_3_s2_readdata                    => CONNECTED_TO_interpo_5_3_s2_readdata,                    --                           .readdata
			interpo_5_3_s2_writedata                   => CONNECTED_TO_interpo_5_3_s2_writedata,                   --                           .writedata
			interpo_5_3_s2_byteenable                  => CONNECTED_TO_interpo_5_3_s2_byteenable,                  --                           .byteenable
			interpo_5_3_clk2_clk                       => CONNECTED_TO_interpo_5_3_clk2_clk,                       --           interpo_5_3_clk2.clk
			interpo_5_3_reset2_reset                   => CONNECTED_TO_interpo_5_3_reset2_reset,                   --         interpo_5_3_reset2.reset
			interpo_5_3_reset2_reset_req               => CONNECTED_TO_interpo_5_3_reset2_reset_req,               --                           .reset_req
			adapt_fir_mem_s2_address                   => CONNECTED_TO_adapt_fir_mem_s2_address,                   --           adapt_fir_mem_s2.address
			adapt_fir_mem_s2_chipselect                => CONNECTED_TO_adapt_fir_mem_s2_chipselect,                --                           .chipselect
			adapt_fir_mem_s2_clken                     => CONNECTED_TO_adapt_fir_mem_s2_clken,                     --                           .clken
			adapt_fir_mem_s2_write                     => CONNECTED_TO_adapt_fir_mem_s2_write,                     --                           .write
			adapt_fir_mem_s2_readdata                  => CONNECTED_TO_adapt_fir_mem_s2_readdata,                  --                           .readdata
			adapt_fir_mem_s2_writedata                 => CONNECTED_TO_adapt_fir_mem_s2_writedata,                 --                           .writedata
			adapt_fir_mem_s2_byteenable                => CONNECTED_TO_adapt_fir_mem_s2_byteenable,                --                           .byteenable
			adapt_fir_mem_clk2_clk                     => CONNECTED_TO_adapt_fir_mem_clk2_clk,                     --         adapt_fir_mem_clk2.clk
			adapt_fir_mem_reset2_reset                 => CONNECTED_TO_adapt_fir_mem_reset2_reset,                 --       adapt_fir_mem_reset2.reset
			adapt_fir_mem_reset2_reset_req             => CONNECTED_TO_adapt_fir_mem_reset2_reset_req,             --                           .reset_req
			micfilter_cntl_export                      => CONNECTED_TO_micfilter_cntl_export,                      --             micfilter_cntl.export
			micfilter_rst_export                       => CONNECTED_TO_micfilter_rst_export                        --              micfilter_rst.export
		);

