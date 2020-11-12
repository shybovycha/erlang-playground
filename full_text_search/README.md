# Full-text search in Erlang

This app showcases how a document store for full-text search can be implemented in Erlang.

## Building

```
$ erlc binary_tree.erl main.erl levenshtein.erl trie.erl document_store.erl
```

## Running

```
$ erl -s main start -s init stop -noshell
```

