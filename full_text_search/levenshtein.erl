-module(levenshtein).

-export([distance/2]).

distance([], S2) ->
  length(S2);

distance(S1, []) ->
  length(S1);

distance([X | S1], [X | S2]) ->
  distance(S1, S2);

distance([_S1Head | S1Tail] = S1, [_S2Head | S2Tail] = S2) ->
  D1 = distance(S1, S2Tail),
  D2 = distance(S1Tail, S2),
  D3 = distance(S1Tail, S2Tail),
  1 + lists:min([ D1, D2, D3 ]).

%levenshtein(S, T) ->
%  { L, _ } = ld(S, T, dict:new()),
%  L.

%ld([] = S, T, Cache) ->
%  { length(T), dict:store({ S, T }, length(T), Cache) };

%ld(S, [] = T, Cache) ->
%  { length(S), dict:store({ S, T }, length(S), Cache) };

%ld([ X | S ], [ X | T ], Cache) ->
%  ld(S, T, Cache);

%ld([ _SH | ST ] = S, [ _TH | TT ] = T, Cache) ->
%  case dict:is_key({ S, T }, Cache) of
%    true -> { dict:fetch({ S, T }, Cache), Cache };
%    false ->
%      { L1, C1 } = ld(S, TT, Cache),
%      { L2, C2 } = ld(ST, T, C1),
%      { L3, C3 } = ld(ST, TT, C2),
%      L = 1 + lists:min([ L1, L2, L3 ]),
%      { L, dict:store({ S, T }, L, C3) }
%  end.
