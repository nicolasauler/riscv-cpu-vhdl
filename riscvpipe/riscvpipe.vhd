library ieee;
use ieee.std_logic_1164.all;

entity riscvpipe is
    port(
        clk, rst:       in  std_logic
    );
end entity riscvpipe;

architecture struct of riscvpipe is

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

            -- control data
            memwrited:  in  std_logic;
            memtoregd:  in  std_logic; -- regsrc
            alucontrold:in  std_logic_vector(2 downto 0);
            alusrcd:    in  std_logic;
            pcsrc:      in  std_logic;
            regwrited:  in  std_logic;
            immsrcd:    in  std_logic_vector(1 downto 0); -- tell type of instr
            zero:       out std_logic; -- control pcsrc: do branch or +4

            instrd:     buffer  std_logic_vector(31 downto 0);

            -- hazard
            rs1e:       buffer  std_logic_vector(4 downto 0);
            rs2e:       buffer  std_logic_vector(4 downto 0);
            rde:        buffer  std_logic_vector(4 downto 0);
            rdm:        buffer  std_logic_vector(4 downto 0);
            rdw:        buffer  std_logic_vector(4 downto 0);
            regwritem:  buffer  std_logic;
            regwritew:  buffer  std_logic;
            memtoregw:  out     std_logic;

            stallf:     in std_logic;
            stalld:     in std_logic;
            flushd:     in std_logic;
            flushe:     in std_logic;
            forwardae:  in std_logic_vector(1 downto 0);
            forwardbe:  in std_logic_vector(1 downto 0)
        );
    end component datapath;

    component hazardunit
        port(
            -- register addresses
            rs1d:           in std_logic_vector(4 downto 0);
            rs1e:           in std_logic_vector(4 downto 0);
            rs2d:           in std_logic_vector(4 downto 0);
            rs2e:           in std_logic_vector(4 downto 0);
            rde:            in std_logic_vector(4 downto 0);
            rdm:            in std_logic_vector(4 downto 0);
            rdw:            in std_logic_vector(4 downto 0);

            -- control data
            pcsrc:          in std_logic;
            memtoregw:      in std_logic;
            regwritem:      in std_logic;
            regwritew:      in std_logic;

            -- hazard data
            stallf:         out std_logic;
            stalld:         out std_logic;

            flushd:         out std_logic;
            flushe:         out std_logic;

            -- forwarding mux selector
            forwardae:      out std_logic_vector(1 downto 0);
            forwardbe:      out std_logic_vector(1 downto 0)
        );
    end component hazardunit;

    signal s_instr:                                     std_logic_vector(31 downto 0);
    signal s_zero, s_memwrited, s_alusrcd, s_pcsrc, s_regwrited:     std_logic;
    signal s_regsrcd:                                   std_logic;
    signal s_immsrcd:                                   std_logic_vector(1 downto 0);
    signal s_alucontrold:                               std_logic_vector(2 downto 0);
    signal s_rs1e, s_rs2e, s_rde, s_rdm, s_rdw:         std_logic_vector(4 downto 0);
    signal s_memtoregw, s_regwritem, s_regwritew:       std_logic;
    signal s_stallf, s_stalld, s_flushd, s_flushe:      std_logic;
    signal s_forwardae, s_forwardbe:                    std_logic_vector(1 downto 0);
begin

cu: controlunit
port map(
    opcode      => s_instr(6 downto 0),
    funct7b5    => s_instr(30),
    funct3      => s_instr(14 downto 12),
    alucontrol  => s_alucontrold,
    zero        => s_zero,
    memtoreg    => s_regsrcd, -- regsrc
    we          => s_memwrited,
    alusrc      => s_alusrcd,
    pcsrc       => s_pcsrc,
    regwrite    => s_regwrited,
    immsrc      => s_immsrcd
);

dp: datapath
port map(
    clk         => clk,
    rst         => rst,
    memwrited   => s_memwrited,
    memtoregd   => s_regsrcd,
    alucontrold => s_alucontrold,
    alusrcd     => s_alusrcd,
    pcsrc       => s_pcsrc,
    regwrited   => s_regwrited,
    immsrcd     => s_immsrcd,
    zero        => s_zero,
    instrd      => s_instr,
    rs1e        => s_rs1e,
    rs2e        => s_rs2e,
    rde         => s_rde,
    rdm         => s_rdm,
    rdw         => s_rdw,
    regwritem   => s_regwritem,
    regwritew   => s_regwritew,
    memtoregw   => s_memtoregw,
    stallf      => s_stallf,
    stalld      => s_stalld,
    flushd      => s_flushd,
    flushe      => s_flushe,
    forwardae   => s_forwardae,
    forwardbe   => s_forwardbe
);

hu: hazardunit
port map(
    rs1d        => s_instr(19 downto 15),
    rs1e        => s_rs1e,
    rs2d        => s_instr(24 downto 20),
    rs2e        => s_rs2e,
    rde         => s_rde,
    rdm         => s_rdm,
    rdw         => s_rdw,
    pcsrc       => s_pcsrc,
    memtoregw   => s_memtoregw,
    regwritem   => s_regwritem,
    regwritew   => s_regwritew,
    stallf      => s_stallf,
    stalld      => s_stalld,
    flushd      => s_flushd,
    flushe      => s_flushe,
    forwardae   => s_forwardae,
    forwardbe   => s_forwardbe
);

end architecture struct;
