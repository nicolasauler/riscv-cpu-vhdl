library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mewb is
    port(
        clk:            in              std_logic;

        -- result from alu
        aluresm:        in              std_logic_vector(31 downto 0);
        aluresw:        out             std_logic_vector(31 downto 0);

        -- read data from data memory
        readdm:         in              std_logic_vector(31 downto 0);
        readdw:         out             std_logic_vector(31 downto 0);

        -- destination register address
        rdm:            in              std_logic_vector(4 downto 0);
        rdw:            out             std_logic_vector(4 downto 0);

        -- incremented pc
        pcplus4m:       in              std_logic_vector(31 downto 0);
        pcplus4w:       out             std_logic_vector(31 downto 0);
    
        -- control data 
        memtoregm:      in              std_logic;
        memtoregw:      out             std_logic;
        regwritem:      in              std_logic;
        regwritew:      out             std_logic
    );
end entity mewb;

architecture asynchronous of mewb is

begin

    process(clk)
    begin
        if rising_edge(clk) then
            aluresw     <= aluresm;
            readdw      <= readdm;
            rdw         <= rdm;
            pcplus4w    <= pcplus4m;
            regwritew   <= regwritem;
            memtoregw   <= memtoregm;
        end if;
    end process;

end architecture asynchronous;
