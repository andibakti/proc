LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--THIS IS THE IMPLEMENTATION OF A DYNAMIC 2 BITS BRANCH PREDICTIOR

entity TwoBits_Pred is
	port(
		clk : in std_logic;
		Enable : in std_logic;  --set to HIGH when the instruction is beq "000100" or bne "000101"
		actual_taken	 : in std_logic; -- 0 for not taken, 1 for taken

		pred_outcome   : out std_logic;  -- 0 for not taken, 1 for taken
		pred_state	 : out integer range 0 to 3 := 0  --output state for test purposes
		);
end TwoBits_Pred;


architecture Arch of TwoBits_Pred is
signal state : integer range 0 to 3 := 0;

begin
	pred_state <= state;
	
	process(Enable)
	begin
		if (rising_edge(Enable)) then
			case state is
				when 0 =>
					if (actual_taken = '0') then
						state <= 0;
					elsif (actual_taken = '1') then
						state <= 1;
					end if;
				when 1 =>
					if (actual_taken = '0') then
						state <= 0;
					elsif (actual_taken = '1') then
						state <= 3;
					end if;
				when 2 =>
					if (actual_taken = '0') then
						state <= 0;
					elsif (actual_taken = '1') then
						state <= 3;
					end if;
				when 3 =>
					if (actual_taken = '0') then
						state <= 2;
					elsif (actual_taken = '1') then
						state <= 3;
					end if;
				when others => null;
			end case;
		end if;
	end process;
	
	
	process(state)
	begin
		case state is
			when 0 =>
				pred_outcome <= '0';
			when 1 =>
				pred_outcome <= '0';
			when 2 =>
				pred_outcome <= '1';
			when 3 =>
				pred_outcome <= '1';
			when others => null;
		end case;
	end process;

end Arch;