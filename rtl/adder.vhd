----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 04:25:31 PM
-- Design Name: 
-- Module Name: adder - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-------------------used for pc+4 and pc+imm---------------------------------------------
entity adder is
  port (
    a   : in  std_logic_vector(31 downto 0);
    b   : in  std_logic_vector(31 downto 0);
    sum : out std_logic_vector(31 downto 0)
  );
end entity adder;

architecture behavioural of adder is
begin
  sum <= a + b;
end behavioural;
