package Adms::Config;
#-------------------------------------------------------------------------------
# Downloaded from https://github.com/hpham-abc123/AdmsSkeletonPerlCode.git
#-------------------------------------------------------------------------------
use strict;
use warnings;
use Enmac::RDBMS;
use Enmac::Realtime;
use Data::Dumper;

use Adms::StdoutLogger;

my $_rdbms = undef;
my $_rt = undef;
my $_logger = undef;

sub rdbms{
    my $new_rdbms = shift;
    $_rdbms = $new_rdbms if defined $new_rdbms;
    return $_rdbms if defined $_rdbms;
    $_rdbms = new Enmac::RDBMS(user_name => "ENMAC");
    return $_rdbms;
}

sub rt{
    my $new_rt = shift;
    $_rt = $new_rt if defined $new_rt;
    return $_rt if defined $_rt;
    $_rt = 'RealTimeApi';
    return $_rt;
}

sub logger{
    my $new_logger = shift;
    $_logger = $new_logger if defined $new_logger;
    return $_logger if  defined $_logger;

    $_logger = Adms::StdoutLogger->get_logger() unless defined $_logger;
    return $_logger;
}

# Module success
1;
