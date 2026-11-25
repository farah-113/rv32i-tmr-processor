----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 09:05:30 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
  port (
    opcode    : in  std_logic_vector(6 downto 0);
    funct3    : in  std_logic_vector(2 downto 0);
    funct7_5  : in  std_logic;
    reg_write : out std_logic;
    alu_src   : out std_logic;
    alu_ctrl  : out std_logic_vector(2 downto 0);
    mem_write : out std_logic;
    wb_sel    : out std_logic_vector(2 downto 0);
    imm_sel   : out std_logic_vector(2 downto 0);
    branch    : out std_logic;
    jal       : out std_logic;
    jalr      : out std_logic
  );
end entity control_unit;

architecture structural of control_unit is
  signal alu_op : std_logic_vector(1 downto 0);
begin

  u_main : entity work.main_decoder
    port map (
      opcode    => opcode,
      reg_write => reg_write,
      alu_src   => alu_src,
      alu_op    => alu_op,
      mem_write => mem_write,
      wb_sel    => wb_sel,
      imm_sel   => imm_sel,
      branch    => branch,
      jal       => jal,
      jalr      => jalr
    );

  u_alu : entity work.alu_decoder
    port map (
      alu_op   => alu_op,
      funct3   => funct3,
      funct7_5 => funct7_5,
      alu_ctrl => alu_ctrl
    );

end structural;