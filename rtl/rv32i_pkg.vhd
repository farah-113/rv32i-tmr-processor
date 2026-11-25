----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 03:45:05 PM
-- Design Name: 
-- Module Name: rv32i_pkg - Behavioral
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

package rv32i_pkg is

  type reg_file_t is array (0 to 31) of std_logic_vector(31 downto 0);

  constant MEM_DEPTH : integer := 256;
  type mem_array_t is array (0 to MEM_DEPTH - 1) of std_logic_vector(31 downto 0);
-------------------------------------------------------
  constant OP_RTYPE  : std_logic_vector(6 downto 0) := "0110011";
  constant OP_ITYPE  : std_logic_vector(6 downto 0) := "0010011";
  constant OP_LOAD   : std_logic_vector(6 downto 0) := "0000011";
  constant OP_STORE  : std_logic_vector(6 downto 0) := "0100011";
  constant OP_BRANCH : std_logic_vector(6 downto 0) := "1100011";
  constant OP_JAL    : std_logic_vector(6 downto 0) := "1101111";
  constant OP_JALR   : std_logic_vector(6 downto 0) := "1100111";
  constant OP_LUI    : std_logic_vector(6 downto 0) := "0110111";
  constant OP_AUIPC  : std_logic_vector(6 downto 0) := "0010111";
 
 -------------------------------------------------------------
  constant F3_ADD_SUB : std_logic_vector(2 downto 0) := "000";
  constant F3_SLL     : std_logic_vector(2 downto 0) := "001";
  constant F3_SLT     : std_logic_vector(2 downto 0) := "010";
  constant F3_XOR     : std_logic_vector(2 downto 0) := "100";
  constant F3_SRL     : std_logic_vector(2 downto 0) := "101";
  constant F3_OR      : std_logic_vector(2 downto 0) := "110";
  constant F3_AND     : std_logic_vector(2 downto 0) := "111";

  constant F3_BEQ     : std_logic_vector(2 downto 0) := "000";
  constant F3_BNE     : std_logic_vector(2 downto 0) := "001";
  constant F3_BLT     : std_logic_vector(2 downto 0) := "100";
  
-----------------------------------------------------------------------

  constant ALUOP_ADD   : std_logic_vector(1 downto 0) := "00";
  constant ALUOP_RTYPE : std_logic_vector(1 downto 0) := "10";
  constant ALUOP_ITYPE : std_logic_vector(1 downto 0) := "11";

  constant ALU_ADD : std_logic_vector(2 downto 0) := "000";
  constant ALU_SUB : std_logic_vector(2 downto 0) := "001";
  constant ALU_AND : std_logic_vector(2 downto 0) := "010";
  constant ALU_OR  : std_logic_vector(2 downto 0) := "011";
  constant ALU_XOR : std_logic_vector(2 downto 0) := "100";
  constant ALU_SLT : std_logic_vector(2 downto 0) := "101";
  constant ALU_SLL : std_logic_vector(2 downto 0) := "110";
  constant ALU_SRL : std_logic_vector(2 downto 0) := "111";

  constant IMM_I : std_logic_vector(2 downto 0) := "000";
  constant IMM_S : std_logic_vector(2 downto 0) := "001";
  constant IMM_B : std_logic_vector(2 downto 0) := "010";
  constant IMM_U : std_logic_vector(2 downto 0) := "011";
  constant IMM_J : std_logic_vector(2 downto 0) := "100";

  constant WB_ALU   : std_logic_vector(2 downto 0) := "000";
  constant WB_MEM   : std_logic_vector(2 downto 0) := "001";
  constant WB_PC4   : std_logic_vector(2 downto 0) := "010";
  constant WB_LUI   : std_logic_vector(2 downto 0) := "011";
  constant WB_AUIPC : std_logic_vector(2 downto 0) := "100";
  
-----------------------------------------------------------------
constant NOP_INSTR : std_logic_vector(31 downto 0) := x"00000013";

end package rv32i_pkg;