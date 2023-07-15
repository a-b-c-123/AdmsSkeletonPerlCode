# AdmsSkeletonPerlCode

A basic ADMS Skeleton Perl code is provided as a starting point for your project. 
The code includes several fundamental functions, such as checking if the service is 
running, verifying if the application is on highest operational priority server, and 
retrieving attribute values from an RDBMS/RT database. 

When running unit tests using the command 'prove -v,' you will encounter the 
following message: 'skip Methods have not been tested. Please test it with 
real data in your system.' This serves as a reminder to test this section 
of the code with actual data from your system, as using mock objects may not 
be appropriate and could potentially introduce bugs if not handled properly.

Hope this help you starting your project.

Have fun coding...
 
## Code Example

```perl
use strict;
use warnings;

use lib "lib";
use Adms::Component;
use Adms::Service;
use Adms::ComponentFunctions qw(:all);

sub main{

    if (Adms::Service::is_online()){
        print ("ADMS is online\n");
    }
    if (Adms::Service::am_i_highest_priority_running()){
        print("I am highest Priority Server\n");
    }

    my $test_comp = new Adms::Component('MMMBARC_FA5_GEN');

    print "\nFetching RT value: ";
    print $test_comp->value('Scan Value');

    print "\nFetching RDBMS value: ";
    print $test_comp->value('Displayed Name');
    print "\n\n";

    if (! is_control_tlq_inhibited($test_comp)){
        print("Control is not inhibited\n");
    }

    if (! is_out_of_service($test_comp)){
        print("No OOS document\n");
    }

    if (is_control_allow($test_comp)){
        print("Control is allow as no OOS document and control not inhibited\n");
    }
    
}

__PACKAGE__->main() unless caller;
```
 
## Additional Download modules

 - [Log4perl](https://metacpan.org/pod/Log::Log4perl)
 - [Test::MockObjec](https://metacpan.org/pod/Test::MockObject)
 - [Test::Mock::Simple](https://metacpan.org/pod/Test::Mock::Simple)
