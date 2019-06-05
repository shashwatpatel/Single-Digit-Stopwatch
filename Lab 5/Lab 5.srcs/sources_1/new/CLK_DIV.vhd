----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2019 12:15:36 PM
-- Design Name: 
-- Module Name: divider - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLK_DIV is
    Port ( Clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC);
end CLK_DIV;

architecture Behavioral of CLK_DIV is
constant cntendval : STD_LOGIC_VECTOR(26 downto 0) := "101111101011110000100000000";
signal cntval : STD_LOGIC_VECTOR (26 downto 0) := (others => '0');
begin
process (Clock, Reset)
 begin
 if Reset = '1' then cntval <= "000000000000000000000000000";
 elsif (rising_edge(Clock)) then
 if (cntval = cntendval) then cntval <="000000000000000000000000000";
 else cntval <= cntval + 1;
 end if;
 end if;
 end process;
 CLK_OUT <= cntval(26);
end Behavioral; 
