echo "`hostname -s`,`cat /proc/cpuinfo | egrep -o -m 1 '(sse|avx|fma)[^ ]*' | tr '\n' ',' | sed 's/,$//'`" 