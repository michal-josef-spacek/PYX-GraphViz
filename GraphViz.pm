package PYX::GraphViz;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use GraphViz;
use PYX::Parser;

# Version.
our $VERSION = 0.01;

# Global variables.
use vars qw($num $object $stack);

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Object.
	my $self = bless {}, $class;

	# Colors.
	$self->{'colors'} = {
		'a' => 'blue',
		'blockquote' => 'orange',
		'br' => 'orange',
		'div' => 'green',
		'form' => 'yellow',
		'html' => 'black',
		'img' => 'violet',
		'input' => 'yellow',
		'option' => 'yellow',
		'p' => 'orange',
		'select' => 'yellow',
		'table' => 'red',
		'td' => 'red',
		'textarea' => 'yellow',
		'tr' => 'red',
		'*' => 'grey',
	};

	# Layout.
	$self->{'layout'} = 'neato';

	# Height and width.
	$self->{'height'} = 10;
	$self->{'width'} = 10;

	# Node height.
	$self->{'node_height'} = 0.3;

	# Output handler.
	$self->{'output_handler'} = \*STDOUT;

	# Process params.
	set_params($self, @params);

	# PYX::Parser object.
	$self->{'_pyx_parser'} = PYX::Parser->new(
		'output_handler' => $self->{'output_handler'},

		# Handlers.
		'end_tag' => \&_end_tag,
		'final' => \&_final,
		'start_tag' => \&_start_tag,
	);

	# Check to '*' color.
	if (! exists $self->{'colors'}->{'*'}) {
		err "Bad color define for '*' tags.";
	}

	# GraphViz object.
	$self->{'_graphviz'} = GraphViz->new(
		'layout' => $self->{'layout'},
		'overlap' => 'scale',
		'height' => $self->{'height'},
		'width' => $self->{'width'},
	);

	# Object.
	$object = $self;

	# Number iterator.
	$num = 0;

	# Stack.
	$stack = [];

	# Object.
	return $self;
}

# Parse pyx text or array of pyx text.
sub parse {
	my ($self, $pyx, $out) = @_;
	$self->{'_pyx_parser'}->parse($pyx, $out);
	return;
}

# Parse file with pyx text.
sub parse_file {
	my ($self, $file, $out) = @_;
	$self->{'_pyx_parser'}->parse_file($file, $out);
	return;
}

# Parse from handler.
sub parse_handler {
	my ($self, $input_file_handler, $out) = @_;
	$self->{'_pyx_parser'}->parse_handler($input_file_handler, $out);
	return;
}

# Process tag.
sub _start_tag {
	my ($pyx_parser_obj, $tag) = @_;
	$num++;
	my $color;
	if (exists $object->{'colors'}->{$tag}) {
		$color = $object->{'colors'}->{$tag};
	} else {
		$color = $object->{'colors'}->{'*'};
	}
	$object->{'_graphviz'}->add_node($num,
		'color' => $color,
		'height' => $object->{'node_height'},
		'shape' => 'point'
	);
	if (@{$stack}) {
		$object->{'_graphviz'}->add_edge(
			$num => $stack->[-1]->[1],
			'arrowhead' => 'none',
			'weight' => 2,
		);
	}
	push @{$stack}, [$tag, $num];
	return;
}

# Process tag.
sub _end_tag {
	my ($pyx_parser_obj, $tag) = @_;
	if ($stack->[-1]->[0] eq $tag) {
		pop @{$stack};
	}
	return;
}

# Final.
sub _final {
	my $pyx_parser_obj = shift;
	my $out = $pyx_parser_obj->{'output_handler'};
	$object->{'_graphviz'}->as_png($out);
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

PYX::GraphViz - GraphViz output for PYX handling.

=head1 SYNOPSIS

 use PYX::GraphViz;
 my $obj = PYX::GraphViz->new(%parameters);
 $obj->parse($pyx, $out);
 $obj->parse_file($input_file, $out);
 $obj->parse_handle($input_file_handler, $out);

=head1 METHODS

=over 8

=item C<new(%parameters)>

Constructor

=over 8

=item * C<colors>

 Colors.
 Default value is {
         'a' => 'blue',
         'blockquote' => 'orange',
         'br' => 'orange',
         'div' => 'green',
         'form' => 'yellow',
         'html' => 'black',
         'img' => 'violet',
         'input' => 'yellow',
         'option' => 'yellow',
         'p' => 'orange',
         'select' => 'yellow',
         'table' => 'red',
         'td' => 'red',
         'textarea' => 'yellow',
         'tr' => 'red',
         '*' => 'grey',
 }

=item * C<height>

 GraphViz object height.
 Default value is 10.

=item * C<layout>

 GraphViz layout.
 Default value is 'neato'.

=item * C<node_height>

 GraphViz object node height.
 Default value is 0.3.

=item * C<output_handler>

 Output handler.
 Default value is \*STDOUT.

=item * C<width>

 GraphViz object width.
 Default value is 10.

=back

=item C<parse($pyx[, $out])>

 Parse PYX text or array of PYX text.
 If $out not present, use 'output_handler'.
 Returns undef.

=item C<parse_file($input_file[, $out])>

 Parse file with PYX data.
 If $out not present, use 'output_handler'.
 Returns undef.

=item C<parse_handler($input_file_handler[, $out])>

 Parse PYX handler.
 If $out not present, use 'output_handler'.
 Returns undef.

=back

=head1 ERRORS

 new():
        Bad color define for '*' tags.
        From Class::Utils::set_params():
                Unknown parameter '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use PYX::GraphViz;

 # Example PYX data.
 my $pyx = <<'END';
 (html
 (head
 (title
 -Title
 )title
 )head
 (body
 (div
 -data
 )div
 )body
 END

 # Object.
 my $obj = PYX::GraphViz->new;

 # Parse.
 $obj->parse($pyx);

 # Output
 # PNG data

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<GraphViz>,
L<PYX::Parser>.

=head1 SEE ALSO

L<App::SGML2PYX>,
L<PYX>
L<PYX::Checker>,
L<PYX::Filter>,
L<PYX::Optimalization>,
L<PYX::Parser>,
L<PYX::Sort>,
L<PYX::Stack>,
L<PYX::Utils>,
L<PYX::Write::Raw>,
L<PYX::Write::Tags>,
L<PYX::Write::Tags::Code>,
L<PYX::XMLNorm>.

=head1 REPOSITORY

L<https://github.com/tupinek/PYX-GraphViz>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

 © Michal Špaček 2011-2014
 BSD 2-Clause License

=head1 VERSION

0.01

=cut
