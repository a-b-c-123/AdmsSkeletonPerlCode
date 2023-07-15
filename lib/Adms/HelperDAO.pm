package Adms::HelperDAO;
#-------------------------------------------------------------------------------
# Downloaded from https://github.com/hpham-abc123/AdmsSkeletonPerlCode.git
#-------------------------------------------------------------------------------
use Data::Dumper; 
use Enmac::RDBMS;

use lib 'lib';
use Adms::Config;

our $rdbms = undef;
our $logger = undef;
my $host_list = undef;

sub configure{
    my $new_rdbms = shift;
    my $new_logger = shift;
    $rdbms = $new_rdbms;
    $logger = $new_logger;
}

sub fetch_host_list{
    return $host_list if defined $host_list;
    my $sql =q{
    SELECT
        host_name,
        host_priority
    FROM
        host_details
    WHERE
        host_type = 1
    ORDER BY host_priority
    };
    my $sth = $rdbms->prepare($sql);
    $sth->execute();
    while (my @row = $sth->fetchrow_array){
        my ($name, $priority ) = @row;
        $host_list->{$priority} = $name;
    }
    return $host_list;

};

# Run the class function to inject all the dependency object before usage;
Adms::HelperDAO::configure(Adms::Config::rdbms, Adms::Config::logger);

# Module success
1;
