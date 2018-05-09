----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:03:33 04/30/2018 
-- Design Name: 
-- Module Name:    DFF - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DFF is
	port ( d, clk, reset, en: in STD_LOGIC; -- en : 0 현재값 유지 en : 1 새값 유지
			 q: out STD_LOGIC);

end DFF;

architecture Behavioral of DFF is

signal data : STD_LOGIC;

begin
	process(clk, reset, en)
	begin
		if reset = '1' then
			data <= '0';
		elsif en='1' then
			if clk'event and clk = '1' then -- clk에 event가 있을때마다 
				data <= d;
			else
				data <= data;
			end if;
		end if;
	end process;

	q <= data;
end Behavioral;

