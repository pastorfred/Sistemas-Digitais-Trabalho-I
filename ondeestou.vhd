---------------------------------------------------------------------------------------------------------
-- TRABALHO 1 - CIRCUITOS DIGITAIS
-- AUTHORS: Leonardo Chou da Rosa
-- DATE: 2/2023
---------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ondeestou is
   port (
      clock: in STD_LOGIC;
      reset: in STD_LOGIC;
      ---- interface para pedir localização
      x, y:   in STD_LOGIC_VECTOR (5 downto 0);
      achar:  in STD_LOGIC;
      prog:   in STD_LOGIC;
      ---- interface com a memória
      address:  out STD_LOGIC_VECTOR (11 downto 0);
      ponto:     in STD_LOGIC;
      ---- interface com o resultado da localização
      fim:     out STD_LOGIC;
      sala:    out STD_LOGIC_VECTOR (3 downto 0)
      ); 
end ondeestou;
 

architecture ondeestou of ondeestou is

  type coord is record
    x:    STD_LOGIC_VECTOR (5 downto 0);      
    y:    STD_LOGIC_VECTOR (5 downto 0);
  end record;
  --- definição do array para armazenar as coordenadas das salas 
  constant N_SALAS: integer := 8;
  type room is array(0 to N_SALAS) of coord ;
  signal salas : room ; 
  -- máquina de estados
  type states is (init, set, searchx0, searchx1, searchy0, searchy1, wallhor1, wallhor2, wallver1, wallver2, found, soma, ending);
  signal EA, PE: states;
  signal xbusca, ybusca, x0, y0, x1, y1, deltax, deltay: std_logic_vector (5 downto 0);
  signal check_sala, cont_sala, count : std_logic_vector (3 downto 0);
