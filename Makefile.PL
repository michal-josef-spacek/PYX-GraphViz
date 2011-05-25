# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Špaček <skim@cpan.org>',
	'EXE_FILES' => [
		'bin/pyx2graphviz',
	],
	'NAME' => 'PYX::GraphViz',
	'PREREQ_PM' => {
		'Class::Utils' => 0.01,
		'Error::Pure' => 0.01,
		'GraphViz' => 0,
		'PYX::Parser' => 0.01,
	},
	'VERSION' => '0.01',
	'test' => {
		'TESTS' => 't/PYX::GraphViz/*.t',
	},
);
