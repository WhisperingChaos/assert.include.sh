#!/bin/bash
source "base/assert.source.sh"
test_ASSERT_RAISED='false'

test_assert_true(){

	if ! assert_true '[ 1 -eq 1 ]' ; then
		test_failure_msg
	fi
	if ! assert_true '[ 1 -eq 0 ]' 2>&1 \
		| test_compare_output test_assert_true_false; then
		test_failure_msg
	fi
	assert__condition_code_set 100
	if ! assert_true '[ $? -eq 100 ]'; then
		test_failure_msg
	fi
	test_assert_true_argument_forwarding 'arg_1' 'arg_2' 
	if ! assert_true '[ "$( echo Hi)" == "Hi" ]' ; then
		test_failure_msg
	fi
	if ! assert_true '[ "$( echo Hi)" == "by" ]' 2>&1 \
		| test_compare_output test_assert_true_expand_only_variables ; then
		test_failure_msg
	fi
	local hiThere='Hi there'
	if ! assert_true '[ "$( echo "$hiThere")" == "by" ]' 2>&1 \
		| test_compare_output test_assert_true_expand_only_variables_hiThere ; then
		test_failure_msg
	fi
	local subShellCmd='false'
	if ! assert_true '( $subShellCmd; )' 2>&1 \
		| test_compare_output test_assert_true_subshell_ignore ; then
		test_failure_msg
	fi
	local subShellCmd='false'
	if ! assert_true '( $subShellCmd; ) || ( $subShellCmd; ) || ( $subShellCmd; )' 2>&1 \
		| test_compare_output test_assert_true_subshell_or_ignore ; then
		test_failure_msg
	fi
	local subShellCmd='true'
	local subShellCmdfalse='false'
	if ! assert_true '( $subShellCmd; ) && ( $subShellCmd; ) && ( $subShellCmdfalse; ) && ( $subShellCmd; )' 2>&1	\
		| test_compare_output test_assert_true_subshell_and_ignore; then
		test_failure_msg
	fi

	local diffOut
	diffOut="$(test_assert_true_pipe_ignore 2>&1)"
	if [ $? -ne 0 ]; then
		echo "$diffOut" >&2
		test_failure_msg
	fi
}
test_assert_true_argument_forwarding(){
	if ! assert_true '[ "$1" == "arg_1" ] && [ "$2" == "arg_2" ]' "${@}"; then
		test_failure_msg
	fi
}
test_assert_true_false(){
cat <<BODY
msg='assert_true failed'
 +  expression=  [ 1 -eq 0 ]
 +  evalExpres=  [ 1 -eq 0 ]
 +  lineNo=10
 +  source='./assert.source_test.sh' func='test_assert_true'
BODY
}
test_assert_true_expand_only_variables(){
cat <<BODY
msg='assert_true failed'
 +  expression=  [ "\$( echo Hi)" == "by" ]
 +  evalExpres=  [ "$\( echo Hi\)" == "by" ]
 +  lineNo=21
 +  source='./assert.source_test.sh' func='test_assert_true'
BODY
}
test_assert_true_expand_only_variables_hiThere(){
cat <<BODY
msg='assert_true failed'
 +  expression=  [ "\$( echo "\$hiThere")" == "by" ]
 +  evalExpres=  [ "$\( echo "Hi there"\)" == "by" ]
 +  lineNo=25
 +  source='./assert.source_test.sh' func='test_assert_true'
BODY
}
test_assert_true_read(){
	read -r input
	[ "$input" == "$1" ]
}
test_assert_true_subshell_ignore(){
cat <<BODY
msg='assert_true failed'
 +  expression=  ( \$subShellCmd; )
 +  evalExpres=  \( false; \)
 +  lineNo=32
 +  source='./assert.source_test.sh' func='test_assert_true'
BODY
}
test_assert_true_subshell_or_ignore(){
cat <<BODY
msg='assert_true failed'
 +  expression=  ( \$subShellCmd; ) || ( \$subShellCmd; ) || ( \$subShellCmd; )
 +  evalExpres=  \( false; \) \|\| \( false; \) \|\| \( false; \)
 +  lineNo=37
 +  source='./assert.source_test.sh' func='test_assert_true'
BODY
}
test_assert_true_subshell_and_ignore(){
cat <<BODY
msg='assert_true failed'
 +  expression=  ( \$subShellCmd; ) && ( \$subShellCmd; ) && ( \$subShellCmdfalse; ) && ( \$subShellCmd; )
 +  evalExpres=  \( true; \) && \( true; \) && \( false; \) && \( true; \)
 +  lineNo=43
 +  source='./assert.source_test.sh' func='test_assert_true'
BODY
}
test_assert_true_pipe_ignore(){
	local hiThere='Hi'
	assert_true 'echo "$hiThere" | test_assert_true_read "nomatch"' 2>&1	\
	| test_compare_output_tee test_assert_true_no_pipe_execution			\
	| test_compare_output_tee test_assert_true_no_pipe_execution_2			\
	| test_compare_output test_assert_true_no_pipe_execution_3
	local -r rtnPipe="${PIPESTATUS[1]} ${PIPESTATUS[2]} ${PIPESTATUS[3]}"
	[ "$rtnPipe" != "1 1 1" ]
}
test_assert_true_no_pipe_execution(){
cat <<BODY
msg='assert_true failed'
 +  expression=  echo "\$hiThere" | test_assert_true_read "nomatch"
 +  evalExpres=  echo "Hi" \| test_assert_true_read "nomatch"
 +  lineNo=28
 +  source='./assert.source_test.sh' func='test_assert_true_pipe_ignore'
BODY
}
test_assert_true_no_pipe_execution_2(){
cat <<BODY
msg='assert_true failed'
 +  expression=  echo "\$hiThere" | test_assert_true_read "nomatch"
 +  evalExpres=  echo "Hi" \| test_assert_true_read "nomatch"
 +  lineNo=28
 +  source='./assert.source_test.sh' func='test_assert_true_pipe_ignore'
BODY
}
test_assert_true_no_pipe_execution_3(){
cat <<BODY
msg='assert_true failed'
 +  expression=  echo "\$hiThere" | test_assert_true_read "nomatch"
 +  evalExpres=  echo "Hi" \| test_assert_true_read "nomatch"
 +  lineNo=28
 +  source='./assert.source_test.sh' func='test_assert_true_pipe_ignore'
BODY
}


