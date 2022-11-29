library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ifid is
    port(
        clk, rst:       in              std_logic;

        -- instructions
        instrf:         in              std_logic_vector(31 downto 0);
        instrd:         out             std_logic_vector(31 downto 0);

        -- program counter
        pcf:            in              std_logic_vector(31 downto 0);
        pcd:            out             std_logic_vector(31 downto 0);

        -- incremented pc
        pcplus4f:       in              std_logic_vector(31 downto 0);
        pcplus4d:       out             std_logic_vector(31 downto 0);
    
        -- hazard unit 
        stalld:         in              std_logic;
        flushd:         in              std_logic
    );
end entity ifid;

architecture asynchronous of ifid is

    signal s_instrf, s_pcf, s_pcplus4f: std_logic_vector(31 downto 0);

begin

    process(rst, instrf, pcf, pcplus4f, flushd)
    begin
        if (rst = '1') or (flushd = '1') then
            s_instrf    <= (others => '0');
            s_pcf       <= (others => '0');
            s_pcplus4f  <= (others => '0');
        else
            s_instrf    <= instrf;
            s_pcf       <= pcf;
            s_pcplus4f  <= pcplus4f;
        end if;
    end process;

    process(clk, stalld)
    begin
        if rising_edge(clk) and stalld = '1' then
            instrd      <= s_instrf;
            pcd         <= s_pcf;
            pcplus4d    <= s_pcplus4f;
        end if;
    end process;

end architecture asynchronous;
