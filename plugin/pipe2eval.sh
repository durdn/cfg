#!/bin/bash

# TODO
# * each buffer should has it's own context

INPUT_LANG=$1
INPUT_FILE="$2"

if [ -z "$PIP2EVAL_TMP_FILE_PATH" ]; then
	PIP2EVAL_TMP_FILE_PATH=/dev/shm/
fi
PREFIX=repl
TMP_FILE=$PIP2EVAL_TMP_FILE_PATH$PREFIX.$INPUT_LANG


fn_exists(){
	declare -F $1 &> /dev/null
	return $?
}

fn_call(){
	if fn_exists $INPUT_LANG\_$1; then
		$INPUT_LANG\_$1 ${@:2}
	else
		default_$1 ${@:2}
	fi
}

process_commands(){
	cmd="$( sed -n '1 s/^[#\/;-]\{1,2\}> \([a-zA-Z0-9_-]\+\) \?\(.*\)\?$/\1/p' < $TMP_FILE.new)"
	args="$(sed -n '1 s/^[#\/;-]\{1,2\}> \([^ ]\+\) \(.*\)$/\2/p' < $TMP_FILE.new)"
	if [ -n "$cmd" ]; then
		fn_call command_$cmd "$args"
		exit 0
	fi
}

hr() {
	echo -n "$1"
	pad=$(printf '%0.1s' "-"{1..80})
	padlen=$((80 - ${#1} - ${#2}))
	printf '%0.*s' $padlen $pad
	echo "$2"
}

# commands ---------------------------------------------------------------------

default_command_files(){
	find $PIP2EVAL_TMP_FILE_PATH -maxdepth 1 -name "$PREFIX.$INPUT_LANG*"
}

default_command_reset(){
	find $PIP2EVAL_TMP_FILE_PATH -maxdepth 1 -name "$PREFIX.$INPUT_LANG*" -exec rm -f {} \;
}

default_command_set(){
	if [ -n "$1" ]; then
		echo $2 > $TMP_FILE.$1
	fi
}


# default ----------------------------------------------------------------------

default_comment(){
	# do nothing
	:
}

default_init(){
	fn_call reset > /dev/null
}

default_reset(){
	> $TMP_FILE
	> $TMP_FILE.error
	echo '# context cleared'
}

default_error(){
	echo "# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	sed -e 's/^\(.*\)$/#     \1/' < "$TMP_FILE.error"
	echo "# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
}

default_merge(){
	# do nothing
	:
}

default_eval(){
	cat $TMP_FILE "$TMP_FILE.new" |  $INPUT_LANG - 2> "$TMP_FILE.error" |\
		sed -e 's/^\(.*\)$/# \1/'
}

# php --------------------------------------------------------------------------

php_reset(){
	echo '<?php ' > $TMP_FILE
}

php_eval(){
	fns=$(sed -n "s/^function \+\([^(]\+\).*$/\1/p" < "$TMP_FILE.new")
	for fn in $fns; do
		sed -i "s/^function \+\($fn\) *(/function \1$(date +%s)(/" "$TMP_FILE"
	done

	classes=$(sed -n "s/ *class \+\([^ ]\+\).*$/\1/p" < "$TMP_FILE.new")
	for cls in $classes; do
		sed -i "s/ *class \+\($cls\)/ class \1$(date +%s)/" "$TMP_FILE"
	done

	cat $TMP_FILE "$TMP_FILE.new" |\
		sed '$! b
			/^[ \t]*[})]/ b
			s/\(.*\);/var_export(\1);/' |\
		tee $TMP_FILE.eval |\
		php 2> "$TMP_FILE.error" | sed -e 's/^\(.*\)$/# \1/'
}

php_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

# python -----------------------------------------------------------------------

python_reset(){
	echo 'import pprint' > $TMP_FILE
	echo '# context cleared'
}

python_eval(){
	tail -1 $TMP_FILE.new | grep -q '^\s*\(return\|import\|from\)'

	if [ $? -eq 0 ]; then
		cat $TMP_FILE $TMP_FILE.new | $INPUT_LANG - 2> $TMP_FILE.error |\
			sed -e 's/^\(.*\)$/# \1/'
	else
		cat $TMP_FILE $TMP_FILE.new | sed -e '/^$/d' |\
			sed '$ s/^[^ \t].*$/____ =&\
\pprint.pprint(____)\
\____/' | $INPUT_LANG - 2> $TMP_FILE.error |\
			sed -e 's/^\(.*\)$/# \1/'
	fi
}

python_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

# coffeescript -----------------------------------------------------------------

coffee_eval(){
	cat $TMP_FILE $TMP_FILE.new |\
		sed -e '/^$/d' |\
		sed '$ s/^\([ \t]*\)\(.*\)$/\1____ =\2\
\1console.log ____\
\1____/' > $TMP_FILE.eval
	$INPUT_LANG $TMP_FILE.eval 2> $TMP_FILE.error | sed -e 's/^\(.*\)$/# \1/'
}

coffee_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

# livescript ------------------------------------------------------------------

ls_eval(){
	cat $TMP_FILE $TMP_FILE.new |\
		sed -e '/^$/d' |\
		sed '$ s/^\([ \t]*\)\(.*\)$/\1____ =\2\
\1console.log ____\
\1____/' > $TMP_FILE.eval
	livescript $TMP_FILE.eval 2> $TMP_FILE.error | sed -e 's/^\(.*\)$/# \1/'
}

ls_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

# javascript -------------------------------------------------------------------

javascript_eval(){
	cat $TMP_FILE $TMP_FILE.new |\
		sed -e '/^$/d' |\
		sed '$! b
			/^[ \t]*[})]/ b
			s/\(.*\);/console.log(\1);/' > $TMP_FILE.eval
	node --harmony $TMP_FILE.eval 2> $TMP_FILE.error | sed -e 's/^\(.*\)$/\/\/ \1/'
}

