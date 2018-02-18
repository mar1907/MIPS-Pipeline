--Finite State Machine for TX (UART)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TX_FSM is
    Port ( TX_DATA : in STD_LOGIC_VECTOR (7 downto 0);
           TX_EN : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk:in std_logic;
           BAUD_EN : in STD_LOGIC;
           TX : out STD_LOGIC;
           TX_RDY : out STD_LOGIC);
end TX_FSM;

architecture Behavioral of TX_FSM is

type state_type is (s1, s2, s3, s4);
signal state : state_type;
signal BIT_CNT:std_logic_vector(2 downto 0);
signal count:std_logic_vector(2 downto 0);
begin
    process (clk, rst)
    begin
        if (rst ='1') then
            state <=s1;
            TX<='1'; TX_RDY<='1';
        elsif (clk='1' and clk'event) then
            if(BAUD_EN='1') then
            if count<"100" then
                case state is
                    when s1 => if TX_EN = '1' then
                                  state <= s2;
                                  TX<='0'; TX_RDY<='0';
                               else
                                  state <=s1;
                                  TX<='1'; TX_RDY<='1';
                               end if;
                    when s2 => state <= s3;
                               TX<=TX_DATA(conv_integer(BIT_CNT)); TX_RDY<='0';
                               BIT_CNT<="000";
                    when s3 => if conv_integer(BIT_CNT)<7 then
                                   state <= s3;
                                   TX<=TX_DATA(conv_integer(BIT_CNT)+1); TX_RDY<='0';
                                   BIT_CNT<=BIT_CNT+1;
                               else
                                   state <=s4;
                                   TX<='1'; TX_RDY<='0';
                              end if;
                    when s4 => state <= s1;
                               count<=count+1;
                               TX<='1'; TX_RDY<='1';
                    end case;
                end if;
                end if;
        end if;
    end process; 
end Behavioral;
