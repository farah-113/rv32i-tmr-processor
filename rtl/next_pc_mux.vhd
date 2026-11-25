----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 09:28:08 PM
-- Design Name: 
-- Module Name: next_pc_mux - Behavioral
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

entity next_pc_mux is
  port (
    pc_plus4   : in  std_logic_vector(31 downto 0);
    pc_target  : in  std_logic_vector(31 downto 0);   -- PC + imm
    alu_result : in  std_logic_vector(31 downto 0);   -- rs1 + imm (JALR)
    jal        : in  std_logic;
    jalr       : in  std_logic;
    taken      : in  std_logic;
    pc_next    : out std_logic_vector(31 downto 0)
  );
end entity next_pc_mux;

architecture behavioural of next_pc_mux is
begin

  pc_next <= alu_result(31 downto 1) & '0' when jalr = '1' else
             pc_target                     when (jal = '1' or taken = '1') else
             pc_plus4;

end behavioural;