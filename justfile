exe := "example"

default: build

alias s := setup

setup:
    @if ! test -e build/build.ninja; then cmake -B build; fi

alias b := build

build *ARGS:
    @just setup
    ninja -C build {{ ARGS }}

alias r := run

run *ARGS: (build exe)
    ./build/{{ exe }} {{ ARGS }}

alias t := test

test: (build "tests")
    ./build/tests
