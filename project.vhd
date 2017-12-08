library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all; --packages initially to be used to create our real[] datatype, only used for test bench work
use ieee.math_real.all;
use ieee.numeric_std.all;

package test is
--type arr_Reals is array (0 to 1) of float32;
end test;
use work.test.all;
library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity project is

	port	(
	
			a	:	out bit; --segments for seven segment display
			b	:	out bit;
			c	:	out bit;
			d	:	out bit;
			e	:	out bit;
			f	:	out bit;
			g	:	out bit;
			
			a01	:	out bit; --segments for seven segment display
			b01	:	out bit;
			c01	:	out bit;
			d01	:	out bit;
			e01	:	out bit;
			f01	:	out bit;
			g01	:	out bit;
			
			a02	:	out bit; --segments for seven segment display
			b02	:	out bit;
			c02	:	out bit;
			d02	:	out bit;
			e02	:	out bit;
			f02	:	out bit;
			g02	:	out bit;
			
			a03	:	out bit; --segments for seven segment display
			b03	:	out bit;
			c03	:	out bit;
			d03	:	out bit;
			e03	:	out bit;
			f03	:	out bit;
			g03	:	out bit;
			
			a04	:	out bit; --segments for seven segment display, Hex04 displays current state in FSM at all times
			b04	:	out bit;
			c04	:	out bit;
			d04	:	out bit;
			e04	:	out bit;
			f04	:	out bit;
			g04	:	out bit;
	
		b7	:	in	std_logic; --switches, used to input bits for guesses and set number for AI
		b6	:	in	std_logic;
		b5	:	in	std_logic;
		b4	:	in	std_logic;
		b3	:	in	std_logic;
		b2	:	in	std_logic;
		b1	:	in	std_logic;
		b0	:	in	std_logic;
		
		r0	:	out std_logic; --RED LEDs, during user side, r0 signifies an incorrect input, 
		r1	:	out std_logic;
		r2	:	out std_logic;
		r3	:	out std_logic;
		r4	:	out std_logic;
		r5	:	out std_logic;
		r6	:	out std_logic;
		r7	:	out std_logic;
		
		r8	:	out std_logic; -- signals user to input a number for the AI
		
		clk50MHz	:	in	std_logic;
		
		submit	:	in	std_logic; --buttons, left to right on the board, submit used as an enter key
		higher	:	in std_logic; --used by user in states E-H to tell AI if its guess was higher or lower than the set input
		lower	   :	in std_logic;
		
		reset		:	in	std_logic;
		
		oLower	:	out std_logic; --RED LEDs, display higher/lower, but also used for some debugging in states
		oHigher	:	out std_logic;
		correct	:	out std_logic); --green LED signifying correct user input



end project;

architecture behavior of project is 

	
	--signal pRands	:	arr_Reals := (0.88, 0.99); --rands used during test bench
	signal counter : std_logic_vector(26 downto 0); --counter for waiting periods
	signal rand_num : integer := 0;
	signal rand_vector	:	std_logic_vector(7 downto 0);
	signal guess	:	std_logic_vector(7 downto 0);
	signal pcGuess		:	integer := 0;
	signal pcGuessVector	:	std_logic_vector(7 downto 0);
	signal levelBits	:	integer	:= 2;
	signal score	:	integer	:= 0; -- 10x (bits + 4 - number of guesses)
	signal lowHigh	:	std_logic; --zero if lower, 1 if higher
	signal flowHigh	:	std_logic; --keeps track of if the first PC guess is low or high for use in third guess
	signal NEWPCguess	:	integer :=0;
	signal PCscore	:	integer :=0;
	signal bScore	:	std_logic_vector(3 downto 0);
	signal bPCscore	:	std_logic_vector(3 downto 0);
	signal count	:	integer	:= 1; --counter used for selecting the psuedo-random ints for binary conversion
	signal s	:	std_logic; --s, sL, sH used as bools to allow buttons to toggle until unneeded
	signal sL	:	std_LOGIC; --(submit, lower, higher respectively)
	signal sH	:	std_logic;

	type state_type is (STATE_A, STATE_B, STATE_C, STATE_D, STATE_E, STATE_F, STATE_G, STATE_H, STATE_I, STATE_J);  -- enumeration to hold our states
	signal state : state_type := STATE_A;

