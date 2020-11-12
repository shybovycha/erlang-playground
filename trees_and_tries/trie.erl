-module(trie).

-import(lists, []).
-import(maps, []).

-export([new/0, insert/2, contains/2, keys/1]).

-record(trie, { stop, children }).

new() -> #trie{ stop = false, children = #{} }.

insert(Trie, []) -> Trie#trie { stop = true };

insert(Trie, [Char|Chars]) ->
  Children = Trie#trie.children,
  IsChild = maps:is_key(Char, Children),
  if 
    IsChild == true -> 
      SubTrie = maps:get(Char, Children),
      NewSubTrie = insert(SubTrie, Chars),
      NewChildren = maps:put(Char, NewSubTrie, Children),
      Trie#trie { children = NewChildren };
    true ->
      SubTrie = new(),
      NewSubTrie = insert(SubTrie, Chars),
      NewChildren = maps:put(Char, NewSubTrie, Children),
      Trie#trie { children = NewChildren }
  end.

contains(Trie, []) -> Trie#trie.stop;

contains(Trie, [Char|Chars]) ->
  Children = Trie#trie.children,
  IsChild = maps:is_key(Char, Children),
  if 
    IsChild == true ->
      SubTrie = maps:get(Char, Children),
      contains(SubTrie, Chars);
    true ->
      false
  end.

keys_sub(Trie, KeysAcc, CurrentKeyAcc) ->
  IsFullWord = Trie#trie.stop,
  KeysInit = if
    IsFullWord == true -> KeysAcc ++ [CurrentKeyAcc];
    true -> KeysAcc
  end,
  Fn = fun(Key, Child, KeysAcc1) -> keys_sub(Child, KeysAcc1, CurrentKeyAcc ++ [Key]) end,
  maps:fold(Fn, KeysInit, Trie#trie.children).

keys(Trie) ->
  keys_sub(Trie, [], "").

