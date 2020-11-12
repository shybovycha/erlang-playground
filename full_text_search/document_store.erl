-module(document_store).

-export([ new/0, insert/2, search/2 ]).

-record(document_store, { document_by_id, document_by_keyword, word_index }).

new() -> #document_store { document_by_id = maps:new(), document_by_keyword = maps:new(), word_index = trie:new() }.

get_words([]) -> [];

get_words(Document) ->
  re:split(Document, "\\s+", [{ return, list }]).

generate_id(Store, _Document) -> 
  maps:size(Store#document_store.document_by_id) + 1.

add_document_by_keyword(DocumentByKeyword, Word, DocumentId) ->
  IsKey = maps:is_key(Word, DocumentByKeyword),
  DocumentIds = if
    IsKey == true -> 
      maps:get(Word, DocumentByKeyword);
    true ->
      sets:new()
  end,
  NewDocumentIds = sets:add_element(DocumentId, DocumentIds),
  maps:put(Word, NewDocumentIds, DocumentByKeyword).

insert(Store, Document) ->
  DocumentByKeyword = Store#document_store.document_by_keyword,
  DocumentById = Store#document_store.document_by_id,
  WordIndex = Store#document_store.word_index,

  Id = generate_id(Store, Document),
  Words = get_words(Document),

  NewDocumentById = maps:put(Id, Document, DocumentById),
  NewIndex = lists:foldl(fun(Word, Acc) -> trie:insert(Acc, Word) end, WordIndex, Words),
  NewDocumentByKeyword = lists:foldl(fun(Word, Acc) -> add_document_by_keyword(Acc, Word, Id) end, DocumentByKeyword, Words),

  Store#document_store { document_by_keyword = NewDocumentByKeyword, document_by_id = NewDocumentById, word_index = NewIndex }.

search(Store, Keyword) ->
  MAX_DISTANCE = 3,

  DocumentByKeyword = Store#document_store.document_by_keyword,
  DocumentById = Store#document_store.document_by_id,
  WordIndex = Store#document_store.word_index,

  IndexKeywords = trie:keys(WordIndex),
  MatchingKeywords = lists:filter(fun(IndexWord) -> levenshtein:distance(IndexWord, Keyword) =< MAX_DISTANCE end, IndexKeywords),
  MatchingDocumentIds = sets:to_list(lists:foldl(fun(Keyword1, Acc) -> sets:union(Acc, maps:get(Keyword1, DocumentByKeyword)) end, sets:new(), MatchingKeywords)),
  MatchingDocuments = lists:map(fun(Id) -> maps:get(Id, DocumentById) end, MatchingDocumentIds),

  MatchingDocuments.
