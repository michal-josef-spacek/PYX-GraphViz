# Pragmas.
use strict;
use warnings;

# Modules.
use PYX::GraphViz;
use Test::More 'tests' => 1;

# Test.
is($PYX::GraphViz::VERSION, 0.01, 'Version.');
