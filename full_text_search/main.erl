-module(main).

-export([start/0]).

start() ->
  Docs = ["katoomba is the capital of NSW bushland", "there are many venomous bushes in NSW", "kangaroos eat leaves on the bushes", "cows say moo, docks say quack, kangaroo keeps silence"],
  Store = lists:foldl(fun(Doc, Acc) -> document_store:insert(Acc, Doc) end, document_store:new(), Docs),
  lists:map(fun(Keyword) -> io:fwrite("docs matching ~p: ~p~n", [Keyword, document_store:search(Store, Keyword)]) end, ["katoomba", "moo", "!@#%"]).
