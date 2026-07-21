# 1> : Redirect stdout to a file (overwrite)
echo "Hello" 1>/tmp/output.txt
echo "Hello" >/tmp/output1.txt

# 2> : Redirect stderr to a file (overwrite)
ls /nonexistent 2>/tmp/error.txt

# &> : Redirect both stdout and stderr to a file (overwrite)
ls /tmp /nonexistent &>/tmp/both.txt

# >> : Append to a file instead of overwrite
echo "Line 1" > /tmp/append.txt
echo "Line 2" >> /tmp/append.txt
echo "Line 3" >> /tmp/append.txt
cat /tmp/append.txt

# &>/dev/null : Discard all output
ls /nonexistent &>/dev/null
echo "Error was discarded using /dev/null"




echo $?

lssss
echo $?

echo $#
echo $1
