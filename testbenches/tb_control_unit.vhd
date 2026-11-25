library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rv32i_pkg.all;

-- Unit test of the control unit: every row of Table 4 (don't-cares are '-') and the ALU decoder (Table 5).
entity tb_control_unit is
end entity tb_control_unit;

architecture sim of tb_control_unit is
  signal opcode : std_logic_vector(6 downto 0) := (others => '0');
  signal funct3 : std_logic_vector(2 downto 0) := (others => '0');
  signal funct7_5 : std_logic := '0';
  signal reg_write, alu_src, mem_write, branch, jal, jalr : std_logic;
  signal alu_ctrl, wb_sel, imm_sel : std_logic_vector(2 downto 0);
begin
  dut : entity work.control_unit
    port map (opcode => opcode, funct3 => funct3, funct7_5 => funct7_5, reg_write => reg_write,
              alu_src => alu_src, alu_ctrl => alu_ctrl, mem_write => mem_write, wb_sel => wb_sel,
              imm_sel => imm_sel, branch => branch, jal => jal, jalr => jalr);

  process
    variable errors, checks : natural := 0;
    procedure test(name : string; op : std_logic_vector(6 downto 0); f3 : std_logic_vector(2 downto 0); f7 : std_logic;
                   rw, asrc, mw : std_logic; wbs, ims : std_logic_vector(2 downto 0); br, j, jr : std_logic;
                   actl : std_logic_vector(2 downto 0)) is
    begin
      opcode <= op; funct3 <= f3; funct7_5 <= f7; wait for 1 ns;
      checks := checks + 1;
      if not (std_match(reg_write, rw) and std_match(alu_src, asrc) and std_match(mem_write, mw) and
              std_match(wb_sel, wbs) and std_match(imm_sel, ims) and std_match(branch, br) and
              std_match(jal, j) and std_match(jalr, jr) and std_match(alu_ctrl, actl)) then
        errors := errors + 1;
        report name & ": reg_write=" & std_logic'image(reg_write) & " alu_src=" & std_logic'image(alu_src) &
               " mem_write=" & std_logic'image(mem_write) & " wb_sel=" & to_string(wb_sel) & " imm_sel=" & to_string(imm_sel) &
               " branch=" & std_logic'image(branch) & " jal=" & std_logic'image(jal) & " jalr=" & std_logic'image(jalr) &
               " alu_ctrl=" & to_string(alu_ctrl) severity error;
      end if;
    end procedure;
  begin
    --            name    opcode     f3     f7   rw  asrc mw  wb_sel   imm_sel  br  jal jalr alu_ctrl
    test("add",   OP_RTYPE, "000", '0', '1','0','0', WB_ALU, "---", '0','0','0', ALU_ADD);
    test("sub",   OP_RTYPE, "000", '1', '1','0','0', WB_ALU, "---", '0','0','0', ALU_SUB);
    test("and",   OP_RTYPE, "111", '0', '1','0','0', WB_ALU, "---", '0','0','0', ALU_AND);
    test("or",    OP_RTYPE, "110", '0', '1','0','0', WB_ALU, "---", '0','0','0', ALU_OR);
    test("xor",   OP_RTYPE, "100", '0', '1','0','0', WB_ALU, "---", '0','0','0', ALU_XOR);
    test("slt",   OP_RTYPE, "010", '0', '1','0','0', WB_ALU, "---", '0','0','0', ALU_SLT);
    test("addi",  OP_ITYPE, "000", '0', '1','1','0', WB_ALU, IMM_I, '0','0','0', ALU_ADD);
    test("addi (negative immediate, instr bit 30 = 1)", OP_ITYPE, "000", '1', '1','1','0', WB_ALU, IMM_I, '0','0','0', ALU_ADD);
    test("andi",  OP_ITYPE, "111", '0', '1','1','0', WB_ALU, IMM_I, '0','0','0', ALU_AND);
    test("ori",   OP_ITYPE, "110", '0', '1','1','0', WB_ALU, IMM_I, '0','0','0', ALU_OR);
    test("slli",  OP_ITYPE, "001", '0', '1','1','0', WB_ALU, IMM_I, '0','0','0', ALU_SLL);
    test("srli",  OP_ITYPE, "101", '0', '1','1','0', WB_ALU, IMM_I, '0','0','0', ALU_SRL);
    test("lw",    OP_LOAD,  "010", '0', '1','1','0', WB_MEM, IMM_I, '0','0','0', ALU_ADD);
    test("sw",    OP_STORE, "010", '0', '0','1','1', "---",  IMM_S, '0','0','0', ALU_ADD);
    test("beq",   OP_BRANCH,"000", '0', '0','-','0', "---",  IMM_B, '1','0','0', "---");
    test("bne",   OP_BRANCH,"001", '0', '0','-','0', "---",  IMM_B, '1','0','0', "---");
    test("blt",   OP_BRANCH,"100", '0', '0','-','0', "---",  IMM_B, '1','0','0', "---");
    test("jal",   OP_JAL,   "000", '0', '1','-','0', WB_PC4, IMM_J, '0','1','0', "---");
    test("jalr",  OP_JALR,  "000", '0', '1','1','0', WB_PC4, IMM_I, '0','0','1', ALU_ADD);
    test("lui",   OP_LUI,   "000", '0', '1','-','0', WB_LUI, IMM_U, '0','0','0', "---");
    test("auipc", OP_AUIPC, "000", '0', '1','-','0', WB_AUIPC, IMM_U, '0','0','0', "---");
    test("unknown opcode 0000000 acts as NOP", "0000000", "000", '0', '0','-','0', "---", "---", '0','0','0', "---");
    test("unknown opcode 1111111 acts as NOP", "1111111", "111", '1', '0','-','0', "---", "---", '0','0','0', "---");
    if errors = 0 then report "tb_control_unit: PASSED (" & integer'image(checks) & " checks)" severity note;
    else report "tb_control_unit: FAILED (" & integer'image(errors) & " errors)" severity failure; end if;
    wait;
  end process;
end architecture sim;
