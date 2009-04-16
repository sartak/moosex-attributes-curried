#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 4;
use lib 't/lib';

do {
    package Foo;
    use Moose;
    use MyAttrs (
        has_str => {
            -as => 'default_str',
            default => '',
        },
        has_str => {
            -as      => 'needs_str',
            required => 1,
        },
    );

    needs_str 'name';
    default_str 'confound';
};

ok(Foo->meta->get_attribute('name')->is_required, 'needs_str: required');
is(Foo->meta->get_attribute('confound')->default, '', 'default_str: default');

ok(!Foo->meta->get_attribute('confound')->is_required, 'default_str: not required');
ok(!Foo->meta->get_attribute('name')->has_default, 'needs_str: no default');

