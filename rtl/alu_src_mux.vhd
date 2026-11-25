----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 09:36:08 PM
-- Design Name: 
-- Module Name: alu_src_mux - Behavioral
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

entity alu_src_mux is
  port (
    rs2_data : in  std_logic_vector(31 downto 0);
    imm      : in  std_logic_vector(31 downto 0);
    alu_src  : in  std_logic;
    alu_b    : out std_logic_vector(31 downto 0)
  );
end entity alu_src_mux;

architecture behavioural of alu_src_mux is
begin
  alu_b <= imm when alu_src = '1' else rs2_data;
end behavioural;