library ieee;
use ieee.std_logic_1164.all;
use work.rv32i_pkg.all;
use work.vectors_pkg.all;

-- Unit test of the ALU with 1888 vectors computed by Python (all 8 operations,
-- corner cases: wrap-around, signed compare, shifts by 0/31, shift amount taken from b(4:0)).
entity tb_alu is
end entity tb_alu;

architecture sim of tb_alu is
  signal a, b, y : std_logic_vector(31 downto 0) := (others => '0');
  signal op      : std_logic_vector(2 downto 0) := (others => '0');
begin
  dut : entity work.alu port map (a => a, b => b, alu_ctrl => op, result => y);

  process
    variable errors : natural := 0;
  begin
    for i in ALU_VECTORS'range loop
      op <= ALU_VECTORS(i).op;
      a  <= ALU_VECTORS(i).a;
      b  <= ALU_VECTORS(i).b;
      wait for 1 ns;
      if y /= ALU_VECTORS(i).y then
        errors := errors + 1;
        report "ALU op=" & to_string(op) & " a=" & to_hstring(a) & " b=" & to_hstring(b) &
               " got " & to_hstring(y) & " expected " & to_hstring(ALU_VECTORS(i).y) severity error;
      end if;
    end loop;
    if errors = 0 then
      report "tb_alu: PASSED (" & integer'image(ALU_VECTORS'length) & " vectors)" severity note;
    else
      report "tb_alu: FAILED (" & integer'image(errors) & " errors)" severity failure;
    end if;
    wait;
  end process;
end architecture sim;
