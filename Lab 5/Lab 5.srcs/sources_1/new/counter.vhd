----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2019 02:31:11 PM
-- Design Name: 
-- Module Name: counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( X : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           G : inout STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture Behavioral of counter is

--signal T : STD_LOGIC_VECTOR (3 downto 0);

begin
process (CLK, RST)
begin
if (RST = '1') then G <= "0000";
elsif (rising_edge(CLK) and X = '1') then G <= G + 1; --increment counter
end if;
end process;


end Behavioral;
