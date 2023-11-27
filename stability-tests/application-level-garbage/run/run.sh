#!/bin/bash
rm -rf /tmp/karlsend-temp

karlsend --devnet --appdir=/tmp/karlsend-temp --profile=6061 --loglevel=debug &
KARLSEND_PID=$!
KARLSEND_KILLED=0
function killKarlsendIfNotKilled() {
    if [ $KARLSEND_KILLED -eq 0 ]; then
      kill $KARLSEND_PID
    fi
}
trap "killKarlsendIfNotKilled" EXIT

sleep 1

application-level-garbage --devnet -alocalhost:16611 -b blocks.dat --profile=7000
TEST_EXIT_CODE=$?

kill $KARLSEND_PID

wait $KARLSEND_PID
KARLSEND_KILLED=1
KARLSEND_EXIT_CODE=$?

echo "Exit code: $TEST_EXIT_CODE"
echo "Karlsend exit code: $KARLSEND_EXIT_CODE"

if [ $TEST_EXIT_CODE -eq 0 ] && [ $KARLSEND_EXIT_CODE -eq 0 ]; then
  echo "application-level-garbage test: PASSED"
  exit 0
fi
echo "application-level-garbage test: FAILED"
exit 1
