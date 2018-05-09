----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:20:24 04/30/2018 
-- Design Name: 
-- Module Name:    LED_mover - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED_mover is
--	port( push, clk, reset, led_reset : in STD_LOGIC;
	port( clk, reset : in STD_LOGIC;
			dip_input : in STD_LOGIC_VECTOR(0 to 7);
			led_output : out STD_LOGIC_VECTOR(23 downto 0)
			);
end LED_mover;

architecture Behavioral of LED_mover is

constant clk_period : time := 1ns;

COMPONENT reg
	port (input : in STD_LOGIC_VECTOR(11 downto 0);
			clk, reset, en : in STD_LOGIC;
			output : out STD_LOGIC_VECTOR(11 downto 0));
END COMPONENT;

COMPONENT clkdivider
	port (clk, rst : in STD_LOGIC;
			dclk : out STD_LOGIC
			);
end COMPONENT;

signal display_signal : STD_LOGIC_VECTOR(23 downto 0);
signal dip_reg_in : STD_LOGIC_VECTOR(0 to 7);
signal led_reg_top_in : STD_LOGIC_VECTOR(11 downto 0);
signal led_reg_top_out : STD_LOGIC_VECTOR(11 downto 0);
signal led_reg_mid_in : STD_LOGIC_VECTOR(11 downto 0);
signal led_reg_mid_out : STD_LOGIC_VECTOR(11 downto 0);
signal led_reg_bot_in : STD_LOGIC_VECTOR(11 downto 0);
signal led_reg_bot_out : STD_LOGIC_VECTOR(11 downto 0);
signal inv_reset : STD_LOGIC;
signal my_clk: STD_LOGIC;
--signal inv_led_reset : std_logic;
--signal inv_push : std_logic;


begin
	inv_reset <= not reset;
--	inv_led_reset <= not led_reset;
--	inv_push <= not push;
	dip_reg_in <= dip_input;
	
--	process(inv_led_reset, inv_push, led_reg_out)
--	begin
--		if inv_led_reset = '1' then
--			led_reg_in <= x"01";
--		elsif inv_push = '1' then
--			led_reg_in <= led_reg_out(0) & led_reg_out(7 downto 1);
--		else
--			led_reg_in <= led_reg_out;
--		end if;
--	end process;
									
	process(dip_reg_in)
	begin
		if dip_reg_in = "0-------" then
			led_reg_top_in <= x"208";
			led_reg_mid_in <= x"71c";
			led_reg_bot_in <= x"fbe";
			display_signal(7 downto 0) <= led_reg_top_out (11 downto 4);
			display_signal(15 downto 8) <= led_reg_mid_out (11 downto 4);
			display_signal(23 downto 16) <= led_reg_bot_out (11 downto 4);
			display_signal <= x"000000";
		elsif dip_reg_in = "100-----" then
			--led_reg_in <= x"fbe71c208";
			--led_reg_top_in <= x"208";
--			led_reg_mid_in <= x"71c";
--			led_reg_bot_in <= x"fbe";
			display_signal(7 downto 0) <= led_reg_top_out (11 downto 4);
			display_signal(15 downto 8) <= led_reg_mid_out (11 downto 4);
			display_signal(23 downto 16) <= led_reg_bot_out (11 downto 4);
			--led_reg_in <= display_signal;
		elsif dip_reg_in = "101-----" then
			led_reg_top_in(11 downto 0) <= led_reg_top_out(10 downto 0) & led_reg_top_out(11) ;
			led_reg_mid_in(11 downto 0) <= led_reg_mid_out(10 downto 0) & led_reg_mid_out(11) ;
			led_reg_bot_in(11 downto 0) <= led_reg_bot_out(10 downto 0) & led_reg_bot_out(11) ;		
			display_signal(7 downto 0) <= led_reg_top_out (11 downto 4);
			display_signal(15 downto 8) <= led_reg_mid_out (11 downto 4);
			display_signal(23 downto 16) <= led_reg_bot_out (11 downto 4);						
		elsif dip_reg_in = "110-----" then
			led_reg_top_in(11 downto 0) <= led_reg_top_out(0) & led_reg_top_out(11 downto 1) ;
			led_reg_mid_in(11 downto 0) <= led_reg_mid_out(0) & led_reg_mid_out(11 downto 1) ;
			led_reg_bot_in(11 downto 0) <= led_reg_bot_out(0) & led_reg_bot_out(11 downto 1) ;		
			display_signal(7 downto 0) <= led_reg_top_out (11 downto 4);
			display_signal(15 downto 8) <= led_reg_mid_out (11 downto 4);
			display_signal(23 downto 16) <= led_reg_bot_out (11 downto 4);						
		elsif dip_reg_in = "111-----" then	
		
			-- flickering led
			if my_clk = '1' then	
				display_signal <= x"000000";
			else
				display_signal(7 downto 0) <= led_reg_top_out (11 downto 4);
				display_signal(15 downto 8) <= led_reg_mid_out (11 downto 4);
				display_signal(23 downto 16) <= led_reg_bot_out (11 downto 4);
			end if;
		else
			display_signal <= x"ffffff";
		end if;
	end process;
	
	led_output <= display_signal;
	
	led_reg_bot : reg port map(input => led_reg_top_in,
									clk => my_clk,
									reset => inv_reset,
									en => '1',
									output => led_reg_top_out);
									
	led_reg_mid : reg port map(input => led_reg_mid_in,
									clk => my_clk,
									reset => inv_reset,
									en => '1',
									output => led_reg_mid_out);
									
	led_reg_top : reg port map(input => led_reg_bot_in,
									clk => my_clk,
									reset => inv_reset,
									en => '1',
									output => led_reg_bot_out);
	
	clk_div : clkdivider port map(clk => clk,
											rst => '0',
											dclk => my_clk);

end Behavioral;

