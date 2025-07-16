library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipkg.all;

entity idct_1d is
    port(clk,rst,start : in std_logic;
         x : in vect_1d;
         y : out vect_1d;
         done: out std_logic);
end entity;

architecture Behavioral of idct_1d is
type state_type is (idle,calc1,next1,done1);
signal state: state_type:=idle;

signal u: integer range 0 to 7:=0;
signal v: integer range 0 to 7:=0;
signal acc :integer :=0;
signal y_reg:vect_1d:=(others=>0);

begin
process(clk)
begin 
    if rising_edge(clk) then
    if rst='1' then
     state<=idle;
     u<=0;
     v<=0;
     acc<=0;
     y_reg<=(others=>0);
     y<=(others=>0);
     done<='0';
   else
        case state is 
        when idle =>
        done<='0';
        if start='1' then
        u<=0;
        v<=0;
        acc<=0;
        state<=calc1;
        end if;
        
        
        when calc1=>
        if v<8 then
        acc <= acc+c(v)*x(v)*cos_table(u,v);
        v<=v+1;
        else
        y_reg(u)<=acc/131072;
        state<=next1;
        end if;
        
        when next1=>
        if u<7 then
        u<=u+1;
        v<=0;
        acc<=0;
        state<=calc1;
        else
        y<=y_reg;
        done<='1';
        state<=done1;
        end if;
        
        when done1=>
        if start='0' then
        done<='0';
        state<=idle;
        end if;
        end case;
      end if;
    end if;
end process;
end Behavioral;
