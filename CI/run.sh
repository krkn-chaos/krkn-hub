set -x

rm -rf results.markdown
# Clean up our created directories
rm -rf test_* ci_results gold outputs/*

test_rc=0

sed 's/.sh//g' CI/tests/all_tests > CI/tests/my_tests

# Create a "gold" directory based off the current branch
rsync -av --progress `pwd`/ `pwd`/gold

test_list=`cat CI/tests/my_tests`

echo "running test suit consisting of ${test_list}"

# Prep the results.markdown file
echo 'Test                   | Result | Duration' >> results.markdown
echo '-----------------------|--------|---------' >> results.markdown

# Create individual directories for each testd
for ci_dir in `cat CI/tests/my_tests`
do
    rsync -a `pwd`/gold/ `pwd`/$ci_dir
done

# Run each test
for test_name in `cat CI/tests/my_tests`
do
  ./CI/run_test.sh $test_name
done

# Update markdown file
for test_dir in `cat CI/tests/my_tests`
do
  cat $test_dir/results.markdown >> results.markdown
  cat $test_dir/ci_results >> ci_results
done

# Get number of successes/failures
testcount=`wc -l ci_results`
success=`grep Successful ci_results | awk -F ":" '{print $1}'`
failed=`grep Failed ci_results | awk -F ":" '{print $1}'`
failcount=`grep -c Failed ci_results`

if [ `grep -c Failed ci_results` -gt 0 ]
then
  test_rc=1
fi

test_folders=$(ls | grep "test_")

for test_folder in $test_folders;
do
  cp $test_folder/test_*.out outputs/
done


# Clean up our created directories
rm -rf test_* ci_results

cat results.markdown

exit $test_rc

