package Adms::Component;
#-------------------------------------------------------------------------------
# Downloaded from https://github.com/hpham-abc123/AdmsSkeletonPerlCode.git
#-------------------------------------------------------------------------------
use Data::Dumper;
use Adms::Config;
use Adms::ComponentDAO;
use Adms::Constants;

my $_dao = undef;
my $_rt = undef;
my $_logger = undef;

sub new {
    my $class = shift;
    my $alias = shift;
    # Injecting all the external object into the class for usage
    Adms::Component->configure( new Adms::ComponentDAO(),
            Adms::Config::rt,
            Adms::Config::logger) unless defined $_dao;
    my $self = {
        alias => $alias,
    };
    bless $self, $class;
    $self->{id} = $self->dao->fetch_id($self);
    die Const::ERR_COMP_NOT_EXIST . " -> Alias: $alias\n" unless defined $self->{id};
    return $self;
}

sub configure{
    my $class = shift;
    my $dao = shift;
    my $rt = shift;
    my $logger = shift;
    $_dao = $dao;
    $_rt = $rt;
    $_logger = $logger;
}

sub dao{
    return $_dao;
}

sub rt{
    return $_rt;
}

sub alias{
    my $self = shift;
    return $self->{alias};
}

sub value {
    my $self = shift;
    my $attr = shift;
    my $prop = "$self->{alias}.$attr";
    die Const::ERR_ATTR_NOT_EXIST unless $self->dao->is_attr_exist($self, $attr);
    return $self->dao->is_rt_attr($self, $attr) ? $self->rt->FetchValue($prop) : $self->dao->fetch_value($self, $attr);
}

# Module success
1;