javascript_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

# ruby -------------------------------------------------------------------------

ruby_eval(){
	cat $TMP_FILE $TMP_FILE.new | sed -e '/^$/d' |\
		sed '$! b
			/^[ \t]*end/ b
			s/^\([ \t]*\)\(.*\)$/\
\1____ =\2\
\1puts ____.inspect\
\1____/' |\
		$INPUT_LANG - 2> $TMP_FILE.error | sed -e 's/^\(.*\)$/# \1/'
}

ruby_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

# elixir -----------------------------------------------------------------------

elixir_eval(){
	cat $TMP_FILE $TMP_FILE.new | sed -e '/^$/d' |\
		sed '$! b
			/^[ \t]*end/ b
			s/^\([ \t]*\)\(.*\)$/\
\1____ =\2\
\1IO.puts inspect ____\
\1____/' > $TMP_FILE.eval
		$INPUT_LANG $TMP_FILE.eval 2> $TMP_FILE.error | sed -e 's/^\(.*\)$/# \1/'
}

elixir_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

# lua --------------------------------------------------------------------------

lua_eval(){
	cat $TMP_FILE $TMP_FILE.new | sed -e '/^$/d' |\
		sed '$! b
			/^[ \t]*end/ b
			s/^\([ \t]*\)\(.*\)$/\
\1____ =\2\
\1print(____)/' |\
		$INPUT_LANG - 2> $TMP_FILE.error | sed -e 's/^\(.*\)$/-- \1/'
}

lua_merge(){
	cat "$TMP_FILE.new" >> $TMP_FILE;
}

lua_reset(){
	> $TMP_FILE
	> $TMP_FILE.error
	echo '-- context cleared'
}

# go ---------------------------------------------------------------------------

go_reset(){
	go_eval
}

go_eval(){
	hr "// "
	$INPUT_LANG run "$INPUT_FILE" | sed -e 's/^\(.*\)$/\/\/ \1/'
}

# rust -------------------------------------------------------------------------

rust_eval(){
	sed -i '/^\/\//d' $TMP_FILE.new
	$INPUT_LANG run $TMP_FILE.new | sed -e 's/^\(.*\)$/\/\/ \1/'
}

# haskell ----------------------------------------------------------------------

haskell_reset(){
	> $TMP_FILE
	> $TMP_FILE.error
	echo '-- context cleared'
}

haskell_eval(){
	if grep -q '^main' $TMP_FILE.new; then
		cat $TMP_FILE "$TMP_FILE.new" |\
			runhaskell 2> "$TMP_FILE.error" | sed -e 's/^\(.*\)$/-- \1/'
	fi
}

# haskell_merge(){
# 	cat "$TMP_FILE.new" | sed '/^main/,$ d' >> $TMP_FILE;
# }

# c ----------------------------------------------------------------------------

