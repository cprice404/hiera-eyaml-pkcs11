#!/usr/bin/expect

set timeout 1
set cmd [lindex $argv 0];

#set cmd {echo "HELLO"}

spawn ssh test@localhost $cmd
expect_after oef { exit 0 }

#set prompt_regex "test@localhost's password:"
set prompt_regex [lindex $argv 1]
#expect "(Password:)|(test@localhost's password:)" { send "test\r" }
#expect -re {(Password:)|(test@localhost's password:)} { send "test\r" }
expect -re $prompt_regex { send "test\r" }
expect "(.*)\r"
