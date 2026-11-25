----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 08:53:17 PM
-- Design Name: 
-- Module Name: alu_decoder - Behavioral
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

-------------------------table 5's logic----------------------------------
entity alu_decoder is
  port (
    alu_op   : in  std_logic_vector(1 downto 0);
    funct3   : in  std_logic_vector(2 downto 0);
    funct7_5 : in  std_logic;
    alu_ctrl : out std_logic_vector(2 downto 0)
  );
end entity alu_decoder;

architecture behavioural of alu_decoder is
begin

  process (alu_op, funct3, funct7_5)
  begin
    alu_ctrl <= ALU_ADD;                       -- default (also alu_op = "00")

    case alu_op is
      when ALUOP_RTYPE =>
        case funct3 is
          when F3_ADD_SUB =>
            if funct7_5 = '1' then
              alu_ctrl <= ALU_SUB;
            else
              alu_ctrl <= ALU_ADD;
            end if;
          when F3_AND => alu_ctrl <= ALU_AND;
          when F3_OR  => alu_ctrl <= ALU_OR;
          when F3_XOR => alu_ctrl <= ALU_XOR;
          when F3_SLT => alu_ctrl <= ALU_SLT;
          when others => alu_ctrl <= ALU_ADD;
        end case;

      when ALUOP_ITYPE =>
        case funct3 is
          when F3_ADD_SUB => alu_ctrl <= ALU_ADD;   -- ADDI (funct7[5] ignored)
          when F3_AND     => alu_ctrl <= ALU_AND;   -- ANDI
          when F3_OR      => alu_ctrl <= ALU_OR;    -- ORI
          when F3_SLL     => alu_ctrl <= ALU_SLL;   -- SLLI
          when F3_SRL     => alu_ctrl <= ALU_SRL;   -- SRLI
          when others     => alu_ctrl <= ALU_ADD;
        end case;

      when others =>                                -- "00": LW, SW, JALR -> ADD
        alu_ctrl <= ALU_ADD;
    end case;
  end process;

end behavioural;