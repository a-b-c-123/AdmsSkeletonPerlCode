use strict;
use warnings;
use Test::More;
use Data::Dumper;
use lib 'lib';
use Adms::ComponentDAO;

use lib 't/lib';
use Test::MockObject;

my $mock_data = undef;

# Create mock objects using Test::MockObject
my $mock_rdbms = Test::MockObject->new();
my $mock_sth = Test::MockObject->new();
my $mock_fetchrow_array = undef;
$mock_rdbms->mock('prepare', sub { return $mock_sth; });
$mock_sth->mock('execute', sub { return ''; });
$mock_sth->mock('fetchrow_array',  sub { return $mock_fetchrow_array; });

my $mock_comp = Test::MockObject->new();
$mock_comp->mock('alias', sub {return 'test_alias'});

my $test_alias = 'Test_Alias';
my $mock_logger = Test::MockObject->new();
my $comp_dao = Adms::ComponentDAO->get_instance();
$comp_dao->configure($mock_rdbms, $mock_logger);

subtest "Test object creation" => sub {
    plan tests => 1;
    isa_ok($comp_dao, 'Adms::ComponentDAO', 'Object is an instance of Component');
};

SKIP: {
    skip 'Methods have not been tested. Please test it with real data in your system', 1;

    subtest "Test is_attr_exist" => sub {
        ok($comp_dao->is_attr_exist($mock_comp, 'Scan Value'));
        ok(! $comp_dao->is_attr_exist($mock_comp, 'Scan Value1'));
    };

    subtest "Test is_rt_attr" => sub {
        ok($comp_dao->is_attr_exist('Scan Value'));
        ok(! $comp_dao->is_attr_exist('Display Name'));
    };


    subtest "Test fetch_value" => sub {
        is($comp_dao->fetch_value('Scan Value'), 1);
    };

    subtest "get_sth_is_doc_on_issued" => sub {
        ok(1);
        print(Dumper($comp_dao->get_sth_is_doc_on_issued()));

    };
}


done_testing();
