----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2019 09:59:26 PM
-- Design Name: 
-- Module Name: controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
    Port ( Start : in STD_LOGIC;
           Stop : in STD_LOGIC;
           Inc : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Run : out STD_LOGIC);
end controller;

architecture Behavioral of controller is

signal pS, nS : STD_LOGIC_VECTOR (1 downto 0); --PRESENT STATE AND NEXT STATE
signal hold : STD_LOGIC := '0';


begin

process (clk, rst)
begin

if (rst = '1') then pS <= "00";
elsif (rising_edge(clk)) then pS <= nS;
end if;
end process;

process (pS, Start, Stop, Inc)
begin
--Following the FSM diagram
case pS is 
when "00" => Run <= '0';
if (Start = '1') then nS <= "11";
elsif (Inc = '1') then nS <= "01";
else nS <= "00";
end if;

when "01" => Run <= '1';
nS <= "00";

when "11" => Run <= '1';
if (Stop = '1') then nS <= "00";
hold <= '0';
else nS <= "11";
hold <= '1';

if (hold = '1') then nS <= "11";
end if;
end if;
when others => nS <= "00";
end case;
end process;

end Behavioral;
