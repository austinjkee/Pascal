#! /bin/bash

echo 'Boris Ermakov-Spektor and Austin Kee'
echo 'COP 4020'
echo 'Pascal Interpreter Testing Harness for Project 2'

echo "----"
echo 'Compiling Pascal interpreter'
echo "----"
gradle installDist

if [ $? -ne 0 ]
then
    echo "ERROR: Compilation failed!"
    exit
fi

echo "----"
echo "Beginning tests"
echo "----"

src_extension=".pas"
in_extension=".in"
out_extension=".out"
passed=0
total=0

test_dir="src/test"

for i in "$test_dir"/*"$src_extension"; do
    testname=${i//"$test_dir/"/}
    infile=${i//$src_extension/$in_extension}
    outfile=${i//$src_extension/$out_extension}

    if [ -f "$infile" ]; then
        result=$(build/install/Pascal2/bin/Pascal2 "${i}" < "$infile")
    else
        result=$(build/install/Pascal2/bin/Pascal2 "${i}")
    fi

    if [ ! -f "$outfile" ]; then
        echo "ERROR: No outfile for $testname"
        exit
    fi

    expected_result=$(cat "$outfile")

    total=$((total+1))

    echo "----"

    if [ "$result" == "$expected_result" ]
    then
        passed=$((passed+1))
        echo "$testname PASSED!"
    else
        echo "$testname FAILED!"
        echo "DIFF FOR $testname"
        diff -u <(echo "$result") <(echo "$expected_result")
    fi;

    echo "----"

done

failed=$((total-passed))

echo "$passed TESTS PASSED"
echo "$failed TESTS FAILED"