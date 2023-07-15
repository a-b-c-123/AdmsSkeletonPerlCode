use strict;
use warnings;
use Test::More;
use Data::Dumper;
use lib 't/lib';
use Test::Mock::Simple;
use lib 'lib';
use Adms::Service;

# Mocking the _from_cmd function
my $mock_from_cmd_result_str = undef;
my @mock_from_cmd_result = [];
my $mock_from_cmd = Test::Mock::Simple->new(module => 'Adms::Service');
$mock_from_cmd->add('_from_cmd', sub {
    my $cmd = shift;
    if ($cmd eq 'ps -u enmac -u oracle -o comm | grep \'lanmon\|hbeat\|msgserver\|tmngr\|tnslsnr\|init_shmem\'') {
        return split(' ', $mock_from_cmd_result_str);

    } elsif ($cmd =~ /timeout 1 lsn_data -o -n/) {
        my $d = shift @mock_from_cmd_result;
        return $d;
    } else {
        return "";  # Return empty string for other commands
    }
});

# Test for the is_online function
subtest 'is_online function test' => sub {

    # Test when there are active running processes
    $mock_from_cmd_result_str = "tnslsnr\nhbeat\nlanmon\nmsgserver\ninit_shmem\ntmngr";
    ok(Adms::Service::is_online(), "is_online returns true when there are active running processes");

    # Test when there are not enough active running processes
    $mock_from_cmd_result_str = "tnslsnr\nhbeat\nlanmon\nmsgserver\ninit_shmem\n";
    ok(!Adms::Service::is_online(), "is_online returns false when there are not enough active running processes");
};

# Test for the am_i_highest_priority_running function
subtest 'am_i_highest_priority_running function test' => sub {
    my $server_list = {
        '1' => 'server1',
        '2' => 'server2',
        '3' => 'server3'
    };

    # Test when the highest priority server is online and matches the hostname
    $Adms::Service::hostname = 'server1';
    @mock_from_cmd_result = ( "UP", "UP" );
    ok(Adms::Service::am_i_highest_priority_running($server_list), "am_i_highest_priority_running returns true when the highest priority server is online and matches the hostname");

    # Test when the highest priority server is online but does not match the hostname
    @mock_from_cmd_result = ( "UP", "UP" );
    $Adms::Service::hostname = 'server2';
    ok(!Adms::Service::am_i_highest_priority_running($server_list), "am_i_highest_priority_running returns false when the highest priority server is online but does not match the hostname");

    # Test when the highest priority server is not online
    @mock_from_cmd_result = ( "DOWN", "UP" );
    $Adms::Service::hostname = 'server2';
    ok(Adms::Service::am_i_highest_priority_running($server_list), "am_i_highest_priority_running returns True when the highest priority server is not online and I am acting as the highest priority server");

    # Test when the highest priority server is not online
    @mock_from_cmd_result = ( "DOWN", "DOWN", "UP" );
    $Adms::Service::hostname = 'server3';
    ok(Adms::Service::am_i_highest_priority_running($server_list), "am_i_highest_priority_running returns True when 2 highest priority server is not online and I am acting as the highest priority server");
    
    
    
};

done_testing();

