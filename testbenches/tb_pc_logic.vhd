library ieee;
use ieee.std_logic_1164.all;
use work.rv32i_pkg.all;

-- Unit test of the PC logic: adder, branch comparator (with taken), next-PC mux, PC register.
entity tb_pc_logic is
end entity tb_pc_logic;

architecture sim of tb_pc_logic is
  signal clk, rst, done : std_logic := '0';
  signal fin : boolean := false;
  signal add_a, add_b, add_s : std_logic_vector(31 downto 0) := (others => '0');
  signal ra, rb : std_logic_vector(31 downto 0) := (others => '0');
  signal f3 : std_logic_vector(2 downto 0) := (others => '0');
  signal br, eq, lt, taken : std_logic := '0';
  signal pc4, tgt, alur, pcn : std_logic_vector(31 downto 0) := (others => '0');
  signal jal, jalr, tk : std_logic := '0';
  signal d, q : std_logic_vector(31 downto 0) := (others => '0');
begin
  u_add : entity work.adder port map (a => add_a, b => add_b, sum => add_s);
  u_cmp : entity work.branch_comparator
    port map (rs1_data => ra, rs2_data => rb, funct3 => f3, branch => br, eq => eq, lt => lt, taken => taken);
  u_npc : entity work.next_pc_mux
    port map (pc_plus4 => pc4, pc_target => tgt, alu_result => alur, jal => jal, jalr => jalr, taken => tk, pc_next => pcn);
  u_pc : entity work.pc_register port map (clk => clk, rst => rst, pc_next => d, pc => q);

  clk <= not clk after 5 ns when not fin else '0';

  process
    variable errors, checks : natural := 0;
    procedure check(got, expected : std_logic_vector(31 downto 0); msg : string) is
    begin
      checks := checks + 1;
      if got /= expected then errors := errors + 1;
        report msg & ": got " & to_hstring(got) & " expected " & to_hstring(expected) severity error; end if;
    end procedure;
    procedure check1(got, expected : std_logic; msg : string) is
    begin
      checks := checks + 1;
      if got /= expected then errors := errors + 1; report msg & " wrong" severity error; end if;
    end procedure;
    -- comparator: eq, lt, taken for a given branch type
    procedure cmp(a, b : std_logic_vector(31 downto 0); f : std_logic_vector(2 downto 0); bran : std_logic;
                  e, l, t : std_logic; msg : string) is
    begin
      ra <= a; rb <= b; f3 <= f; br <= bran; wait for 1 ns;
      check1(eq, e, msg & " eq"); check1(lt, l, msg & " lt"); check1(taken, t, msg & " taken");
    end procedure;
    procedure npc(j, jr, t : std_logic; expected : std_logic_vector(31 downto 0); msg : string) is
    begin
      jal <= j; jalr <= jr; tk <= t; wait for 1 ns; check(pcn, expected, msg);
    end procedure;
  begin
    add_a <= x"00000010"; add_b <= x"00000004"; wait for 1 ns; check(add_s, x"00000014", "pc + 4");
    add_a <= x"FFFFFFFC"; add_b <= x"00000004"; wait for 1 ns; check(add_s, x"00000000", "wrap-around");
    add_a <= x"00000100"; add_b <= x"FFFFFFF0"; wait for 1 ns; check(add_s, x"000000F0", "pc + negative offset");

    cmp(x"00000005", x"00000005", F3_BEQ, '1', '1','0','1', "beq equal");
    cmp(x"00000005", x"00000003", F3_BEQ, '1', '0','0','0', "beq different");
    cmp(x"00000005", x"00000003", F3_BNE, '1', '0','0','1', "bne different");
    cmp(x"00000005", x"00000005", F3_BNE, '1', '1','0','0', "bne equal");
    cmp(x"00000003", x"00000005", F3_BLT, '1', '0','1','1', "blt 3 < 5");
    cmp(x"00000005", x"00000003", F3_BLT, '1', '0','0','0', "blt 5 < 3");
    cmp(x"FFFFFFFF", x"00000001", F3_BLT, '1', '0','1','1', "blt -1 < 1 (signed)");
    cmp(x"00000001", x"FFFFFFFF", F3_BLT, '1', '0','0','0', "blt 1 < -1 (signed)");
    cmp(x"80000000", x"7FFFFFFF", F3_BLT, '1', '0','1','1', "blt min < max");
    cmp(x"00000005", x"00000005", F3_BEQ, '0', '1','0','0', "branch = 0: never taken");
    cmp(x"00000005", x"00000005", "010",  '1', '1','0','0', "unknown funct3: not taken");

    pc4 <= x"00000024"; tgt <= x"00000100"; alur <= x"000000A5";
    npc('0','0','0', x"00000024", "sequential");
    npc('0','0','1', x"00000100", "branch taken");
    npc('1','0','0', x"00000100", "jal");
    npc('0','1','0', x"000000A4", "jalr clears bit 0");
    npc('1','1','1', x"000000A4", "jalr has priority");

    rst <= '1'; d <= x"00000040"; wait until rising_edge(clk); wait for 1 ns;
    check(q, x"00000000", "PC after reset");
    rst <= '0'; d <= x"00000044"; wait until rising_edge(clk); wait for 1 ns;
    check(q, x"00000044", "PC loads pc_next");
    if errors = 0 then report "tb_pc_logic: PASSED (" & integer'image(checks) & " checks)" severity note;
    else report "tb_pc_logic: FAILED (" & integer'image(errors) & " errors)" severity failure; end if;
    fin <= true;
    wait;
  end process;
end architecture sim;
