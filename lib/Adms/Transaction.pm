#-------------------------------------------------------------------------------
# Package definition
#-------------------------------------------------------------------------------
package Adms::Transaction;

use Adms::Helper;

#-------------------------------------------------------------------------------
# global variables
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Function : diff
#-------------------------------------------------------------------------------
# Show the transation difference between 2 servers as an integer value
sub diff{
    my ($srv1, $srv2) = @_;
    my $lsn_cmd =qq{};
    return Adms::Helper::from_cmd($lsn_cmd);
}

#-------------------------------------------------------------------------------
# Function : in_sync
#-------------------------------------------------------------------------------
sub in_sync{
    my $current_server = shift;
    my $servers_list = shift;
    my $acceptable_diff = shift;
    foreach my $srv_priority (keys %$servers_list){
       my $srv_name = $servers_list->{$srv_priority};
       next if $srv_name == $current_server;
       return 0 if abs(diff($current_server, $srv_name)) > $acceptable_diff;
    }
    return 1;
}

# Module success
1;

