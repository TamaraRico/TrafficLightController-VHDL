--Contador
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity contador is

port( 
	reset: in std_logic ;
	cout: out std_logic_vector (0 to 2);
	clk: in std_logic  );

end;

architecture arch_contador of contador is

signal count :std_logic_vector (0 to 2);

begin
  
  process (clk, reset) 
	begin
       
	 if (reset = '1') then
           
		 count <= (others=>'0');
       
	 elsif (rising_edge(clk)) then
           
               
			 count <= count + 1;
                 
	 end if;
	cout <= count;
   
 end process;
end architecture arch_contador;
