# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Utils qw(clean);
use PYX::GraphViz;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
eval {
	PYX::GraphViz->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n", "Unknown parameter ''.");
clean();

# Test.
eval {
	PYX::GraphViz->new(
		'something' => 'value',
	);
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n",
	"Unknown parameter 'something'.");
clean();

# Test.
my $obj = PYX::GraphViz->new;
isa_ok($obj, 'PYX::GraphViz');
