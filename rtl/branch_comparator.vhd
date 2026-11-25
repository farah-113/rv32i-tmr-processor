----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 09:22:06 PM
-- Design Name: 
-- Module Name: branch_comparator - Behavioral
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
use ieee.numeric_std.all;
use work.rv32i_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity branch_comparator is
  port (
    rs1_data : in  std_logic_vector(31 downto 0);
    rs2_data : in  std_logic_vector(31 downto 0);
    funct3   : in  std_logic_vector(2 downto 0);
    branch   : in  std_logic;
    eq       : out std_logic;
    lt       : out std_logic;
    taken    : out std_logic
  );
end entity branch_comparator;

architecture behavioural of branch_comparator is
  signal eq_i, lt_i, cond : std_logic;
begin

  eq_i <= '1' when rs1_data = rs2_data else '0';
  lt_i <= '1' when signed(rs1_data) < signed(rs2_data) else '0';

  with funct3 select
    cond <= eq_i     when F3_BEQ,
            not eq_i when F3_BNE,
            lt_i     when F3_BLT,
            '0'      when others;

  taken <= branch and cond;
  eq    <= eq_i;
  lt    <= lt_i;

end behavioural;