c_reset(){
	c_eval
}

c_eval(){
	argv="$(sed -n 's/\s*\/\/// p' $TMP_FILE.new)"
	cc -Wall -g "$INPUT_FILE" -o "$TMP_FILE.o"
	hr "// "
	"$TMP_FILE.o" $argv 2> "$TMP_FILE.error" | sed -e 's/^\(.*\)$/\/\/ \1/'
}

# bash -------------------------------------------------------------------------

bash_eval(){
	if [ -f $TMP_FILE.ssh ]; then
		host="$(cat $TMP_FILE.ssh)"
		if [ -n "$host" ]; then
			ssh $host "bash -s" < $TMP_FILE.new 2> $TMP_FILE.error | sed -e 's/.*/# &/'
		else
			rm $TMP_FILE.ssh
			bash $TMP_FILE.new 2> $TMP_FILE.error | sed -e 's/.*/# &/'
		fi
	else
		bash $TMP_FILE.new 2> $TMP_FILE.error | sed -e 's/.*/# &/'
	fi
}

# markdown ---------------------------------------------------------------------

markdown_eval(){
	markdown $TMP_FILE.new
}

# mongo ------------------------------------------------------------------------

mongo_exec(){
	[ -f $TMP_FILE.host ] && host=$(cat $TMP_FILE.host) || host=127.0.0.1
	[ -f $TMP_FILE.port ] && port=$(cat $TMP_FILE.port) || port=27017
	[ -f $TMP_FILE.db ] && db=$(cat $TMP_FILE.db)
	mongo --quiet --host $host --port $port $db $TMP_FILE.eval
}

mongo_eval(){
	db=$(sed -ne 's/^use \([a-zA-Z0-9_-]\+\)$/\1/p' < $TMP_FILE.new)
	if [ -n "$db" ]; then
		echo $db > $TMP_FILE.db
		exit 0
	fi

	db=$(sed -ne 's/^\/\/ db \([a-zA-Z0-9_-]\+\)$/\1/p' < $TMP_FILE.new)
	host=$(sed -ne 's/^\/\/ host \([a-zA-Z0-9._-]\+\)$/\1/p' < $TMP_FILE.new)
	port=$(sed -ne 's/^\/\/ port \([a-zA-Z0-9._-]\+\)$/\1/p' < $TMP_FILE.new)

	[ -n "$host" ] && echo $host > $TMP_FILE.host
	[ -n "$port" ] && echo $port > $TMP_FILE.port
	[ -n "$db" ] && echo $db > $TMP_FILE.db

	sed -e 's/^\(db\..*\)/var ____ = \1/' \
		-e '$ a \
if("undefined" != typeof ____ && null != ____){\
	if("function" == typeof ____.toArray){\
		____ = ____.toArray()\
		if (____.length == 1){\
			____ = ____[0]\
		}else{\
			print("items:" + ____.length)\
		}\
	}\
	if(Array.isArray(____) && ____.length > 20){\
		printjson(____.slice(0,20))\
		print("...")\
	}else{\
		printjson(____)\
	}\
}' > $TMP_FILE.eval < $TMP_FILE.new
	mongo_exec
}

mongo_command_version(){
	echo 'print(db.version())' > $TMP_FILE.eval
	mongo_exec
}

mongo_command_dbs(){
	echo 'printjson(db.getMongo().getDBNames())' > $TMP_FILE.eval
	mongo_exec
}

mongo_command_collections(){
	echo 'printjson(db.getCollectionNames())' > $TMP_FILE.eval
	mongo_exec
}

mongo_command_connections(){
	echo 'db.currentOp(true).inprog.forEach(function(o){print(o.client)});' > $TMP_FILE.eval
   mongo_exec | cut -d ':' -f 1 | sort | uniq -c | sort -rn
}

mongo_command_session(){
	[ -f $TMP_FILE.host ] && host=$(cat $TMP_FILE.host) || host=127.0.0.1
	[ -f $TMP_FILE.port ] && port=$(cat $TMP_FILE.port) || port=27017
	[ -f $TMP_FILE.db ] && db=$(cat $TMP_FILE.db)

	echo "host $host"
	echo "port $port"
	echo "db $db"
}

mongo_command_status(){
	if [ -n "$1" ]; then
		echo "printjson(db.serverStatus().$1)" > $TMP_FILE.eval
	else
		echo "printjson(db.serverStatus())" > $TMP_FILE.eval
	fi
	mongo_exec
}

