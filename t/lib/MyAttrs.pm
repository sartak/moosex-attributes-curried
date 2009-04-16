package MyAttrs;
use MooseX::Attributes::Curried (
    has_str => {
        isa => 'Str',
    },
    has_int => {
        isa     => 'Int',
        default => 0,
    },
);

1;

