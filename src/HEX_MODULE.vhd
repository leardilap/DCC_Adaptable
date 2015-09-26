----------------------------------------------------------------------------------
-- Copyright (c) 2014, Luis Ardila
-- E-mail: leardilap@unal.edu.co
--
-- Description:
--
-- Revisions: 
-- Date        	Version    	Author    		Description
-- 23/11/2014    	1.0    		Luis Ardila    File created
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY HEX_MODULE IS
	PORT (
		HDIG			: IN 	STD_LOGIC_VECTOR (31 DOWNTO 0);		
		HEX_0			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		HEX_1			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		HEX_2			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		HEX_3			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		HEX_4			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		HEX_5			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		HEX_6			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		HEX_7			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
END HEX_MODULE;

ARCHITECTURE HEX_MODULE_ARCH OF HEX_MODULE IS

COMPONENT HDIG_HEX IS 
PORT (
		HDIG			: IN 	STD_LOGIC_VECTOR (3 DOWNTO 0);
		HEX			: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
END COMPONENT HDIG_HEX;

BEGIN

HEX0_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(3 downto 0),
		HEX	=> HEX_0
		);

HEX1_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(7 downto 4),
		HEX	=> HEX_1
		);
		
HEX2_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(11 downto 8),
		HEX	=> HEX_2
		);

HEX3_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(15 downto 12),
		HEX	=> HEX_3
		);
		
HEX4_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(19 downto 16),
		HEX	=> HEX_4
		);

HEX5_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(23 downto 20),
		HEX	=> HEX_5
		);
		

HEX6_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(27 downto 24),
		HEX	=> HEX_6
		);
		

HEX7_Inst : HDIG_HEX 
PORT MAP (
		HDIG	=> HDIG(31 downto 28),
		HEX	=> HEX_7
		);

END HEX_MODULE_ARCH;
