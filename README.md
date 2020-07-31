# ShellBench

A benchmark utility for POSIX shell comparison

## Usage

```console
Usage: shellbench [options] files...

  -s, --shell SHELL[,SHELL...]  The shell(s) to run the benchmark. [default: sh]
  -t, --time SECONDS            Benchmark execution time. (SECONDS > 0) [default: 3]
  -w, --warmup SECONDS          Benchmark preparation time. (SECONDS > 0) [default: 1]
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
i=1
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

Define new bencmark

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
