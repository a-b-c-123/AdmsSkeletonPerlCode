
package Adms::ComponentDAO;
#-------------------------------------------------------------------------------
# Downloaded from https://github.com/hpham-abc123/AdmsSkeletonPerlCode.git
#-------------------------------------------------------------------------------

use Data::Dumper; 
use Adms::Constants;
use Adms::Config;

my $rdbms = undef;
my $logger = undef;
my $sth_is_attr_exist = undef;
my $sth_is_rt_attr = undef;
my $sth_fetch_val = undef;
my $sth_is_doc_on_issued = undef;
my $sth_is_tlq_present = undef;
my $sth_fetch_comp_id = undef;

# Private package-level variable to hold the singleton instance
my $instance = undef;

sub new {
    my $class = shift;

    # Check if an instance already exists
    return $instance if defined $instance;

    my $self = {};
    bless $self, $class;
    Adms::ComponentDAO->configure(Adms::Config::rdbms, Adms::Config::logger);
    $instance = $self;
    return $self;
}

# Accessor method to retrieve the singleton instance
sub get_instance {
    my $class = shift;
    return $instance // $class->new();
}

# Setting up object dependency injection
sub configure{
    my ($class, $rdbms1, $logger1) = @_;
    $rdbms = $rdbms1;
    $logger = $logger1;
}

sub is_doc_on_issued{
    my ($self, $comp, $document_name) = @_;
    my $sth = $self->_get_sth_is_doc_on_issued();
    $sth->execute($comp->alias, $document_name);
    my ($row) = $sth->fetchrow_array;
    return $row ? 1 : 0;
}

sub is_tlq_present{
    my ($self, $comp, $tag_type) = @_;
    my $sth = $self->_get_sth_is_tlq_present();
    $sth->execute($comp->alias, $tag_type);
    my ($row) = $sth->fetchrow_array;
    return $row ? 1 : 0;
}

sub is_attr_exist {
    my ($self, $comp, $attr) = @_;
    my $sth = $self->_get_sth_is_attr_exist();
    $sth->execute($comp->alias, $attr);
    my @row = $sth->fetchrow_array;
    my ($row_count) = @row;;
    return $row_count > 0 ? 1 : 0;
}

# Attribute Location is RT
sub is_rt_attr {
    my ($self, $comp, $attr) = @_;
    my $sth = $self->_get_sth_is_rt_attr();
    $sth->execute($comp->alias, $attr);
    my ($attribute_location) = $sth->fetchrow_array;
    return $attribute_location == 1 ? 1 : 0;
}

sub fetch_value{
    my ($self, $comp, $attr) = @_;
    my $sth = $self->_get_sth_fetch_val();
    $sth->execute($comp->alias, $attr);
    my ($val) = $sth->fetchrow_array;
    $val = "" unless defined $val;
    return $val;
}

sub fetch_id{
    my ($self, $comp) = @_;
    my $sth = $self->_get_sth_comp_id();
    $sth->execute($comp->alias);
    my ($val) = $sth->fetchrow_array;
    return $val;
}


sub _get_sth_is_doc_on_issued{
    return $sth_is_doc_on_issued if defined $sth_is_doc_on_issued;
    $sth_is_doc_on_issued = $rdbms->prepare(
        q{
        SELECT
            'x'
        FROM
            permits p
            JOIN component_header ch ON p.attached_component_id = ch.component_id
        where ch.component_alias = ?
        and ch.component_patch_number < 1
        and p.permit_name = ?
        AND p.current_state = 'Issued'
        }
    );
    return $sth_is_doc_on_issued;
}

sub _get_sth_is_attr_exist{
    return $sth_is_attr_exist if defined $sth_is_attr_exist;
    $sth_is_attr_exist = $rdbms->prepare(
        q{
            SELECT 
                COUNT(*)
            FROM component_header ch
                JOIN component_attributes ca ON ch.component_id = ca.component_id
            WHERE ch.component_alias = ? AND
                ca.attribute_name = ? AND
                ch.component_patch_number < 1
        }
    );
    return $sth_is_attr_exist;
}

sub _get_sth_is_rt_attr{
    return $sth_is_rt_attr if defined $sth_is_rt_attr;
    $sth_is_rt_attr = $rdbms->prepare(
        q{
        SELECT ca.attribute_location
        FROM component_header ch
        JOIN component_attributes ca ON ch.component_id = ca.component_id
        WHERE ch.component_alias = ? AND
            ca.attribute_name = ? AND
            ch.component_patch_number < 1
        }
    );
    return $sth_is_rt_attr;
}

sub _get_sth_is_tlq_present{
    return $sth_is_tlq_present if defined $sth_is_tlq_present;
    $sth_is_tlq_present = $rdbms->prepare(
        q{
        SELECT
            'x'
        FROM
            component_tag
        WHERE component_alias = ? AND tag_type = ?
        }
    );
    return $sth_is_tlq_present;
}

sub _get_sth_fetch_val{
    return $sth_fetch_val if defined $sth_fetch_val;
    $sth_fetch_val = $rdbms->prepare(
        q{
            SELECT ca.attribute_value
            FROM component_header ch
            JOIN component_attributes ca ON ch.component_id = ca.component_id
            WHERE ch.component_alias = ? AND
                ca.attribute_name = ? AND
                ch.component_patch_number < 1
        }
    );
    return $sth_fetch_val;
}

sub _get_sth_comp_id{
    return $sth_fetch_comp_id  if defined $sth_fetch_comp_id;
    $sth_fetch_comp_id = $rdbms->prepare(
        q{
        SELECT
            component_id
        FROM
            component_header
        WHERE component_alias = ? 
            AND component_patch_number < 1
        }
    );
    return $sth_fetch_comp_id;
	
}

# Module success
1;
