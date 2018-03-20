%%%-------------------------------------------------------------------
%% @doc lcd_number_system public API
%% @end
%%%-------------------------------------------------------------------

-module(lcd_number_system).

-export([to_lcd/1]).

%%
%%   _    _  _     _  _  _  _  _
%%  | | | _| _||_||_ |_   ||_||_|
%%  |_| ||_  _|  | _||_|  ||_| _|
%%
%% Cordinates
%%  1 - 123
%%  2 - 123
%%  3 - 123
%%
%% Where the first and last translate to |, the middle translates to _
%%
%% which translates the numbers:
%% 1 to 000, 001, 001
%% 2 to 010, 011, 110
%%
%%
-define(LCD, #{
            $0 => <<"010101111">>,
            $1 => <<"000001001">>,
            $2 => <<"010011110">>,
            $3 => <<"010011011">>,
            $4 => <<"000111001">>,
            $5 => <<"010110011">>,
            $6 => <<"010110111">>,
            $7 => <<"010001001">>,
            $8 => <<"010111111">>,
            $9 => <<"010111011">>
         }).

to_lcd(N) ->
    to_lcd(N, []).

%% Fold through the string
to_lcd([], Acc) -> Acc;
to_lcd([H | T], Acc) -> to_lcd(T, Acc ++ [number_to_lcd(H)]).

number_to_lcd(Char) ->
    Def = maps:get(Char, ?LCD),
    lcd_to_string(Def).

lcd_to_string(S) -> lcd_to_string(S, []).
lcd_to_string(<<>>, Str) -> Str;
lcd_to_string(<<Pipe1:1/binary, US:1/binary, Pipe2:1/binary, Rest/binary>>, Str) ->
    lcd_to_string(Rest, Str ++ [ [pipe(Pipe1), underscore(US), pipe(Pipe2)] ]).

pipe(<<"0">>) -> " ";
pipe(<<"1">>) -> "|".
underscore(<<"0">>) -> " ";
underscore(<<"1">>) -> "_".
