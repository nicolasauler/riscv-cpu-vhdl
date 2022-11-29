library ieee;
use ieee.std_logic_1164.all;

entity aludec is
    port(
        aluop:      in std_logic_vector(1 downto 0);
        funct3:     in std_logic_vector(2 downto 0);
        funct7b5:   in std_logic;
        alucontrol: out std_logic_vector(2 downto 0)
    );
end entity aludec;

architecture behavioural of aludec is

begin

    process(funct7b5, funct3, aluop)
    begin
        case aluop is
            when "00"           =>      alucontrol <= "010"; -- lw or sw: add
            when "01"           =>      alucontrol <= "110"; -- beq: sub
            when others         => -- r-format: add, sub, and, or
                case funct3 is
                    when "000"  =>  if funct7b5 = '1' then
                                        alucontrol <= "110"; -- sub
                                    else
                                        alucontrol <= "010"; -- add
                                    end if;
                    when "111"  =>      alucontrol <= "000"; -- and
                    when "110"  =>      alucontrol <= "001"; -- or
                    when others =>      alucontrol <= "---"; -- unknown
                end case;
        end case;
    end process;

end architecture behavioural;
