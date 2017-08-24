#!/bin/bash
cd tools
rm -f *.snap
rm -f *.xlog
tarantool server.lua > /dev/null 2>&1 &
tarantoolPID=$!
cd ..
pub run test
status=$?
kill $tarantoolPID
rm -f tools/*.snap
rm -f tools/*.xlog

exit $status