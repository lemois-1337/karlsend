#!/bin/bash
rm -rf /tmp/karlsend-temp

karlsend --simnet --appdir=/tmp/karlsend-temp --profile=6061 &
KARLSEND_PID=$!

sleep 1

orphans --simnet -alocalhost:16511 -n20 --profile=7000
TEST_EXIT_CODE=$?

kill $KARLSEND_PID

wait $KARLSEND_PID
KARLSEND_EXIT_CODE=$?

echo "Exit code: $TEST_EXIT_CODE"
echo "Karlsend exit code: $KARLSEND_EXIT_CODE"

if [ $TEST_EXIT_CODE -eq 0 ] && [ $KARLSEND_EXIT_CODE -eq 0 ]; then
  echo "orphans test: PASSED"
  exit 0
fi
echo "orphans test: FAILED"
exit 1
