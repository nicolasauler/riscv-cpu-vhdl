library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exme is
    port(
        clk:            in              std_logic;

        -- result from alu
        alurese:        in              std_logic_vector(31 downto 0);
        aluresm:        out             std_logic_vector(31 downto 0);

        -- writedata
        wde:            in              std_logic_vector(31 downto 0);
        wdm:            out             std_logic_vector(31 downto 0);

        -- destination register address
        rde:            in              std_logic_vector(4 downto 0);
        rdm:            out             std_logic_vector(4 downto 0);

        -- incremented pc
        pcplus4e:       in              std_logic_vector(31 downto 0);
        pcplus4m:       out             std_logic_vector(31 downto 0);
    
        -- control data 
        memwritee:      in              std_logic;
        memwritem:      out             std_logic;
        memtorege:      in              std_logic;
        memtoregm:      out             std_logic;
        regwritee:      in              std_logic;
        regwritem:      out             std_logic
    );
end entity exme;

architecture asynchronous of exme is

begin

    process(clk)
    begin
        if rising_edge(clk) then
            aluresm     <= alurese;
            wdm         <= wde;
            rdm         <= rde;
            pcplus4m    <= pcplus4e;
            regwritem   <= regwritee;
            memtoregm   <= memtorege;
            memwritem   <= memwritee;
        end if;
    end process;

end architecture asynchronous;
