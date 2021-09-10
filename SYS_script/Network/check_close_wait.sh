#/bin/bash
#
# Check the CLOSE_WAIT count of each process
#
JAVALIST=`ps -ef | grep java | grep -v "00:00:00" | awk '{print $2}'`
for JAVAPID in $JAVALIST
do
   CWCOUNT=`netstat -p | grep CLOSE_WAIT | grep $JAVAPID | wc -l`
   JNAME=`ps -efww | grep $JAVAPID | grep java | awk '{print $(NF-2)}'`
   printf "%3d \t %s (pid=%s)\n" $CWCOUNT $JNAME $JAVAPID
done
TOTALCOUNT=`netstat -p | grep CLOSE_WAIT | grep java  | wc -l`
echo "==="
echo "$TOTALCOUNT"
