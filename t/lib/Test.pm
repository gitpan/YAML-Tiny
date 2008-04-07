package t::lib::Test;

use strict;
use Exporter   ();
use Test::More ();

use vars qw{@ISA @EXPORT};
BEGIN {
	@ISA    = qw{ Exporter };
	@EXPORT = qw{ tests  yaml_ok  slurp  load_ok };
}

# Do we have the authorative YAML to test against
eval {
	require YAML;

	# This doesn't currently work, but is documented to.
	# So if it ever turns up, use it.
	$YAML::UseVersion = 1;
};
my $HAVE_YAMLPM = !! $YAML::VERSION;
sub have_yamlpm {
	$HAVE_YAMLPM;
}

# Do we have YAML::Syck to test against?
eval {
	require YAML::Syck;
};
my $HAVE_SYCK = !! $YAML::Syck::VERSION;

# Do we have YAML::XS to test against?
eval {
	require YAML::XS;
};
my $HAVE_XS = !! $YAML::XS::VERSION;

# 22 tests per call to yaml_ok
# 4  tests per call to load_ok
sub tests {
	return ( tests => count(@_) );
}

sub count {
	my $yaml_ok = shift || 0;
	my $load_ok = shift || 0;
	my $single  = shift || 0;
	my $count   = $yaml_ok * 34 + $load_ok * 4 + $single;
	return $count;
}

