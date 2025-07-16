
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package ipkg is

constant N:integer:=8;

subtype pixel is integer range -4096 to 4095;
type vect_1d is array(0 to N-1) of pixel;
type matrix_2d is array(0 to N-1) of vect_1d;
type i_array is array(0 to N-1) of integer;
type cos_table1 is array(0 to N-1,0 to N-1) of integer;

constant c: i_array:=(
 0=>181,1=>256,2=>256,3=>256,4=>256,5=>256,6=>256,7=>256);
 
 constant cos_table: cos_table1:=(
 (256,354,340,312,256,181,98,50),
 (256,312,181,50,-98,-237,-340,-354),
 (256,181,-98,-354,-256,50,340,312),
 (256,50,-340,-181,256,312,-98,-354),
 (256,-50,-340,181,256,-312,-98,354),
 (256,-181,-98,354,-256,-50,340,-312),
 (256,-312,181,-50,98,237,-340,354),
 (256,-354,340,-312,256,-181,98,-50));
end ipkg;

