#!/bin/bash
rm -rf /tmp/karlsend-temp

NUM_CLIENTS=128
karlsend --devnet --appdir=/tmp/karlsend-temp --profile=6061 --rpcmaxwebsockets=$NUM_CLIENTS &
KALRSEND_PID=$!
KALRSEND_KILLED=0
function killKarlsendIfNotKilled() {
  if [ $KALRSEND_KILLED -eq 0 ]; then
    kill $KALRSEND_PID
  fi
}
trap "killKarlsendIfNotKilled" EXIT

sleep 1

rpc-idle-clients --devnet --profile=7000 -n=$NUM_CLIENTS
TEST_EXIT_CODE=$?

kill $KALRSEND_PID

wait $KALRSEND_PID
KALRSEND_EXIT_CODE=$?
KALRSEND_KILLED=1

echo "Exit code: $TEST_EXIT_CODE"
echo "Karlsend exit code: $KALRSEND_EXIT_CODE"

if [ $TEST_EXIT_CODE -eq 0 ] && [ $KALRSEND_EXIT_CODE -eq 0 ]; then
  echo "rpc-idle-clients test: PASSED"
  exit 0
fi
echo "rpc-idle-clients test: FAILED"
exit 1
