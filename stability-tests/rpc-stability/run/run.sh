#!/bin/bash
rm -rf /tmp/karlsend-temp

karlsend --devnet --appdir=/tmp/karlsend-temp --profile=6061 --loglevel=debug &
KARLSEND_PID=$!

sleep 1

rpc-stability --devnet -p commands.json --profile=7000
TEST_EXIT_CODE=$?

kill $KARLSEND_PID

wait $KARLSEND_PID
KARLSEND_EXIT_CODE=$?

echo "Exit code: $TEST_EXIT_CODE"
echo "Karlsend exit code: $KARLSEND_EXIT_CODE"

if [ $TEST_EXIT_CODE -eq 0 ] && [ $KARLSEND_EXIT_CODE -eq 0 ]; then
  echo "rpc-stability test: PASSED"
  exit 0
fi
echo "rpc-stability test: FAILED"
exit 1
