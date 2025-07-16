library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipkg.all;

entity jpeg_test is
end jpeg_test;

architecture Behavioral of jpeg_test is

signal clk:std_logic:='0';
signal rst:std_logic:='1';
signal start:std_logic:='0';
signal x:matrix_2d:=(others=>(others=>0));
signal y:matrix_2d;
signal done:std_logic;

constant clk_period:time:=10ns;
begin
clk_process:process
begin
    while true loop
    clk<='0';
    wait for clk_period/2;
    clk<='1';
    wait for clk_period/2;
    end loop;
end process;

uut:entity work.idct_2d
port map(
        clk=>clk,
        rst=>rst,
        start=>start,
        x=>x,
        y=>y,
        done=>done);
        
stim_proc:process
begin
wait for 20 ns;
rst<='0';
wait for 20 ns;

x<=(others=>(others=>0));
x(0)(0)<=1024;

wait for 10 ns;
start<='1';
wait for clk_period;
start<='0';

wait until done='1';
wait for clk_period;

for i in 0 to 7 loop
    for j in 0 to 7 loop
    report "y(" &integer'image(i)&")("&integer'image(j)&") = "&integer'image(y(i)(j));
    end loop;
end loop;

report"simulation completed.";
wait;
end process;
end Behavioral;
