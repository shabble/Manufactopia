#!/usr/bin/env perl

use warnings;
use strict;

use lib './lib';

use FindBin qw/$RealBin/;

use Test::More; # tests => 10;
use Test::Exception;
use Data::Dumper;

BEGIN {
#    use_ok 'Manufactopia::Grid';
    use_ok 'Manufactopia::Cursor';
    # use_ok 'Manufactopia::Widget::Conveyor';
    # use_ok 'Manufactopia::Widget::Input';
}

my $cursor = new_ok ('Manufactopia::Cursor');

# tape tests
my $tape = [qw/R B R B R B B B/];

is_deeply ($cursor->tape, [], 'tape is initially empty');
ok ($cursor->tape_write('R'), 'writing to tape');
is ($cursor->tape_peek, 'R', 'peeking at tape');

is ($cursor->tape_read, 'R', 'reading from tape');
is ($cursor->tape_read, undef, 'undef read from empty tape');

is_deeply ($cursor->tape, [], 'tape is  empty');

$cursor->tape($tape);
is_deeply ($cursor->tape, $tape, 'tape is set');
ok ($cursor->tape_compare($tape), 'tape_compare matches correctly');

my ($x, $y) = (10, 1);

$cursor->relocate($x, $y);
is($cursor->xpos, $x, 'x pos set correctly');
is($cursor->ypos, $y, 'y pos set correctly');

# TODO: move and move_* testing with rotations


done_testing;

