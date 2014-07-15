# pipe2eval

simple REPL inside vim

supports: python, php, coffee, mysql, mongodb, redis, sh, go, javascript, ruby, elixir ...

## demos

coffeescript

![coffeescript](https://github.com/zweifisch/pipe2eval/raw/master/demos/coffee.gif)

* [mysql](https://github.com/zweifisch/pipe2eval/raw/master/demos/mysql.gif)
* [mongodb](https://github.com/zweifisch/pipe2eval/raw/master/demos/mongodb.gif)

## install

via vundle
```vim
Bundle "zweifisch/pipe2eval"
```

tempfiles are put to `/dev/shm/` by default, `export PIP2EVAL_TMP_FILE_PATH` to
override.

On Mac OS X, `/dev/` is highly locked down permissions wise. If you're on OS X it's recommended to use another folder, such as `/tmp/shms` or similar (you'll have to create it). To this by adding `export PIP2EVAL_TMP_FILE_PATH=/tmp/shms` to your Bash/ZSH RC file.

## usage

press `v<space>` to evaluate current line, `vip<space>` to evaluate a paragraph

to specify a diffrent filetype use the Pipe2 command `:Pipe2 redis`, `:Pipe2 mongo` ...

evaluate an empty line will clear the context

## key mappings
By default, pipe2eval maps `<Space>` in Visual mode with:

```vim
  vmap <buffer> <Space> ':![pipe2eval dir]/plugin/pipe2eval.sh text<CR><CR>'
```

This mapping can be customized by setting `g:pipe2eval_map_key`. For example:

```vim
  let g:pipe2eval_map_key = '<Leader>p2e'
```

### specify a mysql connection

```sql
-- hostname localhost
-- username root
-- password secret
-- database test
```

### specify a mongodb connection

```javascript
// host localhost
// port 27017
// db test
```

mongodb commands

```javascript
//> dbs
//> collections
//> version
//> status
//> status mem
//> connections
//> session
```

### special commands for shell

evaluate commands on a remote maschine

```
#> set ssh dbserver1
uptime
```

end it
```
#> set ssh
```

### c

`v<space>` to complie and run current file

passing arguments

```c
// arg1 arg2
```

### sqlite

`:Pipe2 sqlite`

```sql
-- file /path/to/sqlite3.db

.mode line
select * from table limit 1;
```