begin

code: process (clk50MHz)
   -- variable seed1, seed2: positive;               -- seed values for random generator
  --  variable rand: real;   -- random real-number value in range 0 to 1.0  
  --  variable pcRandRange: real := 0.25*((real(count)) - 0.5) + 1.0;
	-- variable range_of_rand : integer := ((2**levelBits) - 1);    -- the range of random values created will be 0 to +1000.
begin

--pRands(0) <= 0.88;
--pRands(1) <= 0.90;
--pRands(2) <= 0.85;
--pRands(3) <= 0.26;
--pRands(4) <= 0.41;
--pRands(5) <= 0.64;
--pRands(6) <= 0.96;
--pRands(7) <= 0.96;
--pRands(8) <= 0.89;
--pRands(9) <= 0.82;
--pRands(10) <= 0.07;
--pRands(11) <= 0.53;
--pRands(12) <= 0.34;
--pRands(13) <= 0.98;
--pRands(14) <= 0.49;
--pRands(15) <= 0.76;
--pRands(16) <= 0.29;
--pRands(17) <= 0.86;
--pRands(18) <= 0.23;
--pRands(19) <= 0.87;
--pRands(20) <= 0.24;
--pRands(21) <= 0.32;
--pRands(22) <= 0.07;
--pRands(23) <= 0.11;
--pRands(24) <= 0.34;
--pRands(25) <= 0.54;
--pRands(26) <= 0.17;
--pRands(27) <= 0.65;
--pRands(28) <= 0.55;
--pRands(29) <= 0.01;
--pRands(30) <= 0.05;
--pRands(31) <= 0.24;
--pRands(32) <= 0.35;
--pRands(33) <= 0.66;
--pRands(34) <= 0.08;
--pRands(35) <= 0.08;
--pRands(36) <= 0.40;
--pRands(37) <= 0.54;
--pRands(38) <= 0.57;
--pRands(39) <= 0.24;
    
	 if clk50MHz'event AND clk50MHz = '1' then
	 
	 if reset = '0' AND submit = '1' then --reset
		oLower <= '1';
		oHigher <= '1';
		levelBits <= 2;
		score <= 0;
		PCscore <= 0;
		state <= STATE_A;
	end if;
	 
	 
	 if count < 2**levelBits then --constant change of count for random selection
		count <= count + 1;
	else
		count <= 0;
	end if;
	 
		 case state is
			when STATE_A => --get new number / generate new level
			
			--	uniform(seed1, seed2, rand);   -- generate random number
		--		rand_num <= integer(real(count/10)*real(range_of_rand));  -- rescale to 0..1000, convert integer part
				rand_vector <= std_logic_vector(to_unsigned(count, rand_vector'length));
				
				correct <= '0';
				
				a <= '1'; --set all hex to blank
				b <= '1';
				c <= '1';
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
				a01 <= '1';
				b01 <= '1';
				c01 <= '1';
				d01 <= '1';
				e01 <= '1';
				f01 <= '1';
				g01 <= '1';
				a02 <= '1';
				b02 <= '1';
				c02 <= '1';
				d02 <= '1';
				e02 <= '1';
				f02 <= '1';
				g02 <= '1';
				a03 <= '1';
				b03 <= '1';
				c03 <= '1';
				d03 <= '1';
				e03 <= '1';
				f03 <= '1';
				g03 <= '1';
				
				a04 <= '0'; --indicate state
				b04 <= '0';
				c04 <= '0';
				d04 <= '1';
				e04 <= '0';
				f04 <= '0';
				g04 <= '0';
			
				r0 <= '0'; --reset LEDs
				r1 <= '0';
				r2 <= '0';
				r3 <= '0';
				r4 <= '0';
				r5 <= '0';
				r6 <= '0';
				r7 <= '0';
				r8 <= '0';
				
				state <= STATE_B;
			
			when STATE_B => --first guess
				oLower <= '0';
				
				
				a04 <= '1'; --indicate state
				b04 <= '1';
				c04 <= '0';
				d04 <= '0';
				e04 <= '0';
				f04 <= '0';
				g04 <= '0';
				
				if submit = '0' then
					s <= '1';
				end if;
				if s = '1' then
					guess(7) <= b7; --save guess
					guess(6) <= b6;
					guess(5) <= b5;
					guess(4) <= b4;
					guess(3) <= b3;
					guess(2) <= b2;
					guess(1) <= b1;
					guess(0) <= b0;
					
					if rand_vector = guess then --Guess is correct
						correct <= '1'; --wait 1sec
						
						if counter < "10000000000000000000000000" then
							counter <= counter + 1;
						else
							s <= '0' ;
							levelBits <= levelBits + 1;
							score <= score + 2;
						   counter <= (others => '0');
							if levelBits > 8 then --if level out of bounds, user wins this side, go to PC side
								levelBits <= 2;
								state <= STATE_E;
							else -- else go to next level
								state <= STATE_A; 
							end if;						
						end if;
						
						
					else --user incorrect, go to second guess
					r0 <= '1';
					if counter < "10000000000000000000000000" then
							counter <= counter + '1';
						else
							s <= '0' ;
						   counter <= (others => '0');			
							correct <= '0';
							state <= STATE_C;						
						end if;
					end if;
					
				end if;
				
			when STATE_C => --second guess
			a04 <= '0'; --indicate state
			b04 <= '1';
			c04 <= '1';
			d04 <= '0';
			e04 <= '0';
			f04 <= '0';
			g04 <= '1';
			r0 <= '0';
			
			if submit = '0' then
				s <= '1';
			end if;
				if s = '1' then
					
					guess(7) <= b7; --save guess
					guess(6) <= b6;
					guess(5) <= b5;
					guess(4) <= b4;
					guess(3) <= b3;
					guess(2) <= b2;
					guess(1) <= b1;
					guess(0) <= b0;
					
					if rand_vector = guess then --if corect
						correct <= '1'; --wait 1sec
						
						if counter < "10000000000000000000000000" then
							counter <= counter + '1';
						else
							score <= score + 1; -- update score 
							levelBits <= levelBits + 1;
							s <= '0' ;
						   counter <= (others => '0');
							if levelBits > 8 then
								levelBits <= 2;
								state <= STATE_E;
							else
								state <= STATE_A; 
							end if;							
						end if;
					else --case guess is wrong
						r0 <= '1';
					   if counter < "10000000000000000000000000" then
							counter <= counter + '1';
						else
							s <= '0' ;
						   counter <= (others => '0');
							correct <= '0';
							state <= STATE_D;							
						end if;
					end if;
					
				end if;
			
			
			when STATE_D => -- third guess
			r0 <= '0';
			a04 <= '1'; --indicate state
			b04 <= '0';
			c04 <= '0';
			d04 <= '0';
			e04 <= '0';
			f04 <= '1';
			g04 <= '0';
				
			if submit = '0' then
				s <= '1';
			end if;
				if s = '1' then
					
					guess(7) <= b7; --save guess
					guess(6) <= b6;
					guess(5) <= b5;
					guess(4) <= b4;
					guess(3) <= b3;
					guess(2) <= b2;
					guess(1) <= b1;
					guess(0) <= b0;
					
					if rand_vector = guess then -- if correct
						correct <= '1'; --wait 1sec	
						if counter < "10000000000000000000000000" then
							counter <= counter + '1';
						else
							score <= score + 0; -- update score
							levelBits <= levelBits + 1;
							s <= '0' ;
							counter <= (others => '0');
							if levelBits > 8 then --level out of bounds, user completed all
								levelBits <= 2;
								state <= STATE_E;
							else
								state <= STATE_A; 
							end if;
						end if;
					else -- case guess is wrong
						r0 <= '1';
						correct <= '0';
						if counter < "10000000000000000000000000" then
							counter <= counter + '1';
						else
							s <= '0' ;
							counter <= (others => '0');
							levelBits <= 2;
							state <= STATE_E;
						end if;
					end if;
					
				end if;
			
			when STATE_E => -- user generate number for computer //BEGIN CPU GUESSING SIDE
			correct <= '0';
			a04 <= '0'; --indicate state
			b04 <= '1';
			c04 <= '1';
			d04 <= '0';
			e04 <= '0';
			f04 <= '0';
			g04 <= '0';
			
			r0 <= '0'; --reset LEDs
			r1 <= '0';
			r2 <= '0';
			r3 <= '0';
			r4 <= '0';
			r5 <= '0';
			r6 <= '0';
			r7 <= '0';
			r8 <= '1'; --indicate user input required
			
			if submit = '0' then
				s <= '1';
			end if;
			if s = '1' then
				rand_vector(0) <= b0; --user set number saved //this is the number PC will try to guess
				rand_vector(1) <= b1;
				if levelBits > 2 then
					rand_vector(2) <= b2;
				else 
					rand_vector(2) <= '0';
				end if;
				if levelBits > 3 then
					rand_vector(3) <= b3;
				else
					rand_vector(3) <= '0';
				end if;
				if levelBits > 4 then
					rand_vector(4) <= b4;
				else
					rand_vector(4) <= '0';
				end if;
				if levelBits > 5 then
					rand_vector(5) <= b5;
				else
					rand_vector(5) <= '0';
				end if;
				if levelBits > 6 then
					rand_vector(6) <= b6;
				else
					rand_vector(6) <= '0';
				end if;
				if levelBits > 7 then
					rand_vector(7) <= b7;
				else
					rand_vector(7) <= '0';
				end if;
				if counter < "10000000000000000000000000" then --wait
					counter <= counter + 1;
				else
					counter <= (others => '0');
					s <= '0';
					state <= STATE_F;
				end if;
			end if;
			
			when STATE_F => -- computer first guess
			oHigher <= '0';
			oLower <= '0';
			r8 <= '0';
			a04 <= '0'; --indicate state
			b04 <= '1';
			c04 <= '1';
			d04 <= '1';
			e04 <= '0';
			f04 <= '0';
			g04 <= '0';
			
		--	pcrandRange := 0.25*(rand - 0.5) + 1.0; --random fuzzy logic for test bench
			
				--computer guesses between 0 and 2^levelBits - 1
				
			PCguess <= integer((2**(levelBits) - 1) / 2);  --* pcrandRange); --PC guess 1
			
			pcguessVector <= conv_std_logic_vector(pcguess, 8); --conv guess to binary
				
				--display guess to user, and have user confirm
			
				r0 <= pcguessVector(0);
				r1 <= pcguessVector(1);
				if levelBits > 2 then
					r2 <= pcguessVector(2);
				else 
					r2 <= '0';
				end if;
				if levelBits > 3 then
					r3 <= pcguessVector(3);
				else
					r3 <= '0';
				end if;
				if levelBits > 4 then
					r4 <= pcguessVector(4);
				else
					r4 <= '0';
				end if;
				if levelBits > 5 then
					r5 <= pcguessVector(5);
				else
					r5 <= '0';
				end if;
				if levelBits > 6 then
					r6 <= pcguessVector(6);
				else
					r6 <= '0';
				end if;
				if levelBits > 7 then
					r7 <= pcguessVector(7);
				else
					r7 <= '0';
				end if;
			
				
				
				--if right then go to E and increase score/level
				
				if submit = '0' then -- PC guess is correct
					s <= '1';
				end if;
				if s = '1' then
					--increase score
					if levelBits > 7 then
						if counter < "10000000000000000000000000" then
							counter <= counter + 1;
						else
							counter <= (others => '0');
							s <= '0';
							PCscore <= PCscore + 2;
							state <= STATE_I;
						end if;
					else
						if counter < "10000000000000000000000000" then
							counter <= counter + 1;
						else
							counter <= (others => '0');
							s <= '0';
							PCscore <= PCscore + 2;
							levelBits <= levelBits + 1;
							state <= STATE_E;
						end if;
					end if;
				end if;
				
				if higher = '0' then -- actual number is higher than guess
					sH <= '1';
				end if;
				if sH = '1' then
					lowHigh <= '1';
					flowHigh <= '1';
					if counter < "10000000000000000000000000" then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						sH <= '0';
						state <= STATE_G;
					end if;
				end if;
				if lower = '0' then -- actual number is lower than guess
					sL <= '1';
				end if;
				if sL = '1' then
					lowHigh <= '0';
					flowHigh <= '0';
					if counter < "10000000000000000000000000" then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						sL <= '0';
						state <= STATE_G;
					end if;
				end if;
				--else go to G
			
			when STATE_G => -- computer second guess
			a04 <= '0'; --indicate state
			b04 <= '0';
			c04 <= '0';
			d04 <= '0';
			e04 <= '1';
			f04 <= '0';
			g04 <= '0';
			
		--	pcrandRange <= 0.25*(rand - 0.5) + 1.0;
			
				--computer guesses between 0 and 2^levelBits - 1
				
			if lowHigh = '0' then --previous guess was low
				NEWPCguess <= integer((3*(2**((levelBits)) - 1))/4); --* (pcrandRange)); 
			else --previous guess was high
				NEWPCguess <= integer((2**((levelBits)) - 1)/4); --* (pcrandRange));
			end if;
			
			pcGuess <= NEWPCguess;
			
			pcguessVector <= conv_std_logic_vector(pcguess, 8);
				
				--display guess to user, and have user confirm
			
				r0 <= pcguessVector(0);
				r1 <= pcguessVector(1);
				if levelBits > 2 then
					r2 <= pcguessVector(2);
				else 
					r2 <= '0';
				end if;
				if levelBits > 3 then
					r3 <= pcguessVector(3);
				else
					r3 <= '0';
				end if;
				if levelBits > 4 then
					r4 <= pcguessVector(4);
				else
					r4 <= '0';
				end if;
				if levelBits > 5 then
					r5 <= pcguessVector(5);
				else
					r5 <= '0';
				end if;
				if levelBits > 6 then
					r6 <= pcguessVector(6);
				else
					r6 <= '0';
				end if;
				if levelBits > 7 then
					r7 <= pcguessVector(7);
				else
					r7 <= '0';
				end if;
			
				
				
				--if right then go to E and increase score/level
				
				if submit = '0' then -- PC guess is correct
					s <= '1';
				end if;
				if s = '1' then
					--increase score
					if levelBits + 1 > 8 then
						if counter < "10000000000000000000000000" then
							counter <= counter + 1;
						else
							counter <= (others => '0');
							PCscore <= PCscore + 1;
							s <= '0';
							state <= STATE_I;
						end if;
					else
						if counter < "10000000000000000000000000" then
							counter <= counter + 1;
						else
							PCscore <= PCscore + 1;
							levelBits <= levelBits + 1;
							counter <= (others => '0');
							s <= '0';
							state <= STATE_E;
						end if;
					end if;
				end if;
				if higher = '0' then -- actual number is higher than guess
					sH <= '1';
				end if;
				if sH = '1' then
					lowHigh <= '1';
					if counter < "10000000000000000000000000" then
						counter <= counter + 1;
					else
						sH <= '0';
						counter <= (others => '0');
						state <= STATE_H;
					end if;
				end if;
				if lower = '0' then -- actual number is lower than guess
					sL <= '1';
				end if;
				if sL = '1' then
					lowHigh <= '0';
					if counter < "10000000000000000000000000" then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						sL <= '0';
						state <= STATE_H;
					end if;
				end if;
			
			when STATE_H => -- computer third guess
			a04 <= '1'; --indicate state
			b04 <= '0';
			c04 <= '0';
			d04 <= '1';
			e04 <= '0';
			f04 <= '0';
			g04 <= '0';
			--pcrandRange <= 0.25*(rand - 0.5) + 1.0;
			
				--computer guesses between 0 and 2^levelBits - 1
			if lowHigh = '0' AND flowHigh = '0' then --first guess low, 2nd guess low
				NEWPCguess <= integer(7*(2**((levelBits)) - 1)/8); --* (pcrandRange)); 7/8 max
			elsif flowHigh = '0' AND lowHigh = '1' then--first guess low, 2nd guess high
				NEWPCguess <= integer(((PCguess)+(2**((levelBits)) - 1)/2)/2); --* (pcrandRange)); 5/8 max
			elsif flowHigh = '1' AND lowHigh = '0' then --first guess high, second guess low
				NEWPCguess <= integer(3*(2**((levelBits)) - 1)/8); --* (pcrandRange)); 3/8 max
			else --first guess high, second guess high
				NEWPCguess <= integer((PCguess)/2); --* (pcrandRange)); 1/8 max
			end if;
			PCguess<= NEWPCguess;
			
			pcguessVector <= conv_std_logic_vector(pcguess, 8); --conv to displayable vector
				
				--display guess to user, and have user confirm
			
				r0 <= pcguessVector(0);
				r1 <= pcguessVector(1);
				if levelBits > 2 then
					r2 <= pcguessVector(2);
				else 
					r2 <= '0';
				end if;
				if levelBits > 3 then
					r3 <= pcguessVector(3);
				else
					r3 <= '0';
				end if;
				if levelBits > 4 then
					r4 <= pcguessVector(4);
				else
					r4 <= '0';
				end if;
				if levelBits > 5 then
					r5 <= pcguessVector(5);
				else
					r5 <= '0';
				end if;
				if levelBits > 6 then
					r6 <= pcguessVector(6);
				else
					r6 <= '0';
				end if;
				if levelBits > 7 then
					r7 <= pcguessVector(7);
				else
					r7 <= '0';
				end if;
			
				
				
				--if right then go to E and increase score/level
				
				if submit = '0' then -- PC guess is correct
					s <= '0';
				end if;
				if s = '1' then
					--increase score
					if levelBits > 7 then --if level out of bounds
						if counter < "10000000000000000000000000" then
							counter <= counter + 1;
						else
							counter <= (others => '0');
							PCscore <= PCscore + 0;
							s <= '0';
							state <= STATE_I; --both sides done, display scoring
						end if;
					else --go to next level
						if counter < "10000000000000000000000000" then
							counter <= counter + 1;
						else
							counter <= (others => '0');
							s <= '0';
							PCscore <= PCscore + 0;
							levelBits <= levelBits + 1;
							state <= STATE_E;
						end if;
					end if;
				end if;
				
				if higher = '0' then -- actual number is higher than guess
					lowHigh <= '1';
					state <= STATE_I; 
				end if;
				if lower = '0' then -- actual number is lower than guess
					lowHigh <= '0';
					state <= STATE_I;
				end if;
			
			when STATE_I => --end of game / user score display
			
				r0 <= '0'; --reset LEDs
				r1 <= '0';
				r2 <= '0';
				r3 <= '0';
				r4 <= '0';
				r5 <= '0';
				r6 <= '0';
				r7 <= '0';
				r8 <= '0';
			
				a04 <= '1'; --indicate state
				b04 <= '1';
				c04 <= '1';
				d04 <= '1';
				e04 <= '0';
				f04 <= '0';
				g04 <= '1';
				
				bscore <= std_logic_vector(to_unsigned(score, 4)); --converting user score to binary
				
				
				if bScore(0) = '0' then
				--output 0 to crytstal display [0]
				a <= '0';
				b <= '0';
				c <= '0';
				d <= '0';
				e <= '0';
				f <= '0';
				g <= '1';
				else 
				--output 1 to crystal display [0]
				a <= '1';
				b <= '0';
				c <= '0';
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
				end if;
				
				if bScore(1) = '0' then
				--output 0 to crytstal display [1]
				a01 <= '0';
				b01 <= '0';
				c01 <= '0';
				d01 <= '0';
				e01 <= '0';
				f01 <= '0';
				g01 <= '1';
				else 
				--output 1 to crystal display [1]
				a01 <= '1';
				b01 <= '0';
				c01 <= '0';
				d01 <= '1';
				e01 <= '1';
				f01 <= '1';
				g01 <= '1';
				end if;
				
				if bScore(2) = '0' then
				--output 1 to crystal display [2]
				a02 <= '0';
				b02 <= '0';
				c02 <= '0';
				d02 <= '0';
				e02 <= '0';
				f02 <= '0';
				g02 <= '1';
				else 
				--output 1 to crystal display [2]
				a02 <= '1';
				b02 <= '0';
				c02 <= '0';
				d02 <= '1';
				e02 <= '1';
				f02 <= '1';
				g02 <= '1';
				end if;
				
				
				if bScore(3) = '0' then
				--output 0 to crytstal display [3]
				a03 <= '0';
				b03 <= '0';
				c03 <= '0';
				d03 <= '0';
				e03 <= '0';
				f03 <= '0';
				g03 <= '1';
				else 
				--output 1 to crystal display [3]
				a03 <= '1';
				b03 <= '0';
				c03 <= '0';
				d03 <= '1';
				e03 <= '1';
				f03 <= '1';
				g03 <= '1';
				end if;
				
				if submit = '0' then
					s <= '1';
				end if;
				if s = '1' then
					if counter < "10000000000000000000000000" then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						s <= '0';
						state <= STATE_J;
					end if;
				end if;
				
			when STATE_J => --end of game / PC score display
			
				a04 <= '1'; --indicate state
				b04 <= '0';
				c04 <= '0';
				d04 <= '0';
				e04 <= '1';
				f04 <= '1';
				g04 <= '1';
				
				bPCscore <= std_logic_vector(to_unsigned(PCscore, 4)); --converting PC score to binary
				
				if bPCScore(0) = '0' then
				--output 0 to crytstal display [0]
				a <= '0';
				b <= '0';
				c <= '0';
				d <= '0';
				e <= '0';
				f <= '0';
				g <= '1';
				else 
				--output 1 to crystal display [0]
				a <= '1';
				b <= '0';
				c <= '0';
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
				end if;
				
				if bPCScore(1) = '0' then
				--output 0 to crytstal display [1]
				a01 <= '0';
				b01 <= '0';
				c01 <= '0';
				d01 <= '0';
				e01 <= '0';
				f01 <= '0';
				g01 <= '1';
				else 
				--output 1 to crystal display [1]
				a01 <= '1';
				b01 <= '0';
				c01 <= '0';
				d01 <= '1';
				e01 <= '1';
				f01 <= '1';
				g01 <= '1';
				end if;
				
				if bPCScore(2) = '0' then
				--output 1 to crystal display [2]
				a02 <= '0';
				b02 <= '0';
				c02 <= '0';
				d02 <= '0';
				e02 <= '0';
				f02 <= '0';
				g02 <= '1';
				else 
				--output 1 to crystal display [2]
				a02 <= '1';
				b02 <= '0';
				c02 <= '0';
				d02 <= '1';
				e02 <= '1';
				f02 <= '1';
				g02 <= '1';
				end if;
				
				if bPCScore(3) = '0' then
				--output 0 to crytstal display [3]
				a03 <= '0';
				b03 <= '0';
				c03 <= '0';
				d03 <= '0';
				e03 <= '0';
				f03 <= '0';
				g03 <= '1';
				else 
				--output 1 to crystal display [3]
				a03 <= '1';
				b03 <= '0';
				c03 <= '0';
				d03 <= '1';
				e03 <= '1';
				f03 <= '1';
				g03 <= '1';
				end if;
				
				if submit = '0' then
					s <= '1';
				end if;
				if s = '1' then
					score <= 0;
					PCscore <= 0;
					
					a <= '1'; --clear hex
					b <= '1';
					c <= '1';
					d <= '1';
					e <= '1';
					f <= '1';
					g <= '1';
					a01 <= '1';
					b01 <= '1';
					c01 <= '1';
					d01 <= '1';
					e01 <= '1';
					f01 <= '1';
					g01 <= '1';
					a02 <= '1';
					b02 <= '1';
					c02 <= '1';
					d02 <= '1';
					e02 <= '1';
					f02 <= '1';
					g02 <= '1';
					a03 <= '1';
					b03 <= '1';
					c03 <= '1';
					d03 <= '1';
					e03 <= '1';
					f03 <= '1';
					g03 <= '0';
					
					if counter < "10000000000000000000000000" then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						s <= '0';
						state <= STATE_A; --next round, reset game
					end if;
				end if;
				
			when others =>
			
				state <= STATE_A;
			
		end case;
	end if;
		
	 
end process code;

end behavior;