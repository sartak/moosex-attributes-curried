package MyAttrs;
use MooseX::Attribute::Curried (
    has_str => {
        isa => 'Str',
    },
    has_int => {
        isa     => 'Int',
        default => 0,
    },
);

1;

