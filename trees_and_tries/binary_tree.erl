-module(binary_tree).

-export([new/1, insert/2, contains/2]).

-record(tree, { value, left, right }).

new(N) -> #tree{ value = N, left = nil, right = nil }.

insert(Tree, Value)
  when Tree#tree.right =:= nil, Value >= Tree#tree.value ->
    NewNode = new(Value),
    Tree#tree{ right = NewNode };

insert(Tree, Value)
  when Tree#tree.left =:= nil, Value < Tree#tree.value ->
    NewNode = new(Value),
    Tree#tree{ left = NewNode };

insert(Tree, Value)
  when Value >= Tree#tree.value ->
    Tree#tree{ right = insert(Tree#tree.right, Value) };

insert(Tree, Value)
  when Value < Tree#tree.value ->
    Tree#tree{ left = insert(Tree#tree.left, Value) }.

contains(nil, _) -> false;

contains(Tree, Value)
  when Tree#tree.value =:= Value -> 
    true;

contains(Tree, Value)
  when Value >= Tree#tree.value -> 
    contains(Tree#tree.right, Value);

contains(Tree, Value)
  when Value < Tree#tree.value -> 
    contains(Tree#tree.left, Value).

