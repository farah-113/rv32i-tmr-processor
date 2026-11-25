library ieee;
use ieee.std_logic_1164.all;
use work.rv32i_pkg.all;
use work.vectors_pkg.all;

-- Unit test of the immediate generator: I, S, B, U and J immediates, positive and
-- negative, including the extreme values; the other instruction fields are random.
entity tb_imm_gen is
end entity tb_imm_gen;

architecture sim of tb_imm_gen is
  signal instr, imm : std_logic_vector(31 downto 0) := (others => '0');
  signal sel        : std_logic_vector(2 downto 0) := (others => '0');
begin
  dut : entity work.imm_gen port map (instr => instr, imm_sel => sel, imm => imm);

  process
    variable errors : natural := 0;
  begin
    for i in IMM_VECTORS'range loop
      sel   <= IMM_VECTORS(i).sel;
      instr <= IMM_VECTORS(i).instr;
      wait for 1 ns;
      if imm /= IMM_VECTORS(i).y then
        errors := errors + 1;
        report "imm_sel=" & to_string(sel) & " instr=" & to_hstring(instr) &
               " got " & to_hstring(imm) & " expected " & to_hstring(IMM_VECTORS(i).y) severity error;
      end if;
    end loop;
    -- the examples of Table 3 of the report
    sel <= IMM_I; instr <= x"00A00293"; wait for 1 ns;                       -- addi x5, x0, 10
    if imm /= x"0000000A" then errors := errors + 1; report "addi example" severity error; end if;
    sel <= IMM_B; instr <= x"00208463"; wait for 1 ns;                       -- beq x1, x2, 8
    if imm /= x"00000008" then errors := errors + 1; report "beq example" severity error; end if;
    sel <= IMM_J; instr <= x"010000EF"; wait for 1 ns;                       -- jal x1, 16
    if imm /= x"00000010" then errors := errors + 1; report "jal example" severity error; end if;
    sel <= IMM_U; instr <= x"123452B7"; wait for 1 ns;                       -- lui x5, 0x12345
    if imm /= x"12345000" then errors := errors + 1; report "lui example" severity error; end if;
    sel <= IMM_S; instr <= x"0020A423"; wait for 1 ns;                       -- sw x2, 8(x1)
    if imm /= x"00000008" then errors := errors + 1; report "sw example" severity error; end if;
    -- unused imm_sel codes give 0
    sel <= "111"; instr <= x"FFFFFFFF"; wait for 1 ns;
    if imm /= x"00000000" then errors := errors + 1; report "unused imm_sel" severity error; end if;
    if errors = 0 then
      report "tb_imm_gen: PASSED (" & integer'image(IMM_VECTORS'length + 6) & " checks)" severity note;
    else
      report "tb_imm_gen: FAILED (" & integer'image(errors) & " errors)" severity failure;
    end if;
    wait;
  end process;
end architecture sim;