test_assert_true_detailed(){
	test_assert_true_false_detailed
	test_assert_true_expand_only_variables_detailed
	test_assert_true_expand_only_variables_hiThere_detailed
	test_assert_true_subshell_ignore_detailed
	test_assert_true_subshell_or_ignore_detailed
	test_assert_true_subshell_and_ignore_detailed
	test_assert_true_no_pipe_execution_detailed
	test_assert_true
}
test_assert_true_false_detailed(){
	test_assert_true_false(){
cat <<BODY
msg='assert_true failed'
 +  expression=  [ 1 -eq 0 ]
 +  see set -x output below:
 +  lineNo=10
 +  source='./assert.source_test.sh' func='test_assert_true'
++ assert__condition_code_set 0
++ return 0
++ eval '[' 1 -eq 0 ']'
+++ '[' 1 -eq 0 ']'
BODY
}
}
test_assert_true_expand_only_variables_detailed(){
	test_assert_true_expand_only_variables(){
cat <<BODY
msg='assert_true failed'
 +  expression=  [ "\$( echo Hi)" == "by" ]
 +  see set -x output below:
 +  lineNo=21
 +  source='./assert.source_test.sh' func='test_assert_true'
++ assert__condition_code_set 0
++ return 0
++ eval '[' '"\$(' echo 'Hi)"' == '"by"' ']'
++++ echo Hi
+++ '[' Hi == by ']'
BODY
}
}
test_assert_true_expand_only_variables_hiThere_detailed(){
	test_assert_true_expand_only_variables_hiThere(){
cat <<BODY
msg='assert_true failed'
 +  expression=  [ "\$( echo "\$hiThere")" == "by" ]
 +  see set -x output below:
 +  lineNo=25
 +  source='./assert.source_test.sh' func='test_assert_true'
++ assert__condition_code_set 0
++ return 0
++ eval '[' '"\$(' echo '"\$hiThere")"' == '"by"' ']'
++++ echo 'Hi there'
+++ '[' 'Hi there' == by ']'
BODY
}
}
test_assert_true_subshell_ignore_detailed(){
test_assert_true_subshell_ignore(){
cat <<BODY
msg='assert_true failed'
 +  expression=  ( \$subShellCmd; )
 +  see set -x output below:
 +  lineNo=32
 +  source='./assert.source_test.sh' func='test_assert_true'
++ assert__condition_code_set 0
++ return 0
++ eval '(' '\$subShellCmd;' ')'
+++ false
BODY
}
}
test_assert_true_subshell_or_ignore_detailed(){
test_assert_true_subshell_or_ignore(){
cat <<BODY
msg='assert_true failed'
 +  expression=  ( \$subShellCmd; ) || ( \$subShellCmd; ) || ( \$subShellCmd; )
 +  see set -x output below:
 +  lineNo=37
 +  source='./assert.source_test.sh' func='test_assert_true'
++ assert__condition_code_set 0
++ return 0
++ eval '(' '\$subShellCmd;' ')' '||' '(' '\$subShellCmd;' ')' '||' '(' '\$subShellCmd;' ')'
+++ false
+++ false
+++ false
BODY
}
}
test_assert_true_subshell_and_ignore_detailed(){
test_assert_true_subshell_and_ignore(){
cat <<BODY
msg='assert_true failed'
 +  expression=  ( \$subShellCmd; ) && ( \$subShellCmd; ) && ( \$subShellCmdfalse; ) && ( \$subShellCmd; )
 +  see set -x output below:
 +  lineNo=43
 +  source='./assert.source_test.sh' func='test_assert_true'
++ assert__condition_code_set 0
++ return 0
++ eval '(' '\$subShellCmd;' ')' '&&' '(' '\$subShellCmd;' ')' '&&' '(' '\$subShellCmdfalse;' ')' '&&' '(' '\$subShellCmd;' ')'
+++ true
+++ true
+++ false
BODY
}
}
test_assert_true_no_pipe_execution_detailed(){
	test_assert_true_no_pipe_execution(){
cat <<BODY
msg='assert_true failed'
 +  expression=  echo "\$hiThere" | test_assert_true_read "nomatch"
 +  see set -x output below:
 +  lineNo=76
 +  source='./assert.source_test.sh' func='test_assert_true_pipe_ignore'
+++ assert__condition_code_set 0
+++ return 0
+++ eval echo '"\$hiThere"' '|' test_assert_true_read '"nomatch"'
++++ echo Hi
++++ test_assert_true_read nomatch
++++ read -r input
++++ '[' Hi == nomatch ']'
BODY
}
	test_assert_true_no_pipe_execution_2(){
cat <<BODY
msg='assert_true failed'
 +  expression=  echo "\$hiThere" | test_assert_true_read "nomatch"
 +  see set -x output below:
 +  lineNo=32
 +  source='./assert.source_test.sh' func='test_assert_true_pipe_ignore'
+++ assert__condition_code_set 0
+++ return 0
+++ eval echo '"\$hiThere"' '|' test_assert_true_read '"nomatch"'
++++ test_assert_true_read nomatch
++++ read -r input
++++ echo Hi
++++ '[' Hi == nomatch ']'
BODY
}
	test_assert_true_no_pipe_execution_3(){
cat <<BODY		
msg='assert_true failed'
 +  expression=  echo "\$hiThere" | test_assert_true_read "nomatch"
 +  see set -x output below:
 +  lineNo=76
 +  source='./assert.source_test.sh' func='test_assert_true_pipe_ignore'
+++ assert__condition_code_set 0
+++ return 0
+++ eval echo '"\$hiThere"' '|' test_assert_true_read '"nomatch"'
++++ test_assert_true_read nomatch
++++ echo Hi
++++ read -r input
++++ '[' Hi == nomatch ']'
BODY
}
}

