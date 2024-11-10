#!/bin/sh

echo 'dangling-switch/results/DanglingSwitch/**/*.output | grep -A 1 "Are equal?" | grep True | wc'
cat dangling-switch/results/DanglingSwitch/**/*.output | grep -A 1 "Are equal?" | grep True | wc
echo 'dangling-switch/results/DanglingSwitch/**/*.output | grep -A 1 "Are equal?" | grep False | wc'
cat dangling-switch/results/DanglingSwitch/**/*.output | grep -A 1 "Are equal?" | grep False | wc

echo 'return/results/Return/**/*.output | grep -A 1 "Are equal?" | grep True | wc'
cat return/results/Return/**/*.output | grep -A 1 "Are equal?" | grep True | wc
echo 'return/results/Return/**/*.output | grep -A 1 "Are equal?" | grep False | wc'
cat return/results/Return/**/*.output | grep -A 1 "Are equal?" | grep False | wc

echo 'gotos-density/results/GotosDensity/**/*.output | grep -A 1 "Are equal?" | grep True | wc'
cat gotos-density/results/GotosDensity/**/*.output | grep -A 1 "Are equal?" | grep True | wc
echo 'gotos-density/results/GotosDensity/**/*.output | grep -A 1 "Are equal?" | grep False | wc'
cat gotos-density/results/GotosDensity/**/*.output | grep -A 1 "Are equal?" | grep False | wc

echo 'case-termination/results/CaseTermination/**/*.output | grep -A 1 "Are equal?" | grep True | wc'
cat case-termination/results/CaseTermination/**/*.output | grep -A 1 "Are equal?" | grep True | wc
echo 'case-termination/results/CaseTermination/**/*.output | grep -A 1 "Are equal?" | grep False | wc'
cat case-termination/results/CaseTermination/**/*.output | grep -A 1 "Are equal?" | grep False | wc

echo 'return-average/results/ReturnAverage/**/*.output | grep -A 1 "Are equal?" | grep True | wc'
cat return-average/results/ReturnAverage/**/*.output | grep -A 1 "Are equal?" | grep True | wc
echo 'return-average/results/ReturnAverage/**/*.output | grep -A 1 "Are equal?" | grep False | wc'
cat return-average/results/ReturnAverage/**/*.output | grep -A 1 "Are equal?" | grep False | wc

echo 'call-density/results/CallDensity/**/*.output | grep -A 1 "Are equal?" | grep True | wc'
cat call-density/results/CallDensity/**/*.output | grep -A 1 "Are equal?" | grep True | wc
echo 'call-density/results/CallDensity/**/*.output | grep -A 1 "Are equal?" | grep False | wc'
cat call-density/results/CallDensity/**/*.output | grep -A 1 "Are equal?" | grep False | wc
