----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:03:37 04/06/2017 
-- Design Name: 
-- Module Name:    clkdivider - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkdivider is
	port (clk, rst : in STD_LOGIC;
			dclk : out STD_LOGIC
			);
end clkdivider;

architecture Behavioral of clkdivider is
	signal cnt_data : STD_LOGIC_VECTOR(23 downto 0);
begin
	process (clk, rst)
	begin
		if rst='1' then
			cnt_data<=(others=>'0');
			dclk<='0';
		elsif clk'event and clk='1' then
			if cnt_data=x"ffffff" then
				cnt_data<=(others=>'0');
				dclk<='1';
			elsif cnt_data=x"7fffff" then
				dclk<='0';
				cnt_data<=cnt_data+'1';
			else
				cnt_data<=cnt_data+'1';
			end if;
		end if;
	end process;

end Behavioral;

