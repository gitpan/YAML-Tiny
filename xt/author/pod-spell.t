use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.006005
use Test::Spelling 0.12;
use Pod::Wordlist;


add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib  ) );
__DATA__
Adam
Kennedy
adamk
Alexandr
Ciornii
chorny
Craig
Berry
craigberry
David
Golden
dagolden
Graham
Knop
haarg
Ingy
döt
Net
ingy
James
Keenan
jkeenan
Karen
Etheridge
ether
Neil
Bowers
neil
Olivier
Mengué
dolmen
Steffen
Müller
smueller
יובל
קוג
Yuval
Kogman
nothingmuch
lib
YAML
Tiny
