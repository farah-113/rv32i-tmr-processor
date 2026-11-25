----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 04:35:21 PM
-- Design Name: 
-- Module Name: alu - Behavioral
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
use work.rv32i_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
  port (
    a        : in  std_logic_vector(31 downto 0);
    b        : in  std_logic_vector(31 downto 0);
    alu_ctrl : in  std_logic_vector(2 downto 0);
    result   : out std_logic_vector(31 downto 0)
  );
end entity alu;

architecture behavioural of alu is
begin

  process (a, b, alu_ctrl)
  begin
    case alu_ctrl is
      when ALU_ADD =>
        result <= a + b;
      when ALU_SUB =>
        result <= a - b;
      when ALU_AND =>
        result <= a and b;
      when ALU_OR =>
        result <= a or b;
      when ALU_XOR =>
        result <= a xor b;
      when ALU_SLT =>
        if signed(a) < signed(b) then
          result <= x"00000001";
        else
          result <= x"00000000";
        end if;
      when ALU_SLL =>
        result <= to_stdlogicvector(to_bitvector(a) sll conv_integer(b(4 downto 0)));
      when ALU_SRL =>                     
        result <= to_stdlogicvector(to_bitvector(a) srl conv_integer(b(4 downto 0)));
      when others =>
        result <= (others => '0');
    end case;
  end process;

end behavioural;