# sql --------------------------------------------------------------------------

sql_eval(){
	host=`sed -ne 's/^-- host \([a-zA-Z0-9._-]\+\)$/\1/p' < $TMP_FILE.new`
	user=`sed -ne 's/^-- user \([a-zA-Z0-9._-]\+\)$/\1/p' < $TMP_FILE.new`
	password=`sed -ne 's/^-- password \([a-zA-Z0-9._#$-]\+\)$/\1/p' < $TMP_FILE.new`
	db=`sed -ne 's/^use \([a-z0-9_-]\+\);\?$/\1/ip' < $TMP_FILE.new`
	if [ -z "$db" ]; then
		db=`sed -ne 's/^-- database \([a-z0-9_-]\+\)$/\1/ip' < $TMP_FILE.new`
	fi

	HOST_SAVED=$TMP_FILE.host
	USER_SAVED=$TMP_FILE.user
	PASSWORD_SAVED=$TMP_FILE.password
	DB_SAVED=$TMP_FILE.db

	if [ -n "$host" ]; then
		echo $host > $HOST_SAVED
		> $DB_SAVED
	fi
	if [ -n "$user" ]; then
		echo $user > $USER_SAVED
	fi
	if [ -n "$password" ]; then
		echo $password > $PASSWORD_SAVED
	fi
	if [ -n "$db" ]; then
		echo $db > $DB_SAVED
	fi

	_USER="`cat $USER_SAVED`"
	_PASSWORD="`cat $PASSWORD_SAVED`"
	_HOST="`cat $HOST_SAVED`"
	if [ -f "$DB_SAVED" ]; then
		_DB="`cat $DB_SAVED`"
	fi

	#TODO use || ?
	_PIPE=`sed -n '$ s/[^|]*|\(.*\)/\1/p' < $TMP_FILE.new`
	if [ -n "$_PIPE" ]; then
		sed -i '$ s/\([^|]*\).*/\1/' $TMP_FILE.new
		mysql -t -u$_USER -p$_PASSWORD -h$_HOST $_DB < $TMP_FILE.new | $_PIPE
	else
		# DATABASE can be empty
		mysql -t -u$_USER -p$_PASSWORD -h$_HOST $_DB < $TMP_FILE.new |\
			sed -e 's/^\(.*\)$/-- \1/'
	fi
}

# sqlite -----------------------------------------------------------------------

sqlite_eval(){
	file=`sed -ne 's/^-- file \(.*\)$/\1/p' < $TMP_FILE.new`

	FILE_SAVED=$TMP_FILE.file

	if [ -n "$file" ]; then
		echo $file > $FILE_SAVED
	fi

	_FILE="`cat $FILE_SAVED`"

	sqlite3 "$_FILE" < $TMP_FILE.new |\
		sed -e 's/^\(.*\)$/-- \1/'
}


# xml --------------------------------------------------------------------------

xml_eval(){
	sed -e 's/^[^<]*//' -e 's/[^>]*$//' | xml_pp
}

# redis ------------------------------------------------------------------------

redis_eval(){
	redis-cli -x < $TMP_FILE.new
}


# json -------------------------------------------------------------------------

json_eval(){
	python -mjson.tool < $TMP_FILE.new
}

# yaml -------------------------------------------------------------------------

yaml_eval(){
	ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(STDIN.read))' \
		< $TMP_FILE.new 2> "$TMP_FILE.error" | sed -e 's/^\(.*\)$/# \1/'
}

# html -------------------------------------------------------------------------

html_eval(){
	html2text < $TMP_FILE.new
}

# R ----------------------------------------------------------------------------

r_eval(){
	R --vanilla <$TMP_FILE.new> $TMP_FILE.out
	sed -n '20,$p' $TMP_FILE.out | sed -ne 's/^\([^>].*\)$/# \1/p'
}

# main -------------------------------------------------------------------------

main(){
	tee $TMP_FILE.new

	if [ ! -f "$TMP_FILE" ]; then
		fn_call 'init'
	fi

	if [ -z "$(sed '/^$/d' < "$TMP_FILE.new")" ]; then
		fn_call 'reset'
		exit 0
	fi

	process_commands

	fn_call 'eval'

	if [ -s "$TMP_FILE.error" ]; then
		fn_call 'error'
	else
		fn_call 'merge'
	fi
}

main
