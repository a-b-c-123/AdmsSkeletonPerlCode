use strict;
use warnings;
use Test::More;
use lib 'lib';
use lib 't/lib';
use Test::MockObject;
use Adms::Component;
use Adms::Constants;
use Adms::Config;

# Create mock objects using Test::MockObject
my $mock_rt = Test::MockObject->new();
$mock_rt->mock('FetchValue', sub { return 123; });

my $mock_logger = Test::MockObject->new();

my $mock_dao = Test::MockObject->new();
$mock_dao->mock('is_attr_exist', sub { return shift->{_is_attr_exist}; });
$mock_dao->mock('is_rt_attr', sub { return shift->{_is_rt_attr}; });
$mock_dao->mock('fetch_value', sub { return shift->{_fetch_value}; });
$mock_dao->mock('fetch_id', sub { return shift->{_fetch_id}; });

Adms::Component->configure($mock_dao,  $mock_rt, $mock_logger);
# Create an instance of the Component class
$mock_dao->{_fetch_id} = 'Test 123';
my $comp = Adms::Component->new('Test_Alias');

subtest "Test object creation" => sub {
    plan tests => 1;
    isa_ok($comp, 'Adms::Component', 'Object is an instance of Component');
};

subtest "Test get alias" => sub {
    is($comp->alias, 'Test_Alias');
};

subtest "Test fetch_value on attribute that does not exist" => sub {
    $mock_dao->{_is_attr_exist} = 0;
    eval { $comp->value('Attr_not_exist'); };
    my $exp = Const::ERR_ATTR_NOT_EXIST;
    if ($@ =~ /$exp/) {
        is(1, 1);
    } else {
        ok(0);
    }
};

subtest "Test fetch_value on attribute exist and rdbms" => sub {
    $mock_dao->{_is_attr_exist} = 1;
    $mock_dao->{_fetch_value} = 5;
    is($comp->value('Exist_attribute'), 5);
};

subtest "Test fetch_value on attribute exist and realtime" => sub {
    $mock_dao->{_is_attr_exist} = 1;
    $mock_dao->{_is_rt_attr} = 1;
    is($comp->value('Exist_attribute'), 123);
};

done_testing();

