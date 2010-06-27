#!/usr/bin/env perl

use warnings;
use strict;

use lib './lib';

use Test::More tests => 11;
# use Cwd;

# die getcwd();
BEGIN {
    use_ok 'Manufactopia::Simulator';

    use_ok 'Manufactopia::Grid';
    use_ok 'Manufactopia::Cursor';

    use_ok 'Manufactopia::ConfigParser';
    use_ok 'Manufactopia::InputParser';

    use_ok 'Manufactopia::Widget';
    use_ok 'Manufactopia::Widget::Conveyor';
    use_ok 'Manufactopia::Widget::Writer';
    use_ok 'Manufactopia::Widget::Branch';
    use_ok 'Manufactopia::Widget::Input';
    use_ok 'Manufactopia::Widget::Output';
}
