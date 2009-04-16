package MooseX::Attribute::Curried;
use strict;
use warnings;
use Sub::Exporter 'setup_exporter';

# taken from Moose.pm, but level has been subtracted by one due to less
# indirection
sub _caller_info {
    my $level = @_ ? $_[0] : 1;
    my %info;
    @info{qw(package file line)} = caller($level);
    return \%info;
}

sub import {
    shift;

    my %keywords;

    while (my ($keyword, $defaults) = splice @_, 0, 2) {
        ref($defaults) eq 'HASH'
            or Carp::croak("The defaults for '$keyword' must be a hashref.");

        $keywords{$keyword} = sub {
            my ($class, $arg, $opt) = @_;
            my @customized_defaults = (%$defaults, %$opt);

            sub {
                my $name = shift;
                my %options = (
                    definition_context => _caller_info(),
                    @customized_defaults,
                    @_,
                );

                my $attrs = (ref($name) eq 'ARRAY') ? $name : [$name];

                my $meta = Class::MOP::Class->initialize(caller);
                $meta->add_attribute($_, %options) for @$attrs;
            },
        };
    }

    setup_exporter({
        into    => scalar(caller),
        exports => [%keywords],
        groups  => {
            default => [keys %keywords],
        },
    });
}

1;

__END__

=head1 NAME

MooseX::Attribute::Curried - curry your "has"es

=head1 SYNOPSIS

    package MyAttrs;
    use MooseX::Attribute::Curried (
        has_datetime => {
            isa     => 'DateTime',
            default => sub { DateTime->now },
        },
    );

    package My::Class;
    use Moose;
    use MyAttrs;

    has_datetime 'birthday' => (
        is => 'ro',
    );

=head1 DESCRIPTION

This module lets you define curried versions of L<Moose/has>.

=cut

