
LOGFILE=./build/valgrind-log.txt
BINARY=./build/debug/src/parser
TESTS=`find ./tests/ -name *.v`

echo ">> Running Valgrind..."

valgrind --track-origins=yes --leak-check=full --leak-resolution=high \
    --show-leak-kinds=all --log-file=$LOGFILE $BINARY $TESTS


echo ">> Invalid Reads: `egrep "Invalid read of size" -c $LOGFILE`"
echo ">> Leaked Blocks: `egrep "blocks are still reachable" -c $LOGFILE`"

tail -n 10 $LOGFILE

echo ">> END"
