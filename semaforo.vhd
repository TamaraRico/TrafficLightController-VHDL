--SEMAFORO

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity semaforo is
port(
  sensores:in std_logic_vector(3 downto 0);--sensores
  clk: in std_logic;
  count: in std_logic_vector(0 to 2);
  reset: out std_logic;
  NS: out std_logic_vector(0 to 2);--salida semaforo NS
  EO: out std_logic_vector(0 to 2));--salida semaforo EO
end semaforo;

architecture arch_semaforo of semaforo is

begin

state_trans:
	process(clk)
	begin
	  if(clk'event and clk='1') then

		--definir la maquina de estados                 
	          case sensores is 
		--este orden esta determinado por los números a la derecha de la tabla
	          when "0000"|"0100"|"1000"|"1100" => 
			if(NS = "001") then -- si el semaforo NS no esta en rojo
				EO <= "100"; NS <= "010";
				reset <= '1';
			else
				EO <= "001"; NS <= "100";
				reset <= '1';
			end if;
	          
		  when "1111"|"1101"|"1110"|"0101"|"0110"|"1001"|"1010" => 
			case EO is
				when "001" =>-- si EO es verde
					EO <= "001"; NS <= "100";
					reset <= '0';
					if(count = "100") then --si pasaron 20 segundos cambia a amarillo
						EO <= "010"; NS <= "100"; 
						reset <= '1';
					end if;
				when "010" => --si EO es amarillo
					EO <= "100"; NS <= "001";
					reset <= '0';	
				when "100"=>--si  EO es rojo
					if(count < "001") then
						EO <= "100"; NS <= "001";
						reset <= '0';
					elsif(count = "001")then --si pasaron 5 segundos cambia a amarillo
						EO <= "100"; NS <= "010";
						reset <= '0';
					else
						EO <= "001"; NS <= "100";
						reset <= '1';
					end if;
			end case;
			
	          when "1011"|"0111" =>               
			case EO is
				when "001" =>-- si es verde
					EO <= "001"; NS <= "100";
					reset <= '0';
					if(count = "100") then --si pasaron 20 segundos cambia a amarillo
						EO <= "010"; NS <= "100";
						reset <= '1';
					end if;
				when "010" => --si es amarillo
					EO <= "100"; NS <= "001";
					reset <= '0';	
				when "100"=>--si es rojo
					if(count < "010") then
						EO <= "100"; NS <= "001";
						reset <= '0';
					elsif(count = "010")then --si pasaron 10 segundos cambia a amarillo
						EO <= "100"; NS <= "010";
						reset <= '0';
					else
						EO <= "001"; NS <= "100";
						reset <= '1';
					end if;
			end case;
	          
		  when "0001"|"0011"|"0010" => 	  
			case EO is --si el semaforo EO no esta en rojo
		                when "001" => EO <= "010"; NS <= "100";
		                when "010" => EO <= "100"; NS <= "001";
		                when "100" => EO <= "100"; NS <= "001";
	                end case;
			reset <= '1';
	                
	          end case;

  end if;

end process state_trans;
end arch_semaforo;

