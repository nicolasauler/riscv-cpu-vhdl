library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity idex is
    port(
        clk:            in              std_logic;

        -- register content
        rd1d:           in              std_logic_vector(31 downto 0);
        rd1e:           out             std_logic_vector(31 downto 0);
        rd2d:           in              std_logic_vector(31 downto 0);
        rd2e:           out             std_logic_vector(31 downto 0);

        -- register addresses
        rs1d:           in              std_logic_vector(4 downto 0);
        rs1e:           out             std_logic_vector(4 downto 0);
        rs2d:           in              std_logic_vector(4 downto 0);
        rs2e:           out             std_logic_vector(4 downto 0);
        -- destination register address
        rdd:            in              std_logic_vector(4 downto 0);
        rde:            out             std_logic_vector(4 downto 0);

        -- immediate field
        immextd:        in              std_logic_vector(31 downto 0);
        immexte:        out             std_logic_vector(31 downto 0);

        -- program counter
        pcd:            in              std_logic_vector(31 downto 0);
        pce:            out             std_logic_vector(31 downto 0);

        -- incremented pc
        pcplus4d:       in              std_logic_vector(31 downto 0);
        pcplus4e:       out             std_logic_vector(31 downto 0);
    
        -- hazard unit
        flushe:         in              std_logic;

        -- control
        memwrited:      in              std_logic;
        memwritee:      out             std_logic;
        memtoregd:      in              std_logic;
        memtorege:      out             std_logic;
        regwrited:      in              std_logic;
        regwritee:      out             std_logic;
        alucontrold:    in              std_logic_vector(2 downto 0);
        alucontrole:    out             std_logic_vector(2 downto 0);
        alusrcd:        in              std_logic;
        alusrce:        out             std_logic
    );
end entity idex;

architecture asynchronous of idex is

begin

    process(clk, flushe)
    begin
        if flushe = '1' then
            -- conventional data
            rd1e        <= (others => '0');
            rd2e        <= (others => '0');
            rde         <= (others => '0');
            immexte     <= (others => '0');
            pce         <= (others => '0');
            pcplus4e    <= (others => '0');

            -- control data
            alucontrole <= (others => '0');
            regwritee   <= '0';
            memtorege   <= '0';
            alusrce     <= '0';

            -- hazard data (forwarding)
            rs1e        <= (others => '0');
            rs2e        <= (others => '0');
        elsif rising_edge(clk) then
            -- conventional data
            rd1e        <= rd1d;
            rd2e        <= rd2d;
            rde         <= rdd;
            immexte     <= immextd;
            pce         <= pcd;
            pcplus4e    <= pcplus4d;

            -- control data
            memwritee   <= memwrited;
            regwritee   <= regwrited;
            memtorege   <= memtoregd;
            alucontrole <= alucontrold;
            alusrce     <= alusrcd;

            -- hazard data (forwarding)
            rs1e        <= rs1d;
            rs2e        <= rs2d;
        end if;
    end process;

end architecture asynchronous;
