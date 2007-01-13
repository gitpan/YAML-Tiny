#!/usr/bin/perl -w

# Testing of common META.yml examples

use strict;
use File::Spec::Functions ':ALL';
BEGIN {
	$| = 1;
}

use lib catdir('t', 'lib');
use MyTests;
use Test::More tests(3);
use YAML::Tiny;





#####################################################################
# In META.yml files, some hash keys contain module names

# Hash key legally containing a colon
yaml_ok(
	"---\nFoo::Bar: 1\n",
	[ { 'Foo::Bar' => 1 } ],
	'module_hash_key',
);

# Hash indented
yaml_ok(
	  "---\n"
	. "  foo: bar\n",
	[ { foo => "bar" } ],
	'hash_indented',
);





#####################################################################
# Support for literal multi-line scalars

# Declarative multi-line scalar
yaml_ok(
	  "---\n"
	. "  foo: >\n"
	. "     bar\n"
	. "     baz\n",
	[ { foo => "bar baz\n" } ],
	'simple_multiline',
);

exit(0);
