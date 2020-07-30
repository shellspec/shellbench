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

## Environment variables

| name                      | description                       | default |
| ------------------------- | --------------------------------- | ------- |
| SHELLBENCH_SHELLS         | The shell(s) to run the benchmark | sh      |
| SHELLBENCH_BENCHMARK_TIME | Benchmark execution time          | 3       |
| SHELLBENCH_WARMUP_TIME    | Benchmark preparation time        | 1       |
| SHELLBENCH_NAME_WIDTH     | Display width of benchmark name   | 30      |
| SHELLBENCH_SHELL_WIDTH    | Display width of shell name       | 10      |

## Sample

```console
$ ./shellbench -s sh,dash,bash,ksh,mksh,zsh sample/output.sh
------------------------------------------------------------------------------------------------
name                                   sh       dash       bash        ksh       mksh        zsh
------------------------------------------------------------------------------------------------
output.sh: echo                    49,945    141,703     59,579    435,913    123,431    193,052
output.sh: printf                  61,428    156,557     82,850    299,136       skip    184,897
output.sh: print                     skip       skip       skip    399,653    144,859    190,010
------------------------------------------------------------------------------------------------
* count: number of executions per second
```

file: **sample/output.sh**

```sh
#!/bin/sh

@bench "echo"
echo "test"

@bench "printf" skip=mksh
printf "test\n"

@bench "print" only=ksh,mksh,lksh,pdksh,zsh
print "test"
```
