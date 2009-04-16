#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;
use lib 't/lib';

do {
    package Foo;
    use Moose;
    use MyAttrs;

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

