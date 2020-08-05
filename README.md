# ShellBench

A benchmark utility for POSIX shell comparison

## Usage

```console
Usage: shellbench [options] files...

  -s, --shell SHELL[,SHELL...]  The shell(s) to run the benchmark. [default: sh]
  -t, --time SECONDS            Benchmark execution time. (SECONDS > 0) [default: 3]
  -w, --warmup SECONDS          Benchmark preparation time. (SECONDS > 0) [default: 1]
  -c, --correct                 Enable correction mode to eliminate loop overhead.
  -h, --help                    You're looking at it.
```

## Sample

```console
$ ./shellbench -s sh,bash,ksh,mksh,posh,zsh sample/count.sh sample/output.sh
------------------------------------------------------------------------------------------------
name                                   sh       bash        ksh       mksh       posh        zsh
------------------------------------------------------------------------------------------------
count.sh: posix                 1,034,369    248,929    282,537    364,627    411,116    577,090
count.sh: typeset -i                 skip    237,421    288,133    341,660       skip    593,124
count.sh: increment                  skip    272,415    443,765    350,265       skip    835,077
output.sh: echo                   279,335    121,104    375,175    179,903    201,718     59,138
output.sh: printf                 277,989    118,461    209,123        180        179     63,644
output.sh: print                     skip       skip    281,775    182,388       skip     63,006
------------------------------------------------------------------------------------------------
* count: number of executions per second
```

file: **sample/count.sh**

```sh
#!/bin/sh

setup() { i=1; }
cleanup() { :; }

#bench "posix"
@begin
i=$((i+1))
@end

#bench "typeset -i" only=bash,ksh,mksh,zsh
typeset -i i
@begin
i=$((i+1))
@end

#bench "increment" only=bash,ksh,mksh,zsh
typeset -i i
@begin
((i++))
@end
```

file: **sample/output.sh**

```sh
#!/bin/sh

#bench "echo"
@begin
echo "test"
@end

#bench "printf"
@begin
printf "test\n"
@end

#bench "print" only=ksh,mksh,lksh,pdksh,zsh
@begin
print "test"
@end
```

## Directives

### `#bench`

Define new benchmark

```sh
#bench NAME [only=SHELL[,SHELL...]] [skip=SHELL[,SHELL...]]
```

- NAME: Benchmark name
- only: Run only on specified shell(s).
- skip: Skip specified shell(s).

### @begin & @end

Repeatedly execute between `@begin` to `@end`, and count the number of executions.

```sh
@begin
echo "test"
@end
```

## Hooks

### `setup`

Invoked before each benchmark.

### `cleanup`

Invoked after each benchmark.

## Environment variables

| name                      | description                       | default |
| ------------------------- | --------------------------------- | ------- |
| SHELLBENCH_SHELLS         | The shell(s) to run the benchmark | sh      |
| SHELLBENCH_BENCHMARK_TIME | Benchmark execution time          | 3       |
| SHELLBENCH_WARMUP_TIME    | Benchmark preparation time        | 1       |
| SHELLBENCH_NAME_WIDTH     | Display width of benchmark name   | 30      |
| SHELLBENCH_SHELL_WIDTH    | Display width of shell name       | 10      |
| SHELLBENCH_NULLLOOP_COUNT | null loop measurement             |         |

## How it works

ShellBench translates `@begin` and `@end` to loop as follows:


```sh
# From
@begin
echo "test"
@end

# Translate to
while __count=$(($__count+1)); do
echo "test"
done
```

That is, during the benchmark time, not only `echo` but `while`, `__ count=$(($__count+1))`, count the number of times it is executed.

This loop will be killed by another process after benchmark time. Therefore, after `@end` is not executed.

### Correction mode

Calculate the benchmark measurement results more strictly.
This mode is suitable when the cost impact of the loop cannot be ignored.

Difference between default and modification mode

- Default mode: Measure `while`, `__count=$(($__count+1))` and target code.
- Correction mode: Measure only target code

Correction mode first measures the null loop and then eliminates
the null loop measurement from the benchmark measurement.

```sh
# Null loop
while __count=$(($__count+1)); do
__CORRECTION_MODE=
done
```

And translates `@begin` and `@end` in correction mode as follows:

```sh
# From
@begin
echo "test"
@end

# Translate to
while __count=$(($__count+1)); do
__CORRECTION_MODE=
echo "test"
done
```

Compute a corrected value from the null loop execution count and the benchmark count.

Corrected count: `B / ( 1.0 - ( B * ( 1.0 / A ) ) )`

- A: null loop executed count
- B: benchmark count
