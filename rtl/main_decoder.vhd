----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 05:56:34 PM
-- Design Name: 
-- Module Name: main_decoder - Behavioral
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

-------------------table 4's logic---------------------------------------

entity main_decoder is
  port (
    opcode    : in  std_logic_vector(6 downto 0);
    reg_write : out std_logic;
    alu_src   : out std_logic;                      -- 0 = rs2, 1 = immediate
    alu_op    : out std_logic_vector(1 downto 0);
    mem_write : out std_logic;
    wb_sel    : out std_logic_vector(2 downto 0);
    imm_sel   : out std_logic_vector(2 downto 0);
    branch    : out std_logic;
    jal       : out std_logic;
    jalr      : out std_logic
  );
end entity main_decoder;

architecture behavioural of main_decoder is
begin

  process (opcode)
  begin
    -- defaults = NOP (later assignments in the case override these)
    reg_write <= '0';
    alu_src   <= '0';
    alu_op    <= ALUOP_ADD;
    mem_write <= '0';
    wb_sel    <= WB_ALU;
    imm_sel   <= IMM_I;
    branch    <= '0';
    jal       <= '0';
    jalr      <= '0';

    case opcode is
      when OP_RTYPE =>
        reg_write <= '1';
        alu_op    <= ALUOP_RTYPE;

      when OP_ITYPE =>
        reg_write <= '1';
        alu_src   <= '1';
        alu_op    <= ALUOP_ITYPE;
        imm_sel   <= IMM_I;

      when OP_LOAD =>
        reg_write <= '1';
        alu_src   <= '1';
        wb_sel    <= WB_MEM;
        imm_sel   <= IMM_I;

      when OP_STORE =>
        alu_src   <= '1';
        mem_write <= '1';
        imm_sel   <= IMM_S;

      when OP_BRANCH =>
        branch    <= '1';
        imm_sel   <= IMM_B;

      when OP_JAL =>
        reg_write <= '1';
        wb_sel    <= WB_PC4;
        imm_sel   <= IMM_J;
        jal       <= '1';

      when OP_JALR =>
        reg_write <= '1';
        alu_src   <= '1';
        wb_sel    <= WB_PC4;
        imm_sel   <= IMM_I;
        jalr      <= '1';

      when OP_LUI =>
        reg_write <= '1';
        wb_sel    <= WB_LUI;
        imm_sel   <= IMM_U;

      when OP_AUIPC =>
        reg_write <= '1';
        wb_sel    <= WB_AUIPC;
        imm_sel   <= IMM_U;

      when others =>
        null;
    end case;
  end process;

end behavioural;