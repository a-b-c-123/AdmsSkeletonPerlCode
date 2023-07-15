use strict;
use warnings;
use Test::More;
use Data::Dumper;
use lib 't/lib';
use Test::Mock::Simple;
use lib 'lib';
# Load the module to be tested
use Adms::StdoutLogger;

# Test constructor and get_logger method
sub test_constructor_and_get_logger {
    my $logger = Adms::StdoutLogger->get_logger();
    isa_ok($logger, 'Adms::StdoutLogger', 'Constructor and get_logger');
}

# Test level method
sub test_level {
    my $logger = Adms::StdoutLogger->get_logger();
    is($logger->level, 3, 'Default log level is INFO');
    $logger->level(2);
    is($logger->level, 2, 'Log level can be set');
    $logger->level(1);
}

# Test trace method
sub test_trace {
    my $logger = Adms::StdoutLogger->get_logger();
    # Capture the output and compare
    open(my $stdout, '>', \my $output) or die "Cannot open STDOUT: $!";
    local *STDOUT = $stdout;
    $logger->trace('This is a trace message');
    close($stdout);
    like($output, qr/TRACE>\tThis is a trace message/, 'Trace message is logged');
}

# Test debug method
sub test_debug {
    my $logger = Adms::StdoutLogger->get_logger();
    # Capture the output and compare
    open(my $stdout, '>', \my $output) or die "Cannot open STDOUT: $!";
    local *STDOUT = $stdout;
    $logger->debug('This is a debug message');
    close($stdout);
    like($output, qr/DEBUG>\tThis is a debug message/, 'Debug message is logged');
}

# Test info method
sub test_info {
    my $logger = Adms::StdoutLogger->get_logger();
    # Capture the output and compare
    open(my $stdout, '>', \my $output) or die "Cannot open STDOUT: $!";
    local *STDOUT = $stdout;
    $logger->info('This is a info message');
    close($stdout);
    like($output, qr/INFO>\tThis is a info message/, 'Info message is logged');
}

# Test warn method
sub test_warn {
    my $logger = Adms::StdoutLogger->get_logger();
    # Capture the output and compare
    open(my $stdout, '>', \my $output) or die "Cannot open STDOUT: $!";
    local *STDOUT = $stdout;
    $logger->warn('This is a trace message');
    close($stdout);
    like($output, qr/WARN>\tThis is a trace message/, 'warn message is logged');
}

# Test error method
sub test_error {
    my $logger = Adms::StdoutLogger->get_logger();
    # Capture the output and compare
    open(my $stdout, '>', \my $output) or die "Cannot open STDOUT: $!";
    local *STDOUT = $stdout;
    $logger->error('This is a trace message');
    close($stdout);
    like($output, qr/ERROR>\tThis is a trace message/, 'error message is logged');
}


# Test fatal method
sub test_fatal {
    my $logger = Adms::StdoutLogger->get_logger();
    # Capture the output and compare
    open(my $stdout, '>', \my $output) or die "Cannot open STDOUT: $!";
    local *STDOUT = $stdout;
    $logger->fatal('This is a trace message');
    close($stdout);
    like($output, qr/FATAL>\tThis is a trace message/, 'Fatal message is logged');
}


# Run the tests
plan tests => 9;
test_constructor_and_get_logger();
test_level();
test_trace();
test_debug();
test_info();
test_warn();
test_error();
test_fatal();
# Run other test methods for debug, info, warn, error, and fatal

done_testing();