begin
   ----  coordendas das salas ----------------------------------------------------------------
   process (reset, clock)
   begin
      if reset='1' then 
            cont_sala <= (others=>'0');
      elsif clock'event and clock='1' then
            if  prog='1' then
               salas(conv_integer(cont_sala)).x <= x;
               salas(conv_integer(cont_sala)).y <= y;
               if cont_sala<N_SALAS then
                     cont_sala <= cont_sala + 1;
               end if;
            end if;
      end if;
   end process;

   ---- acesso à memória externa ----------------------------------------------------------------------
   address <=  y & xbusca when EA <= searchx0 else -- o address recebe o valor y e o valor x dinâmico (indo para esquerda) quando está no estado searchx0
               y & xbusca when EA <= searchx1 else -- o address recebe o valor y e o valor x dinâmico (indo para direita) quando está no estado searchx1
               ybusca & x when EA <= searchy0 else -- o address recebe o valor y dinâmico (indo para baixo) e o valor x quando está no estado searchy0
               ybusca & x when EA <= searchy1 else -- o address recebe o valor y dinâmico (indo para cima) e o valor x quando está no estado searchy1
               y0 & xbusca when EA <= wallhor1 else -- o address recebe o valor de y0 e o x dinâmico (de x0 até x1) quando está no estado wallhor1
               y1 & xbusca when EA <= wallhor2 else -- o address recebe o valor de y1 e o x dinâmico (de x0 até x1) quando está no estado wallhor2
               ybusca & x0 when EA <= wallver1 else -- o address recebe o valor de y dinâmico (de y0 até y1) e o x0 quando está no estado wallver1
               ybusca & x1 when EA <= wallver2 else -- o address recebe o valor de y dinânico (de y0 até y1) e o x1 quando está no estado wallver2
               (others=>'0'); -- em outros casos (estados diferentes), o address é zerado

   ----  máquina de estados de controle ---------------------------------------------------------------
   process (reset, clock)
   begin
      if reset='1' then 
         EA <= init; -- o estado 'default' é init
      elsif clock'event and clock='1' then
         EA <= PE; -- a cada subida de clock, o estado atual vira o próximo estado
      end if;
   end process;

   ---- processo para definir o proximo estado --------------------------------------------------------
   process (achar, EA, ponto, check_sala, xbusca, ybusca)
   begin
      case EA is
         when init => if achar = '1' then PE <= set; end if; -- durante o estado init, se achar = '1' o estado muda para o estado set
         
         when set => PE <= searchx0; -- durante o estado set, o próximo estado é o estado searchx0
         
         when searchx0 => 
         if xbusca = "000000" and ponto = '0' then PE <= ending; elsif ponto = '1' then PE <= searchx1; else PE <= searchx0; end if;
         -- enquanto o estado é searchx0, se xbusca = "000000" e não houver uma parede, termina o programa; se houver uma parede troca para o estado searchx1; enquanto nenhuma das condições forem satisfeitas, fica no estado atual.

         when searchx1 =>
         if xbusca = "111111" and ponto = '0' then PE <= ending; elsif ponto = '1' then PE <= searchy0; else PE <= searchx1; end if;
         -- enquanto o estado é searchx1, se xbusca = "111111" e não houver uma parede, termina o programa; se houver uma parede troca para o estado searchy0; enquanto nenhuma das condições forem satisfeitas, fica no estado atual.

         when searchy0 =>
         if ybusca = "000000" and ponto = '0' then PE <= ending; elsif ponto = '1' then PE <= searchy1; else PE <= searchy0; end if;
         -- enquanto o estado é searchy0, se ybusca = "00000" e não houver uma parede, termina o programa; se houver uma parede troca para o estado searchy1; enquanto nenhuma das condições forem satisfeitas, fica no estado atual.

         when searchy1 =>
         if ybusca = "111111" and ponto = '0' then PE <= ending; elsif ponto = '1' then PE <= wallhor1; else PE <= searchy1; end if;
         -- enquanto o estado é searchy1, se xbusca = "111111" e não houver uma parede, termina o programa; se houver uma parede troca para o estado wallhor1; enquanto nenhuma das condições forem satisfeitas, fica no estado atual.

         when wallhor1 => 
         if ponto = '0' then PE <= ending; elsif xbusca = x1 then PE <= wallhor2; else PE <= wallhor1; end if;
         --se houver um buraco na parede, termina o programa; se o valor de busca for igual o valor de x1, troca para o estado wallhor2; enquanto nenhuma condição for satisfeita, fica no estado atual

         when wallhor2 => 
         if ponto = '0' then PE <= ending; elsif xbusca = x1 then PE <= wallver1; else PE <= wallhor2; end if;
         --se houver um buraco na parede, termina o programa; se o valor de busca for igual o valor de x1, troca para o estado wallver1; enquanto nenhuma condição for satisfeita, fica no estado atual

         when wallver1 => 
         if ponto = '0' then PE <= ending; elsif ybusca = y1 then PE <= wallver2; else PE <= wallver1; end if;
         --se houver um buraco na parede, termina o programa; se o valor de busca for igual o valor de y1, troca para o estado wallver2; enquanto nenhuma condição for satisfeita, fica no estado atual

         when wallver2 => 
         if ponto = '0' then PE <= ending; elsif ybusca = y1 then PE <= soma; else PE <= wallver2; end if;
         --se houver um buraco na parede, termina o programa; se o valor de busca for igual o valor de y1, troca para o estado soma; enquanto nenhuma condição for satisfeita, fica no estado atual

         when soma => PE <= found; -- após a soma, muda para o estado de busca da sala

         when found => if check_sala /= "0000" then PE <= ending; elsif count >= N_SALAS then PE <= ending; else PE <= found; end if;
         -- se o valor de check_sala for diferente de 0 (uma sala foi encontrada), termina o programa; se o contador de salas for maior que o numero de salas, termina o programa (não tem sala); fica no estado atual

         when ending => PE <= init; -- quando estiver no estado ending, volta para o inicio
         
         when others => PE <= EA; -- em caso de outros, permanece no estado atual
      end case;
   end process;
   
   ----  processo para controlar os registradores -----------------------------------------------------
   process (reset, clock)
   begin
      if reset='1' then
         xbusca <= "000000";
         ybusca <= "000000";
         check_sala <= "0000";
         count <= "0000";
      elsif clock'event and clock='1' then
         case EA is
            when set => -- seta os valores de busca
            xbusca <= x;
            ybusca <= y;
            
            when searchx0 => 
            xbusca <= xbusca - '1'; -- decrementa o valor de xbusca
            if ponto = '1' then x0 <= xbusca; xbusca <= x; end if; -- quando uma parede for encontrada, salva o valor em x0 e reseta o valor de xbusca
            
            when searchx1 => 
            xbusca <= xbusca + '1'; -- incrementa o valor de xbusca
            if ponto = '1' then x1 <= xbusca; xbusca <= x0; end if; -- quando uma parede for encontrada, salva o valor em x1 e reseta o valor de xbusca
            
            when searchy0 =>
            ybusca <= ybusca - '1'; -- decrementa o valor de ybusca
            if ponto = '1' then y0 <= ybusca; ybusca <= y; end if; -- quando uma parede for encontrada, salva o valor em y0 e reseta o valor de ybusca
            
            when searchy1 =>
            ybusca <= ybusca + '1'; -- incrementa o valor de ybusca
            if ponto = '1' then y1 <= ybusca; ybusca <= y0; end if; -- quando uma parede for encontrada, salva o valor em y1 e seta o valor de ybusca para y0

            when wallhor1 =>
            xbusca <= xbusca + '1'; -- incrementa o valor de xbusca
            if xbusca = x1 then xbusca <= x0; end if; -- se o valor de xbusca for igual ao valor de x1, reseta o valor de xbusca

            when wallhor2 =>
            xbusca <= xbusca + '1'; -- incrementa o valor de xbusca
            if xbusca = x1 then xbusca <= x0; end if; -- se o valor de xbusca for igual ao valor de x1, reseta o valor de xbusca

            when wallver1 => 
            ybusca <= ybusca + '1'; -- incrementa o valor de ybusca
            if ybusca = y1 then ybusca <= y0; end if; -- se o valor de ybusca for igual ao valor de y1, reseta o valor de xbusca

            when wallver2 =>
            ybusca <= ybusca + '1'; -- incrementa o valor de ybusca
            if ybusca = y1 then ybusca <= y0; end if; -- se o valor de ybusca for igual ao valor de y1, reseta o valor de xbusca

            when soma =>
            deltax <= x1 - x0 + '1'; -- calcula o valor de deltax
            deltay <= y1 - y0 + '1'; -- calcula o valor de deltay

            when found =>
            if deltax = salas(conv_integer(count)).x and deltay = salas(conv_integer(count)).y then check_sala <= count; elsif count < N_SALAS then count <= count + '1'; end if;
            --se o valor de deltax e deltay forem iguais a os valores de uma sala, check_sala vira o valor de count (numero da sala); se count for menor que o numero de salas, incrementa count

            when others => 
            xbusca <= "000000"; -- em outros casos, zera o xbusca e ybusca
            ybusca <= "000000"; 
            count <= "0000"; -- em outros casos, zera o count
            check_sala <= "0000"; -- em outros casos, zera o check_sala

         end case;
      end if;
   end process;

   fim <= '0' when EA /= ending else '1'; -- fim = '1' quando o estado atual estiver no "ending"
   sala <= check_sala; -- sala = check_sala (numero da sala; check_sala só sai de 0 quando tem uma sala)

 end ondeestou;