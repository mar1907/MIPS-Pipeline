--Write First RAM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAMwr_first is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (15 downto 0);
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0));
end RAMwr_first;

architecture Behavioral of RAMwr_first is
type mem is array(0 to 255) of std_logic_vector(15 downto 0);
signal RAMmem: mem:=(
    X"8888",
    X"4444",
    X"2222",
    X"1111",
    others=>X"FFFF"
);
begin
    process(clk)
    variable s:std_logic_vector(15 downto 0);
    begin
        if rising_edge(clk) then
            if en='1' then
                if we='1' then
                    RAMmem(conv_integer(addr))<=di; 
                    s:=di;
                    do<=s;        
                else
                    do<=RAMmem(conv_integer(addr));
                end if;
            end if;
        end if;
    end process;

end Behavioral;
