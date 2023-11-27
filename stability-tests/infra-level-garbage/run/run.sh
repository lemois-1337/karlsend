#!/bin/bash
rm -rf /tmp/karlsend-temp

karlsend --devnet --appdir=/tmp/karlsend-temp --profile=6061 &
KARLSEND_PID=$!

sleep 1

infra-level-garbage --devnet -alocalhost:16611 -m messages.dat --profile=7000
TEST_EXIT_CODE=$?

kill $KARLSEND_PID

wait $KARLSEND_PID
KARLSEND_EXIT_CODE=$?

echo "Exit code: $TEST_EXIT_CODE"
echo "Karlsend exit code: $KARLSEND_EXIT_CODE"

if [ $TEST_EXIT_CODE -eq 0 ] && [ $KARLSEND_EXIT_CODE -eq 0 ]; then
  echo "infra-level-garbage test: PASSED"
  exit 0
fi
echo "infra-level-garbage test: FAILED"
exit 1
