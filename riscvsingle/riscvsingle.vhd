library ieee;
use ieee.std_logic_1164.all;

entity riscvsingle is
    port(
        clk, rst:       in  std_logic;
        pc:             out std_logic_vector(31 downto 0);
        instr:          in  std_logic_vector(31 downto 0);
        we:             out std_logic;
        wd, alures:     out std_logic_vector(31 downto 0);
        rd:             in  std_logic_vector(31 downto 0)
    );
end entity riscvsingle;

architecture struct of riscvsingle is

    component controlunit
        port(
            opcode:     in  std_logic_vector(6 downto 0);

            memtoreg:   out std_logic; -- regsrc
            we:         out std_logic; -- memwrite: write enable
            alusrc:     out std_logic;
            pcsrc:      out std_logic;
            regwrite:   out std_logic;
            immsrc:     out std_logic_vector(1 downto 0); -- tell type of instr

            -- now things that are in the book outside of controlunit, but here is going to take part in it
            -- such as the alucontrol and the and gate to control multiplexor of PC source
            funct7b5:   in  std_logic; -- instruction[30]
            funct3:     in  std_logic_vector(2 downto 0); -- instruction[14-12]
            alucontrol: out std_logic_vector(2 downto 0);
            zero:       in  std_logic -- control pcsrc: do branch or +4
    );
    end component controlunit;

    component datapath
        port(
            clk, rst:   in  std_logic;
            instr:      in  std_logic_vector(31 downto 0);
            rd:         in  std_logic_vector(31 downto 0);

            memtoreg:   in  std_logic; -- regsrc
            alucontrol: in  std_logic_vector(2 downto 0);
            alusrc:     in  std_logic;
            pcsrc:      in  std_logic;
            regwrite:   in  std_logic;
            immsrc:     in  std_logic_vector(1 downto 0); -- tell type of instr

            pc:         out std_logic_vector(31 downto 0);
            zero:       out std_logic; -- control pcsrc: do branch or +4
            alures, wd: out std_logic_vector(31 downto 0)
        );
    end component datapath;

    signal s_zero, s_alusrc, s_pcsrc, s_regwrite:   std_logic;
    signal s_regsrc:                                std_logic;
    signal s_immsrc:                                std_logic_vector(1 downto 0);
    signal s_alucontrol:                            std_logic_vector(2 downto 0);

begin

cu: controlunit
port map(
    opcode      => instr(6 downto 0),
    funct7b5    => instr(30),
    funct3      => instr(14 downto 12),
    alucontrol  => s_alucontrol,
    zero        => s_zero,
    memtoreg    => s_regsrc, -- regsrc
    we          => we,
    alusrc      => s_alusrc,
    pcsrc       => s_pcsrc,
    regwrite    => s_regwrite,
    immsrc      => s_immsrc
);

dp: datapath
port map(
    clk         => clk,
    rst         => rst,
    instr       => instr,
    rd          => rd,
    memtoreg    => s_regsrc,
    alucontrol  => s_alucontrol,
    alusrc      => s_alusrc,
    pcsrc       => s_pcsrc,
    regwrite    => s_regwrite,
    immsrc      => s_immsrc,
    pc          => pc,
    zero        => s_zero,
    alures      => alures,
    wd          => wd
);

end architecture struct;