test_assert_false(){

	if ! assert_false 'false'; then
		test_failure_msg
	fi

	if ! assert_false 'true' 2>&1 | test_compare_output test_assert_false_true; then
		test_failure_msg
	fi
	assert__condition_code_set 100
	if ! assert_false '[ $? -eq 0 ]'; then
		test_failure_msg
	fi
	test_assert_false_argument_forwarding 'arg_1' 'arg_2' 

}
test_assert_false_argument_forwarding(){
	if ! assert_false '! [ "$1" == "arg_1" ] && [ "$2" == "arg_2" ]' "${@}"; then
		test_failure_msg
	fi
}
test_assert_false_true(){
cat <<BODY
msg='assert_false failed'
 +  expression=! true
 +  evalExpres=! true
 +  lineNo=27
 +  source='./assert.source_test.sh' func='test_assert_false'
BODY
}

test_assert_false_detailed(){
	test_assert_false_true_detailed
	test_assert_false
}
test_assert_false_true_detailed(){
	test_assert_false_true(){
cat <<BODY
msg='assert_false failed'
 +  expression=! true
 +  see set -x output below:
 +  lineNo=57
 +  source='./assert.source_test.sh' func='test_assert_false'
++ assert__condition_code_set 0
++ return 0
++ eval '!' true
+++ true
BODY
}
}
test_assert_output_true(){
	if !  echo "hi" | assert_output_true "echo hi"; then
		test_failure_msg
	fi
	if ! assert_output_true echo 'hi' --- echo 'hi'; then
		test_failure_msg
	fi
	if ! assert_true 'echo "hi" | assert_output_true "echo hi"'; then
		test_failure_msg
	fi
	if ! test_assert_output_true_multi_line | assert_output_true test_assert_output_true_multi_line; then
	   test_failure_msg
	fi	   
	if ! test_assert_output_true_multi_line | assert_output_true test_assert_output_true_multi_line_different 2>&1 | test_compare_output test_assert_output_true_multi_line_different_output; then
	   test_failure_msg
	fi	   
	if ! echo "hi" | assert_output_true "echo bye" 2>&1 | test_compare_output test_assert_output_true_hi_ne_bye; then
		test_failure_msg
	fi
	if ! test_assert_output_true_multi_line_args 'arg1' 'arg2' | assert_output_true test_assert_output_true_multi_line_args 'arg1' 'arg2'; then 
	   test_failure_msg
	fi	   
	if !  assert_output_true test_assert_output_true_multi_line --- test_assert_output_true_multi_line ; then 
	   test_failure_msg
	fi	   
	if !  assert_output_true test_assert_output_true_multi_line_args 'arg1' 'arg2' --- test_assert_output_true_multi_line_args 'arg1' 'arg2' ; then 
	   test_failure_msg
	fi	   
	if !  assert_output_true test_assert_output_true_multi_line_args 'arg1' 'arg2' --- test_assert_output_true_multi_line_args 'arg1' 'arg3' 2>&1 | test_compare_output test_assert_output_true_muli_line_args_different; then 
	   test_failure_msg
	fi	   
	assert__RAISED_SOMETIME_DURING_EXECUTION='false'
	assert_return_code_set
	if [ $? -ne 0 ]; then
		test_failure_msg
	fi
	assert_output_true test_assert_output_true_multi_line_args 'arg1' 'arg2' \
	   	--- test_assert_output_true_multi_line_args 'arg1' 'arg3' 2>/dev/null
	if [ $? -eq 0 ]; then
		test_failure_msg
	fi
	if ! test_assert_output_true_multi_line_regex \
		| assert_output_true test_assert_output_true_multi_line_regex_out ; then
		test_failure_msg
	fi
	if ! test_assert_output_true_multi_line_regex_fail \
		| assert_output_true test_assert_output_true_multi_line_regex_out  2>&1 \
		| test_compare_output test_assert_output_true_multi_line_regex_fail_out; then
		test_failure_msg
	fi
	if ! cat /bin/bash | assert_output_true 'cat /bin/bash'; then
		test_failure_msg
	fi
	if ! : | assert_output_true; then
		test_failure_msg
	fi
	if ! assert_output_true --- :; then 
		test_failure_msg
	fi
	if ! assert_output_true ---; then 
		test_failure_msg
	fi
	if ! echo "a" 					\
		| assert_output_true 2>&1	\
		| test_compare_output test_assert_output_true_something_when_expecting_nothing; then
		test_failure_msg
	fi
	if ! test_assert_output_true_generated_more_than_expected			\
		| assert_output_true test_assert_output_true_multi_line	2>&1	\
		| test_compare_output test_assert_output_true_generated_more_than_expected_out; then 
		test_failure_msg
	fi
	if ! test_assert_output_true_generated_less_than_expected			\
		| assert_output_true test_assert_output_true_multi_line 2>&1	\
		| test_compare_output test_assert_output_true_generated_less_than_expected_out; then 
		test_failure_msg
	fi
}
test_assert_output_true_hi_ne_bye(){
cat <<BODY
msg='assert_output_true failed'
 +  generated='hi'
 +  expected_='bye'
 +  lineNo=370
 +  source='./assert.source_test.sh' func='test_assert_output_true'
BODY
}
test_assert_output_true_multi_line(){
cat <<BODY
line_1
line_2
line_3
BODY
}
test_assert_output_true_multi_line_different(){
cat <<BODY
line_1
line_2.2
line_3
BODY
}
test_assert_output_true_multi_line_different_output(){
cat << BODY
msg='assert_output_true failed'
 +  generated='line_2'
 +  expected_='line_2.2'
 +  lineNo=373
 +  source='./assert.source_test.sh' func='test_assert_output_true'
BODY
}
test_assert_output_true_multi_line_args(){
cat <<BODY
line_$1
line_$2
line_3
BODY
}
test_assert_output_true_muli_line_args_different(){
cat <<BODY
msg='assert_output_true failed'
 +  generated='line_arg3'
 +  expected_='line_arg2'
 +  lineNo=389
 +  source='./assert.source_test.sh' func='test_assert_output_true'
BODY
}
test_assert_output_true_multi_line_regex(){
cat <<BODY
line_1
line_2 regex match
BODY
}
test_assert_output_true_multi_line_regex_out(){
cat <<BODY
line_1
${assert_REGEX_COMPARE}line_[0-9][regx match]+$
BODY
}
test_assert_output_true_multi_line_regex_fail(){
cat <<BODY
line_1
line_2 regex q match
BODY
}
test_assert_output_true_multi_line_regex_fail_out(){
cat <<BODY
msg='assert_output_true failed'
 +  generated='line_2 regex q match'
 +  expected_='line_[0-9][regx match]+$'
 +  lineNo=407
 +  source='./assert.source_test.sh' func='test_assert_output_true'
BODY
}
test_assert_output_true_something_when_expecting_nothing(){
cat <<BODY
msg='assert_output_true failed'
 +  generatedCnt='1'
 +  expected_Cnt='0'
 +  lineNo=420
 +  source='./assert.source_test.sh' func='test_assert_output_true'
BODY
}
test_assert_output_true_generated_more_than_expected(){
cat <<BODY
line_1
line_2
line_3
line_4
BODY
}
test_assert_output_true_generated_more_than_expected_out(){
cat <<BODY
msg='assert_output_true failed'
 +  generatedCnt='4'
 +  expected_Cnt='3'
 +  lineNo=428
 +  source='./assert.source_test.sh' func='test_assert_output_true'
BODY
}
test_assert_output_true_generated_less_than_expected(){
cat <<BODY
line_1
line_2
BODY
}
test_assert_output_true_generated_less_than_expected_out(){
cat <<BODY
msg='assert_output_true failed'
 +  generatedCnt='2'
 +  expected_Cnt='3'
 +  lineNo=433
 +  source='./assert.source_test.sh' func='test_assert_output_true'
BODY
}



