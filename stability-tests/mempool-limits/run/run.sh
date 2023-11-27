#!/bin/bash

APPDIR=/tmp/karlsend-temp
KARLSEND_RPC_PORT=29587

rm -rf "${APPDIR}"

karlsend --simnet --appdir="${APPDIR}" --rpclisten=0.0.0.0:"${KARLSEND_RPC_PORT}" --profile=6061 &
KARLSEND_PID=$!

sleep 1

RUN_STABILITY_TESTS=true go test ../ -v -timeout 86400s -- --rpc-address=127.0.0.1:"${KARLSEND_RPC_PORT}" --profile=7000
TEST_EXIT_CODE=$?

kill $KARLSEND_PID

wait $KARLSEND_PID
KARLSEND_EXIT_CODE=$?

echo "Exit code: $TEST_EXIT_CODE"
echo "Karlsend exit code: $KARLSEND_EXIT_CODE"

if [ $TEST_EXIT_CODE -eq 0 ] && [ $KARLSEND_EXIT_CODE -eq 0 ]; then
  echo "mempool-limits test: PASSED"
  exit 0
fi
echo "mempool-limits test: FAILED"
exit 1