sub yaml_ok {
	my $string  = shift;
	my $object  = shift;
	my $name    = shift || 'unnamed';
	my %options = ( @_ );
	bless $object, 'YAML::Tiny';

	# If YAML itself is available, test with it
	SKIP: {
		unless ( $HAVE_YAMLPM ) {
			Test::More::skip( "Skipping YAML.pm, not available for testing", 8 );
		}
		if ( $options{noyamlpm} ) {
			Test::More::skip( "Skipping YAML.pm for known-broken feature", 8 );
		}

		# Test writing with YAML.pm
		my $yamlpm_out = eval { YAML::Dump( @$object ) };
		Test::More::is( $@, '', "$name: YAML.pm saves without error" );
		SKIP: {
			Test::More::skip( "Shortcutting after failure", 4 ) if $@;
			Test::More::ok(
				!!(defined $yamlpm_out and ! ref $yamlpm_out),
				"$name: YAML.pm serializes correctly",
			);
			my @yamlpm_round = eval { YAML::Load( $yamlpm_out ) };
			Test::More::is( $@, '', "$name: YAML.pm round-trips without error" );
			Test::More::skip( "Shortcutting after failure", 2 ) if $@;
			my $round = bless [ @yamlpm_round ], 'YAML::Tiny';
			Test::More::isa_ok( $round, 'YAML::Tiny' );
			Test::More::is_deeply( $round, $object, "$name: YAML.pm round-trips correctly" );		
		}

		# Test reading with YAML.pm
		my $yamlpm_copy = $string;
		my @yamlpm_in   = eval { YAML::Load( $yamlpm_copy ) };
		Test::More::is( $@, '', "$name: YAML.pm loads without error" );
		Test::More::is( $yamlpm_copy, $string, "$name: YAML.pm does not modify the input string" );
		SKIP: {
			Test::More::skip( "Shortcutting after failure", 1 ) if $@;
			Test::More::is_deeply( \@yamlpm_in, $object, "$name: YAML.pm parses correctly" );
		}
	}

	# If YAML::Syck itself is available, test with it
	SKIP: {
		unless ( $HAVE_SYCK ) {
			Test::More::skip( "Skipping YAML::Syck, not available for testing", 8 );
		}
		if ( $options{nosyck} ) {
			Test::More::skip( "Skipping YAML::Syck for known-broken feature", 8 );
		}
		unless ( @$object == 1 ) {
			Test::More::skip( "Skipping YAML::Syck for unsupported feature", 8 );
		}

		# Test writing with YAML::Syck
		my $syck_out = eval { YAML::Syck::Dump( @$object ) };
		Test::More::is( $@, '', "$name: YAML::Syck saves without error" );
		SKIP: {
			Test::More::skip( "Shortcutting after failure", 4 ) if $@;
			Test::More::ok(
				!!(defined $syck_out and ! ref $syck_out),
				"$name: YAML::Syck serializes correctly",
			);
			my @syck_round = eval { YAML::Syck::Load( $syck_out ) };
			Test::More::is( $@, '', "$name: YAML::Syck round-trips without error" );
			Test::More::skip( "Shortcutting after failure", 2 ) if $@;
			my $round = bless [ @syck_round ], 'YAML::Tiny';
			Test::More::isa_ok( $round, 'YAML::Tiny' );
			Test::More::is_deeply( $round, $object, "$name: YAML::Syck round-trips correctly" );		
		}

		# Test reading with YAML::Syck
		my $syck_copy = $string;
		my @syck_in   = eval { YAML::Syck::Load( $syck_copy ) };
		Test::More::is( $@, '', "$name: YAML::Syck loads without error" );
		Test::More::is( $syck_copy, $string, "$name: YAML::Syck does not modify the input string" );
		SKIP: {
			Test::More::skip( "Shortcutting after failure", 1 ) if $@;
			Test::More::is_deeply( \@syck_in, $object, "$name: YAML::Syck parses correctly" );
		}
	}

	# If YAML::XS itself is available, test with it
	SKIP: {
		unless ( $HAVE_XS ) {
			Test::More::skip( "Skipping YAML::XS, not available for testing", 8 );
		}
		if ( $options{noxs} ) {
			Test::More::skip( "Skipping YAML::XS for known-broken feature", 8 );
		}

		# Test writing with YAML::XS
		my $xs_out = eval { YAML::XS::Dump( @$object ) };
		Test::More::is( $@, '', "$name: YAML::XS saves without error" );
		SKIP: {
			Test::More::skip( "Shortcutting after failure", 4 ) if $@;
			Test::More::ok(
				!!(defined $xs_out and ! ref $xs_out),
				"$name: YAML::XS serializes correctly",
			);
			my @xs_round = eval { YAML::XS::Load( $xs_out ) };
			Test::More::is( $@, '', "$name: YAML::XS round-trips without error" );
			Test::More::skip( "Shortcutting after failure", 2 ) if $@;
			my $round = bless [ @xs_round ], 'YAML::Tiny';
			Test::More::isa_ok( $round, 'YAML::Tiny' );
			Test::More::is_deeply( $round, $object, "$name: YAML::XS round-trips correctly" );		
		}

		# Test reading with YAML::XS
		my $xs_copy = $string;
		my @xs_in   = eval { YAML::XS::Load( $xs_copy ) };
		Test::More::is( $@, '', "$name: YAML::XS loads without error" );
		Test::More::is( $xs_copy, $string, "$name: YAML::XS does not modify the input string" );
		SKIP: {
			Test::More::skip( "Shortcutting after failure", 1 ) if $@;
			Test::More::is_deeply( \@xs_in, $object, "$name: YAML::XS parses correctly" );
		}
	}

	# Does the string parse to the structure
	my $yaml_copy = $string;
	my $yaml      = eval { YAML::Tiny->read_string( $yaml_copy ); };
	Test::More::is( $@, '', "$name: YAML::Tiny parses without error" );
	Test::More::is( $yaml_copy, $string, "$name: YAML::Tiny does not modify the input string" );
	SKIP: {
		Test::More::skip( "Shortcutting after failure", 2 ) if $@;
		Test::More::isa_ok( $yaml, 'YAML::Tiny' );
		Test::More::is_deeply( $yaml, $object, "$name: YAML::Tiny parses correctly" );
	}

	# Does the structure serialize to the string.
	# We can't test this by direct comparison, because any
	# whitespace or comments would be lost.
	# So instead we parse back in.
	my $output = eval { $object->write_string };
	Test::More::is( $@, '', "$name: YAML::Tiny serializes without error" );
	SKIP: {
		Test::More::skip( "Shortcutting after failure", 5 ) if $@;
		Test::More::ok(
			!!(defined $output and ! ref $output),
			"$name: YAML::Tiny serializes correctly",
		);
		my $roundtrip = eval { YAML::Tiny->read_string( $output ) };
		Test::More::is( $@, '', "$name: YAML::Tiny round-trips without error" );
		Test::More::skip( "Shortcutting after failure", 2 ) if $@;
		Test::More::isa_ok( $roundtrip, 'YAML::Tiny' );
		Test::More::is_deeply( $roundtrip, $object, "$name: YAML::Tiny round-trips correctly" );

		# Testing the serialization
		Test::More::skip( "Shortcutting perfect serialization tests", 1 ) unless $options{serializes};
		Test::More::is( $output, $string, 'Serializes ok' );
	}

	# Return true as a convenience
	return 1;
}

sub slurp {
	my $file = shift;
	local $/ = undef;
	open( FILE, " $file" ) or die "open($file) failed: $!";
	my $source = <FILE>;
	close( FILE ) or die "close($file) failed: $!";
	$source;
}

sub load_ok {
	my $name = shift;
	my $file = shift;
	my $size = shift;
	Test::More::ok( -f $file, "Found $name" );
	Test::More::ok( -r $file, "Can read $name" );
	my $content = slurp( $file );
	Test::More::ok( (defined $content and ! ref $content), "Loaded $name" );
	Test::More::ok( ($size < length $content), "Content of $name larger than $size bytes" );
	return $content;
}

1;