test_assert_output_false(){
	if ! echo 'bad' | assert_output_false "echo 'good'"; then
	   test_failure_msg
	fi	   
	if ! test_assert_output_false_multi_line_arg 'dump' 'truck' \
		| assert_output_false test_assert_output_false_multi_line_arg 'truck' 'dump'; then
	   test_failure_msg
	fi	   
	if ! test_assert_output_false_multi_line_arg 'dump' 'truck' \
		| assert_output_false test_assert_output_false_multi_line_arg 'dump' 'truck' 2>&1  \
		| test_compare_output test_assert_output_false_multi_line_arg_same_out ; then
	   test_failure_msg
	fi	   
	if ! test_assert_output_false_multi_line_arg 'dump' 'truck' \
		| assert_output_false test_assert_output_false_multi_line_arg_regex 'dump' 'truck' 2>&1  \
		| test_compare_output test_assert_output_false_multi_line_arg_regex_out ; then
	   test_failure_msg
	fi
	if ! :								\
		| assert_output_false	2>&1	\
		| test_compare_output test_assert_output_false_must_generate_something; then
		test_failure_msg
	fi
}
test_assert_output_false_multi_line_arg(){
cat <<BODY
line_1 $1
line_2 $2
BODY
}
test_assert_output_false_multi_line_arg_same_out(){
cat <<BODY
line_1 $1
line_2 $2
BODY
}
test_assert_output_false_multi_line_arg_same_out(){
cat <<BODY
msg='assert_output_false failed'
 +  generated='line_1 dump'
 +  expected_='line_1 dump'
 +  lineNo=497
 +  source='./assert.source_test.sh' func='test_assert_output_false'
BODY
}
test_assert_output_false_multi_line_arg_regex(){
cat <<BODY
${assert_REGEX_COMPARE}.*
${assert_REGEX_COMPARE}.*
BODY
}
test_assert_output_false_multi_line_arg_regex_out(){
cat <<BODY
msg='assert_output_false failed'
 +  generated='line_1 dump'
 +  expected_='.*'
 +  lineNo=502
 +  source='./assert.source_test.sh' func='test_assert_output_false'
BODY
}
test_assert_output_false_must_generate_something(){
cat <<BODY
msg='assert_output_false failed'
 +  generated='nothing'
 +  expected_='something'
 +  lineNo=515
 +  source='./assert.source_test.sh' func='test_assert_output_false'
BODY
}



