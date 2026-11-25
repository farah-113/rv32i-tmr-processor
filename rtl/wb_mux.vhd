----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 09:38:33 PM
-- Design Name: 
-- Module Name: wb_mux - Behavioral
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

entity wb_mux is
  port (
    alu_result : in  std_logic_vector(31 downto 0);
    mem_rdata  : in  std_logic_vector(31 downto 0);
    pc_plus4   : in  std_logic_vector(31 downto 0);
    imm_u      : in  std_logic_vector(31 downto 0);   -- LUI
    pc_target  : in  std_logic_vector(31 downto 0);   -- AUIPC: PC + imm
    wb_sel     : in  std_logic_vector(2 downto 0);
    wb_data    : out std_logic_vector(31 downto 0)
  );
end entity wb_mux;

architecture behavioural of wb_mux is
begin

  with wb_sel select
    wb_data <= alu_result      when WB_ALU,
               mem_rdata       when WB_MEM,
               pc_plus4        when WB_PC4,
               imm_u           when WB_LUI,
               pc_target       when WB_AUIPC,
               (others => '0') when others;

end behavioural;