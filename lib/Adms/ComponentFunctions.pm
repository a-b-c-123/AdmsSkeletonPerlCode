#-------------------------------------------------------------------------------
# Package definition
#-------------------------------------------------------------------------------
package Adms::ComponentFunctions;
#-------------------------------------------------------------------------------
# Downloaded from https://github.com/hpham-abc123/AdmsSkeletonPerlCode.git
#-------------------------------------------------------------------------------


use IsFalseChain;
use Data::Dumper;
use Exporter qw(import);

our @EXPORT_OK = qw(is_control_allow is_control_tlq_inhibited is_good_quality is_out_of_service);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

#-------------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------------
use constant TLQ_SCAN_INHIBIT => 0;
use constant TLQ_CONTROL_INHIBIT => 3;

use constant PERMIT_OUT_OF_SERVICE => 'Out of Service';

#F----------------------------------------------------------------------------
#F                           FUNCTION DECLARATION
#F----------------------------------------------------------------------------
#F
#F  Name     : is_control_allow
#F
#F  Synopsis : Return True if condition is allow for sending control
#F
#F  Inputs   : Component
#F
#F  Outputs  : None
#F
#F  Returns  : Status. True/False
#F
#F  Globals  : None
#F
#F----------------------------------------------------------------------------
#F                           FUNCTION DESCRIPTION
#F----------------------------------------------------------------------------
#F
#F  Return True if the component is not Out of Service and Control Inhibit Tag
#F  is not present
#F
#F----------------------------------------------------------------------------
sub is_control_allow {
    my $comp = shift;
    # Adding an example on using chain of responsibity instead of multiple if statements
    # the help with making the code more testable in unit testing
    my $is_not_ctrl_tlq_inhibited_handler = IsFalseChain->new(\&is_control_tlq_inhibited);
    my $is_not_oos_handler = IsFalseChain->new(\&is_out_of_service, $is_not_ctrl_tlq_inhibited_handler);
    
    # The code basically does if the component is not control inhibited and not out of service then return True
    return $is_not_oos_handler->check($comp);
}

#F----------------------------------------------------------------------------
#F                           FUNCTION DECLARATION
#F----------------------------------------------------------------------------
#F
#F  Name     : is_out_of_service
#F
#F  Synopsis : Return True if there is an Out Of Service Document on Issued
#F
#F  Inputs   : Component
#F
#F  Outputs  : None
#F
#F  Returns  : Status. True/False
#F
#F  Globals  : PERMIT_OUT_OF_SERVICE
#F
#F----------------------------------------------------------------------------
#F                           FUNCTION DESCRIPTION
#F----------------------------------------------------------------------------
#F
#F  Return True  if there is an Out Of Service Document on Issued
#F  
#F
#F----------------------------------------------------------------------------

sub is_out_of_service{
    my $comp = shift;
    return $comp->dao->is_doc_on_issued($comp, PERMIT_OUT_OF_SERVICE);
}

#F----------------------------------------------------------------------------
#F                           FUNCTION DECLARATION
#F----------------------------------------------------------------------------
#F
#F  Name     : is_control_tlq_inhibited
#F
#F  Synopsis : Return True if there is an Out Of Service Document on Issued
#F
#F  Inputs   : Component
#F
#F  Outputs  : None
#F
#F  Returns  : Status. True/False
#F
#F  Globals  : TLQ_CONTROL_INHIBIT
#F
#F----------------------------------------------------------------------------
#F                           FUNCTION DESCRIPTION
#F----------------------------------------------------------------------------
#F
#F  Return True  if there is a TLQ CONTROL INHIBITED TAG
#F
#F
#F----------------------------------------------------------------------------

sub is_control_tlq_inhibited {
    my $comp = shift;
    return $comp->dao->is_tlq_present($comp, TLQ_CONTROL_INHIBIT);
}

#F----------------------------------------------------------------------------
#F                           FUNCTION DECLARATION
#F----------------------------------------------------------------------------
#F
#F  Name     : is_good_quality
#F
#F  Synopsis : Return True if the Quality of the attribute is 0
#F
#F  Inputs   : Component
#F
#F  Outputs  : None
#F
#F  Returns  : Status. True/False
#F
#F  Globals  : None
#F
#F----------------------------------------------------------------------------
#F                           FUNCTION DESCRIPTION
#F----------------------------------------------------------------------------
#F
#F  Return True  if the Quality of the attribute is 0
#F
#F
#F----------------------------------------------------------------------------
sub is_good_quality {
    my $comp = shift;
    my $attr = shift;
    my $prop = $comp->alias . ".$attr";
    return $comp->rt->FetchQuality($prop) ? 0 : 1;
}

# Module success
1;

