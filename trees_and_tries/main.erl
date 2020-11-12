-module(main).

-export([start/0]).

%start1() ->
%  Values = [15, 12, 20, 22, 10, 3, 5, 1, 4],
%  Tree = lists:foldl(fun(Elt, Acc) -> binary_tree:insert(Acc, Elt) end, binary_tree:new(0), Values),
%  X1 = 7,
%  X2 = 12,
%  X1Present = binary_tree:contains(Tree, X1),
%  X2Present = binary_tree:contains(Tree, X2),
%  io:fwrite("Tree: ~p~n", [Tree]),
%  io:fwrite("~p in tree (~p)~n", [X1, X1Present]),
%  io:fwrite("~p in tree (~p)~n", [X2, X2Present]).

search(Trie, Keyword) ->
  MAX_DISTANCE = 3,
  [ Key || Key <- trie:keys(Trie), levenshtein:distance(Key, Keyword) =< MAX_DISTANCE ].

start() ->
  Values = ["katoomba", "kaboom", "kangaroo", "moo"],
  Tree = lists:foldl(fun(Elt, Acc) -> trie:insert(Acc, Elt) end, trie:new(), Values),
  io:fwrite("Trie: ~p~n", [Tree]),
  lists:map(fun(Keyword) -> io:fwrite("keys matching ~p in trie: ~p~n", [Keyword, search(Tree, Keyword)]) end, ["katoomba", "moo", "!@#%"]).

