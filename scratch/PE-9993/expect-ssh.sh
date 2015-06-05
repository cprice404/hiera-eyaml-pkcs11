#!/usr/bin/expect

set timeout 1
set cmd [lindex $argv 0];
set prompt_regex [lindex $argv 1]
set password [lindex $argv 2]

spawn ssh test@localhost $cmd
expect_after oef { exit 0 }

expect -re $prompt_regex { send "$password\r" }
expect "(.*)\r"