test_failure_msg(){
	echo "msg='${FUNCNAME[1]} failed'"  >&2
	echo " +  lineNo=${BASH_LINENO[0]}" >&2
	test_ASSERT_RAISED='true'
}

test_compare_output(){
	diff -I '.*lineNo=.*'  -  <($1) >&2
}
test_compare_output_tee(){
	local -r diffFile="$(mktemp)"
	tee "$diffFile"
	diff -I '.*lineNo=.*'  "$diffFile"  <($1) >&2
	local -i rtncd="$?"
	rm "$diffFile"
	return $rtncd
}



test_assert_child_process(){
	# set parent (this process) assert_ package state to no failures
	# so child process copy of assert_ package also initially reports no
	# failures
	assert__RAISED_SOMETIME_DURING_EXECUTION='false'
	# run child process and assert 
	if ! assert_false test_assert_child_process_run; then
		test_failure_msg
	fi
	# expect no assertions raised yet because of false check above
	if ! assert_false $assert__RAISED_SOMETIME_DURING_EXECUTION; then 
		test_failure_msg
	fi
	assert_return_code_child_failure_relay test_assert_child_process_run
	# assertions raised in child should be communicated to this (parent) process
	if ! assert_true	$assert__RAISED_SOMETIME_DURING_EXECUTION; then
		test_failure_msg
	fi
}

test_assert_child_process_run()(
	# initiate function as child process.  Notice function body defined within "()" instead of "{}".
	# Bash (Linux) starts child process with nearly exact state of parent.  Linux uses Copy On Write
	# (https://en.wikipedia.org/wiki/Copy-on-write) mechanism to shield parent process from memory updates
	# performed by the child.  Therefore, assert_ invocations in this child process fail to affect the state
	# of the assert_ package active in the parent.

	# assert no failures yet
	if ! assert_false $assert__RAISED_SOMETIME_DURING_EXECUTION; then 
		test_failure_msg
	fi
	# raise an assertion.
	if assert_true false 2>/dev/null; then
		test_failure_msg
	fi
	# communicate failure to parent process by setting the return code according to the assert package instance
	# running in this child.
	assert_return_code_set	
)



main(){
	test_assert_true
	test_assert_false
	test_assert_output_true
	test_assert_output_false
	test_assert_child_process 
	# Change assert evaluator to generate detailed evaluation messages for assert failures
	assert_bool_detailed
	test_assert_true_detailed
	test_assert_false_detailed
	if $test_ASSERT_RAISED; then return 1; fi
}

main
