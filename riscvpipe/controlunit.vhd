library ieee;
use ieee.std_logic_1164.all;

entity controlunit is
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
end entity controlunit;

architecture struct of controlunit is

    component maindec
        port(
            opcode:     in  std_logic_vector(6 downto 0); 
            
            memtoreg:   out std_logic;
            aluop:      out std_logic_vector(1 downto 0);
            we:         out std_logic;
            alusrc:     out std_logic; 
            branch:     out std_logic;
            regwrite:   out std_logic;
            immsrc:     out std_logic_vector(1 downto 0) -- tell type of instr
        );
    end component maindec;

    component aludec
        port(
            aluop:      in std_logic_vector(1 downto 0);
            funct3:     in std_logic_vector(2 downto 0);
            funct7b5:   in std_logic;
            alucontrol: out std_logic_vector(2 downto 0)
        );
    end component aludec;

    signal s_branch: std_logic;
    signal s_aluop: std_logic_vector(1 downto 0);

begin

    md: maindec
    port map(
        opcode      => opcode,
        memtoreg    => memtoreg,
        aluop       => s_aluop,
        we          => we,
        alusrc      => alusrc,
        branch      => s_branch,
        regwrite    => regwrite,
        immsrc      => immsrc
    );

    ad: aludec
    port map(
        aluop       => s_aluop,
        funct3      => funct3,
        funct7b5    => funct7b5,
        alucontrol  => alucontrol
    );

    pcsrc <= (s_branch and zero);

end architecture struct;
