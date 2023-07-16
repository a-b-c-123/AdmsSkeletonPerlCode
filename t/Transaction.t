use strict;
use warnings;
use Test::More;
use Data::Dumper;
use lib 't/lib';
use Test::Mock::Simple;
use lib 'lib';

# Load the module to be tested
require_ok( 'Adms::Transaction' );

my $mock_result = undef;
my $mock = Test::Mock::Simple->new(module =>'Adms::Helper');
$mock->add(from_cmd => sub {return shift $mock_result; });

subtest "Test diff funciton" => sub {
    plan tests => 3;
    my $srv1 ='server1';
    my $srv2 ='server2';

    $mock_result = [10];
    is(Adms::Transaction::diff($srv1, $srv2), 10);

    $mock_result = [-10];
    is(Adms::Transaction::diff($srv1, $srv2), -10);

    $mock_result = [0];
    is(Adms::Transaction::diff($srv1, $srv2), 0);
};

subtest "Test in_sync function" => sub {
    plan tests => 4;
    my $current_srv ='server1';
    my $srv_list = {
        1 => $current_srv,
        2 => 'srv2',
        3 => 'srv3',
    };
    my $acceptable_diff = 5;
    $mock_result = [0, 2, 4];
    ok(Adms::Transaction::in_sync($current_srv, $srv_list, $acceptable_diff), 'Check if current server transaction is within an acceptable value with the first servers');

    $mock_result = [4, 2, 10];
    ok(Adms::Transaction::in_sync($current_srv, $srv_list, $acceptable_diff), 'Check if current server transaction is within an acceptable value with other servers');

    $mock_result = [6, 2, 10];
    ok(Adms::Transaction::in_sync($current_srv, $srv_list, $acceptable_diff), 'Check if current server transaction is outside an acceptable value with first servers');

    $mock_result = [0, 6, 10];
    ok(Adms::Transaction::in_sync($current_srv, $srv_list, $acceptable_diff), 'Check if current server transaction is outside an acceptable value with other servers');
};

done_testing();

