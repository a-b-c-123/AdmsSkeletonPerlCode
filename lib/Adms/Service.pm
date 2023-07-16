#M---------------------------------------------------------------------------
#M                            MODULE DESCRIPTION
#M---------------------------------------------------------------------------
#M
#M 
#M
#M---------------------------------------------------------------------------
package Adms::Service;

#-------------------------------------------------------------------------------
# Used modules
#-------------------------------------------------------------------------------

use strict;
use warnings;
use Sys::Hostname;
use Data::Dumper;

use lib 'lib';
use Adms::HelperDAO;
use Adms::Helper;

#-------------------------------------------------------------------------------
# Used constants
#-------------------------------------------------------------------------------
use constant ACTIVE_RUNNING_PROCESSES => 6; # use to check if ADMS 
                                            # service is running

# Use to check if the service is online
use constant LSN_DATA_UP_CMD_CHECK => 'timeout 1 lsn_data -o -n ';


#-------------------------------------------------------------------------------
# Global variables
#-------------------------------------------------------------------------------
# use $hostname variable so we only need to call once and allow to changing of 
# hostname during unit testing.
our $hostname = hostname();
                        
#-------------------------------------------------------------------------------
# Function : is_online - return 1 if online otherwise 0
#-------------------------------------------------------------------------------
sub is_online{

    my $from_cmd_fn = shift || \&Adms::Helper::from_cmd; #use for dependency injection
    my %processes = ();

    my $cmd = q{ps -u enmac -u oracle -o comm | grep 'lanmon\|hbeat\|msgserver\|tmngr\|tnslsnr\|init_shmem'};
    my @output = $from_cmd_fn->($cmd);
    chomp @output;
    foreach my $line (@output){
        $processes{$line} = {};
    }
    return (keys %processes) < ACTIVE_RUNNING_PROCESSES ? 0 : 1; 
}

#-------------------------------------------------------------------------------
# Function : am_i_highest_priority_running - return 1 if highest running 
#            otherwise 0
#-------------------------------------------------------------------------------
sub am_i_highest_priority_running{
    my $server_list = shift || Adms::HelperDAO::fetch_host_list;
    my $online_cmd_check = '';
    my $srv = undef;
    my $st = undef;
    
    # Using sort to sort the highest priority server first
    foreach my $priority (sort keys %{$server_list} ){
        $srv = $server_list->{$priority};
        $online_cmd_check = LSN_DATA_UP_CMD_CHECK . ' "' . $srv . '"';
        $st = Adms::Helper::from_cmd($online_cmd_check);
        if ($st =~ /UP/){
            #print("$srv eq $hostname\n");
            return ($srv eq $hostname) ? 1 : 0;
        }
    }
}

# Module success
1;
