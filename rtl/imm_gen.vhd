----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 05:42:58 PM
-- Design Name: 
-- Module Name: imm_gen - Behavioral
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
use work.rv32i_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity imm_gen is
  port (
    instr   : in  std_logic_vector(31 downto 0);
    imm_sel : in  std_logic_vector(2 downto 0);
    imm     : out std_logic_vector(31 downto 0)
  );
end entity imm_gen;

architecture behavioural of imm_gen is
  signal sgn : std_logic_vector(31 downto 0);   -- instr(31) replicated
begin

  sgn <= (others => instr(31));

  process (instr, imm_sel, sgn)
  begin
    case imm_sel is
      when IMM_I =>  
        imm <= sgn(31 downto 12) & instr(31 downto 20);

      when IMM_S =>
        imm <= sgn(31 downto 12) & instr(31 downto 25) & instr(11 downto 7);

      when IMM_B => 
        imm <= sgn(31 downto 13) & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';

      when IMM_U =>
        imm <= instr(31 downto 12) & x"000";

      when IMM_J =>
        imm <= sgn(31 downto 21) & instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';

      when others =>
        imm <= (others => '0');
    end case;
  end process;

end behavioural;