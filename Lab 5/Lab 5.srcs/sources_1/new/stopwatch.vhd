----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2019 10:15:35 PM
-- Design Name: 
-- Module Name: stopwatch - Behavioral
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

entity stopwatch is
    Port ( B1 : in STD_LOGIC; --Buttons 1: Start, 2: Stop, 3: Increment, 4: Reset
           B2 : in STD_LOGIC;
           B3 : in STD_LOGIC;
           B4 : in STD_LOGIC;
           Clk : in STD_LOGIC;
           X : out STD_LOGIC_VECTOR (6 downto 0));
end stopwatch;

architecture Behavioral of stopwatch is

component CLK_DIV is
Port ( Clock : in STD_LOGIC;
       Reset : in STD_LOGIC;
       CLK_OUT : out STD_LOGIC);
end component;

component counter is
Port (X : in STD_LOGIC;
      CLK : in STD_LOGIC;
      RST : in STD_LOGIC;
      G : inout STD_LOGIC_VECTOR (3 downto 0));
end component;

component decoder is 
Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
       Z : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component controller is
Port ( Start : in STD_LOGIC;
       Stop : in STD_LOGIC;
       Inc : in STD_LOGIC;
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       Run : out STD_LOGIC);
end component;

signal s1, s2 : STD_LOGIC; --S1: Output from clk div to controller and counter, S2: running output
signal s3 : STD_LOGIC_VECTOR (3 downto 0); --S3: Counter to decoder

begin

div: CLK_DIV Port Map(Clock => Clk, Reset => B4, CLK_OUT => s1);
D: decoder Port Map(A => s3, Z => X);
C: controller Port Map(Start => B1, Stop => B2, Inc => B3, rst => B4, clk => s1, Run => s2);
CO: counter Port Map(X => s2, CLK => s1, RST => b4, G => s3);


end Behavioral;
