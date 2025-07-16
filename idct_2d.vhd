library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipkg.all;

entity idct_2d is
    Port (
    clk,rst,start : in std_logic;
    x : in matrix_2d;
    y : out matrix_2d;
    done : out std_logic
     );
end idct_2d;

architecture Behavioral of idct_2d is
component idct_1d
port(
    clk,rst,start: in std_logic;
    x : in vect_1d;
    y : out vect_1d;
    done: out std_logic);
end component;


type state_type is (idle,row_p,row_w,col_p,col_w,finish);
signal state: state_type:=idle;
signal row_idx,col_idx: integer range 0 to 7:=0;

signal i_start:std_logic:='0';
signal i_done: std_logic:='0';
signal ip_done: std_logic:='0';
signal ir_done:std_logic:='0';

signal idct_in : vect_1d:=(others=>0);
signal idct_out:  vect_1d:=(others=>0);

signal buffer_rows: matrix_2d:=(others=>(others=>0));
signal result : matrix_2d:=(others=>(others=>0));

signal cycle_count: integer:=0;


function clamp(val:integer)
    return integer is
    begin
        if val<0 then
            return 0;
        elsif  val>255 then 
            return 255;
        else
            return val;
        end if;
     end function;

begin

y<=result when state = finish else (others=>(others=>0));
done<='1' when state =finish else '0';


idct_inst: idct_1d
port map(
        clk=>clk,
        rst=>rst,
        start=>i_start,
        x=>idct_in,
        y=>idct_out,
        done=>i_done);
        
process(clk)
begin
    if rising_edge(clk) then
        if rst='1' then 
        state<=idle;
        row_idx<=0;
        col_idx<=0;
        i_start<='0';
        ip_done<='0';
        ir_done<='0';
        buffer_rows<=(others=>(others=>0));
        result <=(others=>(others=>0));
        cycle_count<=0;
   else
         if state/= idle and state/=finish then
         cycle_count<=cycle_count+1;
         end if;
         
         if ip_done='0' and  i_done='1' then
            ir_done<='1';
         else
            ir_done<='0';
         end if;
         ip_done<=i_done;
         
         
         case state is 
         when idle=>
             if  start= '1' then
             row_idx<=0;
             cycle_count<=0;
             state<=row_p;
             end if;
             
             when row_p=>
             idct_in<=x(row_idx);
             i_start<='1';
             state<=row_w;
             
             
             when row_w=>
             if ir_done='1' then
             i_start<='0';
             buffer_rows(row_idx)<=idct_out;
             if row_idx < 7 then 
                row_idx<=row_idx+1;
                state<=row_p;
             else
                col_idx<=0;
                state<=col_p;
                end if;
            end if;
            
            
            when col_p => 
                 for i in 0 to 7 loop   
                    idct_in(i)<=buffer_rows(i)(col_idx);
                    end loop;
                    i_start<='1';
                    state<=col_w;
                    
           when col_w =>
             if ir_done='1' then
             i_start<='0';
             for i in 0 to 7 loop
                result(i)(col_idx)<=clamp(idct_out(i));
             end loop;
             if col_idx<7 then 
             col_idx<=col_idx+1;
             state<=col_p;
             else
             state<=finish;
             end if;
             end if;
             
             
             when finish=>
                if start= '0' then 
                state<=finish;
                end if;
             
            end case;
         end if;
    end if;
end process;
end Behavioral;
