package MooseX::Attributes::Curried;
use strict;
use warnings;
use Sub::Exporter build_exporter => { -as => '_build_exporter' };

# taken from Moose.pm, but level has been subtracted by one due to less
# indirection
sub _caller_info {
    my $level = @_ ? $_[0] : 1;
    my %info;
    @info{qw(package file line)} = caller($level);
    return \%info;
}

sub build_exporter {
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

                my $meta = Class::MOP::class_of(caller);
                $meta->add_attribute($_, %options) for @$attrs;
            },
        };
    }

    return _build_exporter({
        exports => [%keywords],
        groups  => {
            default => [keys %keywords],
        },
    });
}

sub import {
    shift;
    my $exporter = build_exporter(@_);

    my $caller = caller;

    no strict 'refs';
    *{ $caller . '::import' } = $exporter;
}

1;

__END__

=head1 NAME

MooseX::Attributes::Curried - curry your "has"es

=head1 SYNOPSIS

    package MyAttrs;
    use MooseX::Attributes::Curried (
        has_datetime => {
            isa     => 'DateTime',
            default => sub { DateTime->now },
        },
        has_rw => {
            is => 'rw',
        },
    );

    package My::Class;
    use Moose;
    use MyAttrs;

    has_datetime 'birthday' => (
        is => 'ro',
    );

    has_rw 'age' => (
        isa => 'Int',
    );

=head1 DESCRIPTION

This module lets you define curried versions of L<Moose/has>. If many of your
attributes share the same options, especially across multiple classes, then you
can refactor those options away into a curried C<has>.

Typical usage of this extension is to create a standalone "C<has> library"
module. If you only need a curried C<has> for one class, then you might as
well just define a C<sub has_datetime { has(...) }> in that class.

When you use your "C<has> library", you can customize each curried C<has>
further by specifying additional options on your import line, like so:

    use MyAttrs (
        has_datetime => {
            is => 'ro',
        },
    );

=head1 SEE ALSO

L<MooseX::Attribute::Prototype>, which has very similar goals; this
extension was originally proposed as an implementation of prototype attributes.

=cut

