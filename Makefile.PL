# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'GraphViz output for PYX handling.';
author 'Michal Spacek <skim@cpan.org>';
install_script 'bin/pyx2graphviz';
license 'bsd';
name 'PYX-GraphViz';
readme_from 'lib/PYX/GraphViz.pm';
requires 'Class::Utils' => 0.05;
requires 'Error::Pure' => 0.15;
requires 'GraphViz' => 0;
requires 'PYX::Parser' => 0.01;
requires 'perl' => '5.6.0';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=PYX-GraphViz';
resources 'homepage' => 'https://github.com/tupinek/PYX-GraphViz';
resources 'repository' => 'git://github.com/tupinek/PYX-GraphViz';
test_requires 'English' => 0;
test_requires 'File::Object' => 0.07;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.03';

# Run.
WriteAll();
