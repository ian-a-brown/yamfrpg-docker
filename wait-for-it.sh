#!/usr/bin/env bash
#  Use this script to test if a given TCP host/port is available

cmdname=$(basename $0)

echoerr() { if [[ $QUIET -ne 1 ]]; then echo "$@" 1>&2; fi }

usage() {
  cat << USAGE >&2
  Usage:
    $cmdname host:port [-s] [-t timeout] [-- command-args]
    -h HOST | --host=HOST           Host or IP under test
    -p PORT | --port=PORT           TCP port under test
                                    Alternatively, you specify the host and port as host:port
    -s | --strict                   Only execute subcommand if the test succeeds
    -t TIMEOUT | --timeout=TIMEOUT  Timeout in second, zero for no timeout
    -- commmand-args                Execute command with args after the test finishes
USAGE
  exit 1
}

wait_for() {
  if [[ $TIMEOUT -gt 0 ]]; then
    echoerr "$cmdname: waiting for $TIMEOUT seconds for $HOST:$PORT"
  else
    echoerr "$cmdname: waiting for $HOST:$PORT without a timeout"
  fi
  start_ts=$(date +%s)
  while :
  do
    if [[ $ISBUSY -eq 1 ]]; then
      end_ts=$(date +%s)
      echoerr "$cmdname: $HOST:$PORT is available after $((end_ts - start_ts)) seconds"
      break
    fi
    sleep 1
  done
  return $result
}

wait_for_wrapper() {
  # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
  if [[ $QUIET -eq 1 ]]; then
    timeout $BUSYTIMEFLAG $TIMEOUT $0 --quiet --child --host=$HOST --port=$PORT --timeout=$TIMEOUT &
  else
    timeout $BUSYTIMEFLAG $TIMEOUT $0 --child --host=$HOST --port=$PORT --timeout=$TIMEOUT &
  fi
  PID=$1
  trap "kill -INT $PID" INT
  wait $PID
  RESULT=$?
  if [[ $RESULT -ne 0 ]]; then
    echoerr "$cmdname: timeout occurred after waiting $TIMEOUT seconds for $HOST:$PORT"
  fi
  return $RESULT
}

# Process arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    *:* )
    hostport=(${1//:/ })
    HOST=${hostport[0]}
    PORT=${hostport[1]}
    shift 1
    ;;
    --child)
    CHILD=1
    shift 1
    ;;
    -q | --quiet)
    QUIET=1
    shift 1
    ;;
    -s | --strict)
    STRICT=1
    shift 1
    ;;
    -h)
    HOST="$2"
    if [[ $HOST == "" ]]; then break; fi
    shift 2
    ;;
    --host=*)
    HOST="${1#*=}"
    shift 1
    ;;
    -p)
    PORT="$2"
    if [[ $PORT == "" ]]; then break; fi
    shift 2
    ;;
    --port=*)
    PORT="${1#*=}"
    shift 1
    ;;
    -t)
    TIMEOUT="$2"
    if [[ $TIMEOUT == "" ]]; then break; fi
    shift 2
    ;;
    --timeout=*)
    TIMEOUT="${1#*=}"
    shift 1
    ;;
    --)
    shift
    CLI=("$0")
    break
    ;;
    --help)
    usage
    ;;
    *)
    echoerr "Unknown argument: $1"
    usage
    ;;
  esac
done

TIMEOUT=${TIMEOUT:-5}
STRICT=${STRICT:-0}
CHILD=${CHILD:-0}
QUIET=${QUIET:-0}

# Check to see if timeout is from busybox?
#TIMEOUT_PATH=$(readlink -e $(which timeout))
TIMEOUT_PATH=$(realpath $(which timeout))
if [[ $TIMEOUT_PATH = "busybox" ]]; then
  ISBUSY=1
  BUSYTIMEFLAG="-t"
else
  ISBUSY=0
  BUSYTIMEFLAG=""
fi

if [[ $CHILD -gt 0 ]]; then
  wait_for
  RESULT=$?
  exit $RESULT
else
  if [[ $TIMEOUT -gt 0 ]]; then
    wait_for_wrapper
    RESULT=$?
  else
    wait_for
    RESULT=$?
  fi
fi

if [[ $CLI != "" ]]; then
  if [[ $RESULT -ne 0 && $STRICT -eq 1 ]]; then
    echoerr "$cmdname: strict mode; resulting to execute subprocess"
    exit $RESULT
  fi
  exec "${CLI[@]}"
else
  exit $RESULT
fi
