# assert.source.sh
Provide yet another assertion library for testing.

### Public API

#### assert_true \<bashTestEncapsulted\>
Generate message indicating failure of stated condition when **\<bashTestEncapsulated\>** evaluates to *false*.  Otherwise, be silent.

  - **\<bashTestEncapsulated\>** any bash [conditional expression](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html) cocooned to satisfy its parser so it treats the expression as a single argument.  This delays the expression's evaluation so it can occur within the implementation of **assert_true**.
```
pasContext="unexpected context"
assert_true '[ "$pasContext" == "expected context" ]' 





#### assert_false \<bashTest\>
Negated form of *assert_true*

#### assert_output_true \<commandExpected\> [\<argList\>] [ <\inputDelim\> \<command_Generate\> [<arglist] ]

#### assert_output_false \<command\> [\<argList\>]
Negated form of *assert_output_true*.

#### assert_halt

#### assert_continue

#### assert_return_code_set

### References

[lehmannro/assert.sh](https://github.com/lehmannro/assert.sh)
