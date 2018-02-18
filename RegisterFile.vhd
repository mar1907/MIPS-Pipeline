--Register File

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegisterFile is
    Port ( clk : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
type mem is array(0 to 15) of std_logic_vector(15 downto 0);
signal REGmem: mem:=(
    "0000000000000010",
    "0000000000000011",
    "0000000000000100",
    "0000000000000101",
    "0000000000000110",
    "0000000000000111",
    others =>"0000000000000001"
);
begin
    process(clk)
    begin
        if falling_edge(clk) then
            if RegWr='1' then
                REGmem(conv_integer(WA))<=WD;
            end if;
        end if;
    end process;
    RD1<=REGmem(conv_integer(RA1));
    RD2<=REGmem(conv_integer(RA2));

end Behavioral;
