Describe "Sample specfile"
  Include ./shellbench

  Describe "preprocess()"
    Describe "@bench directive"
      Data
        #|foo
        #|#bench
        #|bar
        #|baz
      End

      result() { %text
        #|foo
        #|#bench
        #|@bench
        #|bar
        #|baz
      }

      It "outputs preproccesed texts"
        When call preprocess
        The output should eq "$(result)"
      End
    End

    Describe "@bench directive with parameters"
      Data
        #|foo
        #|#bench "name" skip=sh
        #|bar
        #|baz
      End

      result() { %text
        #|foo
        #|#bench
        #|@bench "name" skip=sh
        #|bar
        #|baz
      }

      It "outputs preproccesed texts"
        When call preprocess
        The output should eq "$(result)"
      End
    End
  End

  Describe "generate_initialize_helper()"
    It "generates initialize helper"
      When call generate_initialize_helper
      The output should include "trap"
    End
  End

  Describe "generate_begin_helper()"
    It "generates @begin helper"
      When call generate_begin_helper
      The output should include "while"
    End
  End

  Describe "generate_end_helper()"
    It "generates @end helper"
      When call generate_end_helper
      The output should include "done"
    End
  End

  Describe "read_initializer()"
    Data
      #|#!/bin/sh
      #|setup() { :; }
      #|#bench
      #|@bench
      #|foo
    End

    generate_initialize_helper() { echo "initialize helper"; }

    It "reads initializer"
      When call read_initializer
      The line 1 should eq "initialize helper"
      The line 2 should eq "#!/bin/sh"
      The line 3 should eq "setup() { :; }"
      The lines of output should eq 3
    End
  End

  Describe "read_bench()"
    Data
      #|@bench "name" skip=sh
    End

    It "reads @bench directive"
      When call read_bench
      The output should eq '@bench "name" skip=sh'
    End

    Data
    End

    It "returns failure if there is no data"
      When call read_bench
      The output should be blank
      The status should be failure
    End
  End

  Describe "read_code()"
    Data
      #|@begin
      #|foo
      #|@end
      #|#bench
    End

    result() { %text
      #|@begin helper
      #|foo
      #|@end helper
    }

    generate_begin_helper() { echo "@begin helper"; }
    generate_end_helper() { echo "@end helper"; }

    It "reads file until the #bench directive"
      When call read_code
      The output should eq "$(result)"
    End

    Context "when @begin and @end are missing"
      Data
        #|foo
        #|#bench
      End

      It "raise error"
        When run read_code
        The stderr should include "@begin is not defined"
        The status should be failure
      End
    End

    Context "when @begin is missing"
      Data
        #|foo
        #|@end
        #|#bench
      End

      It "raise error"
        When run read_code
        The stderr should include "@begin is not defined"
        The status should be failure
      End
    End

    Context "when @begin is duplicated"
      Data
        #|@begin
        #|@begin
        #|foo
        #|@end
        #|#bench
      End

      It "raise error"
        When run read_code
        The stderr should include "@begin is duplicated"
        The status should be failure
      End
    End

    Context "when @end is missing"
      Data
        #|@begin
        #|foo
        #|#bench
      End

      It "raise error"
        When run read_code
        The stderr should include "@end is not defined"
        The status should be failure
      End
    End

    Context "when @end is duplicated"
      Data
        #|@begin
        #|foo
        #|@end
        #|@end
        #|#bench
      End

      It "raise error"
        When run read_code
        The stderr should include "@end is duplicated"
        The status should be failure
      End
    End
  End

  Describe "syntax_check()"
    Parameters
      sh ":" success blank
      sh "{" failure present
    End

    It "checks syntax"
      When call syntax_check "$1" "$2"
      The status should be "$3"
      The error should be "$4"
    End
  End

  Describe "bench()"
    Before WARMUP_TIME=0 BENCHMARK_TIME=0.1

    It "runs benchmark code"
      When call bench "sh" "echo ok"
      The output should eq ok
    End

    Context "when warm up fails"
      wait() { return 1; }
      It "stops benchmark"
        When call bench "sh" "echo ok"
        The output should be blank
        The status should be failure
      End
    End
  End

  Describe "parse_bench()"
    It "parses @bench arguments"
      When call parse_bench "name" "skip=sh" "only=bash" "dummy"
      The variable name should eq "name"
      The variable skip should eq "sh"
      The variable only should eq "bash"
    End
  End

  Describe "exists_shell()"
    Parameters
      sh success
      no-such-a-shell failure
    End

    It "checks if exists shell"
      When call exists_shell "$1"
      The status should be "$2"
    End
  End

  Describe "is_skip()"
    Parameters
      sh failure
      bash success
      zsh success
      "busybox ash" success
      "/bin/bash" success
    End

    Context "when specified only"
      Before only=bash,zsh,ash skip=''

      It "checks if it is a shell to skip"
        When call is_skip "$1"
        The status should not be "$2"
      End
    End

    Context "when specified skip"
      Before skip=bash,zsh,ash only=''

      It "checks if it is a shell to skip"
        When call is_skip "$1"
        The status should be "$2"
      End
    End
  End

  Describe "comma()"
    Parameters
      1 1
      10 10
      100 100
      1000 1,000
      111011001 111,011,001
    End

    _comma() {
      value=$1
      comma value
      echo "$value"
    }

    It "inserts comma"
      When call _comma "$1"
      The output should eq "$2"
    End
  End


  Describe "process()"
    Data
      #|#bench
      #|@bench dummy
      #|@begin
      #|:
      #|@end
    End

    Before SHELLS=sh,bash
    Before WARMUP_TIME=0 BENCHMARK_TIME=2
    bench() {
      case $1 in
        sh) echo 1000 >&3 ;;
        bash) echo 2000 >&3 ;;
      esac
    }

    It "outputs benchmark results"
      When call process "file"
      The word 1 should eq "file:"
      The word 2 should eq "dummy"
      The word 3 should eq "500"
      The word 4 should eq "1,000"
    End

    Context "when shell not found"
      exists_shell() { return 1; }
      It "outputs skipped results"
        When call process "file"
        The word 1 should eq "file:"
        The word 2 should eq "dummy"
        The word 3 should eq "none"
        The word 4 should eq "none"
      End
    End

    Context "when skipped benchmark"
      is_skip() { return 0; }
      It "outputs skipped results"
        When call process "file"
        The word 1 should eq "file:"
        The word 2 should eq "dummy"
        The word 3 should eq "skip"
        The word 4 should eq "skip"
      End
    End

    Context "when syntax error"
      syntax_check() { return 1; }
      It "outputs error"
        When call process "file"
        The word 1 should eq "file:"
        The word 2 should eq "dummy"
        The word 3 should eq "error"
        The word 4 should eq "error"
      End
    End
  End

  Describe "line()"
    It "outputs line"
      When call line "10"
      The output should eq "----------"
    End
  End

  Describe "count_shells()"
    It "outputs line"
      When call count_shells "sh,bash,zsh"
      The variable NUMBER_OF_SHELLS should eq 3
    End
  End

  Describe "display_header()"
    Before NAME_WIDTH=20 SHELL_WIDTH=8 NUMBER_OF_SHELLS=3

    It "outputs line"
      When call display_header "sh,bash,zsh"
      The line 1 should eq "-----------------------------------------------"
      The line 2 should eq "name                       sh     bash      zsh"
      The line 3 should eq "-----------------------------------------------"
    End
  End

  Describe "display_footer()"
    Before NAME_WIDTH=20 SHELL_WIDTH=8 NUMBER_OF_SHELLS=3

    It "outputs line"
      When call display_footer
      The line 1 should eq "-----------------------------------------------"
      The line 2 should eq "* count: number of executions per second"
    End
  End
End
