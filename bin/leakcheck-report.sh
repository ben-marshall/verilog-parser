
LOGFILE=./build/valgrind-log.txt
BINARY=./build/debug/src/parser
TESTS=`find ./tests/ -name *sparc*.v`

echo ">> Building Library..."

cd ./build/debug
make
cd -

echo ">> Running Valgrind..."

CMD="valgrind --track-origins=yes --leak-check=full --leak-resolution=high \
    --show-leak-kinds=all --log-file=$LOGFILE $BINARY $TESTS"
$CMD  &> ./build/log.txt


echo ">> Invalid Reads:          `egrep "Invalid read of size" -c $LOGFILE`"
echo ">> Leaked Blocks:          `egrep "blocks are still reachable" -c $LOGFILE`"
echo ">> Indirectly Lost Blocks: `egrep "blocks are indirectly lost" -c $LOGFILE`"
echo ">> Definitely Lost Blocks: `egrep "blocks are definitely lost" -c $LOGFILE`"

tail -n 10 $LOGFILE

echo ">> END"
