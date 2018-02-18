--Mono Pulse Generator

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal S1:std_logic_vector(15 downto 0);
signal S2:std_logic;
signal S3:std_logic;
signal S4:std_logic;
begin

    C1:process(clk)
    begin
        if rising_edge(clk) then
            S1<=S1+1;
        end if;
    end process C1;
    
    R1:process(clk)
    begin
        if rising_edge(clk) then
            if S1="1111111111111111" then
                S2<=btn;
            end if;
        end if;
    end process R1;
    
    R2:process(clk)
    begin
        if rising_edge(clk) then
            S3<=S2;
        end if;
    end process R2;
    
    R3:process(clk)
        begin
            if rising_edge(clk) then
                S4<=S3;
            end if;
    end process R3;
    
    enable<=S3 and not(S4);

end Behavioral;