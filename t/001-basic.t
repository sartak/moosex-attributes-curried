#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;

do {
    package My::Attributes;
    use MooseX::Attribute::Curried (
        has_str => [
            isa => 'Str',
        ],
        has_int => {
            isa     => 'Int',
            default => 0,
        },
    );
};

do {
    package Foo;
    use Moose;
    BEGIN { My::Attributes->import }

    has_str name => (
        is => 'rw',
    );

    has_int age => (
        is => 'rw',
    );
};

is(Foo->meta->get_attribute('name')->type_constraint, 'Str');
is(Foo->meta->get_attribute('age')->type_constraint, 'Int');
is(Foo->meta->get_attribute('age')->default, 0);

