package MyCodeAttrs;
use MooseX::Attributes::Curried (
    has_guess => sub {
        if (/^\w$/) {
            return {
                isa => 'Int',
            };
        }
        else {
            return {
                isa => 'Str',
            };
        }
    },
);

1;


