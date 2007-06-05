#!/usr/bin/perl

# Testing of common META.yml examples

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use File::Spec::Functions ':ALL';
use lib catdir('t', 'lib');
use MyTests;
use Test::More tests(12);
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
	nosyck => 1,
);

# Piped multi-line scalar
yaml_ok( <<'END_YAML', [ [ "foo\nbar\n", 1 ] ], 'indented', nosyck => 1 );
---
- |
  foo
  bar
- 1
END_YAML

# ... with a pointless hyphen
yaml_ok( <<'END_YAML', [ [ "foo\nbar", 1 ] ], 'indented', nosyck => 1 );
---
- |-
  foo
  bar
- 1
END_YAML






#####################################################################
# Support for YAML document version declarations

# Simple case
yaml_ok(
	<<'END_YAML',
--- #YAML:1.0
foo: bar
END_YAML
	[ { foo => 'bar' } ],
	'simple_doctype',
	nosyck => 1,
);

# Multiple documents
yaml_ok(
	<<'END_YAML',
--- #YAML:1.0
foo: bar
--- #YAML:1.0
- 1
--- #YAML:1.0
foo: bar
END_YAML
	[ { foo => 'bar' }, [ 1 ], { foo => 'bar' } ],
	'multi_doctype',
	nosyck => 1,
);





#####################################################################
# Hitchhiker Scalar

yaml_ok(
	<<'END_YAML',
--- 42
END_YAML
	[ 42 ],
	'hitchhiker scalar',
	serializes => 1,
);





#####################################################################
# Null HASH/ARRAY

yaml_ok(
	<<'END_YAML',
---
- foo
- {}
- bar
END_YAML
	[ [ 'foo', {}, 'bar' ] ],
	'null hash in array',
);

yaml_ok(
	<<'END_YAML',
---
- foo
- []
- bar
END_YAML
	[ [ 'foo', [], 'bar' ] ],
	'null array in array',
);

yaml_ok(
	<<'END_YAML',
---
foo: {}
bar: 1
END_YAML
	[  { foo => {}, bar => 1 } ],
	'null hash in hash',
);

yaml_ok(
	<<'END_YAML',
---
foo: []
bar: 1
END_YAML
	[  { foo => [], bar => 1 } ],
	'null array in hash',
);

exit(0);
