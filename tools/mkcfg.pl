use Config::Simple;
use Getopt::Long;
use Pod::Usage;
our $VERSION = "0.1.0";

GetOptions ('h',    \$help,
	    'help', \$help,
	    'a',    \$abort_on_conflict,
	    't=s',    \$target,
	   );
pod2usage(-exitstatus => 0, -verbose => 2) if $help;

# we need to assume that some environment variables are available
# it is not clear to me if this program should assume the location
# of deployment.cfg under TARGET or if it should check the TARGET
# variable. For now, I think we'll not use the TARGET variable.
# die "envionment variable TARGET not defined" unless $ENV{TARGET};

my $global_cfg = Config::Simple->new( syntax => 'ini' );
my $local_cfg  = Config::Simple->new( syntax => 'ini' );

# if there is a global deployment.cfg file, read it
if (defined $target && $target ne "") {
	# then use the command line provided target
	die "$target is not a valid directory" unless -d $target;
	die "$target is not a writable directory" unless -w $target;
	$ENV{TARGET} = $target;
}
if (-e "$ENV{TARGET}/deployment.cfg" ) {
	$global_cfg->read("$ENV{TARGET}/deployment.cfg")
	  or die "can not read $ENV{TARGET}/deployment.cfg\n", $global_cfg->error();
	$global_cfg->save("$ENV{TARGET}/deployment.cfg.bak");
}

# if there is a module deploy.cfg available, read it 
if (-e './deploy.cfg') {
	$local_cfg->read('./deploy.cfg')
	  or die "can not read ./deploy.cfg", $local_cfg->error();
}

# merge the two configs, issueing a warning if the same key exists with
# different values between the two config files
foreach my $key (keys %{$local_cfg->vars()} ) {
    my $global_val = $global_cfg->param($key);
    my $local_val = $local_cfg->param($key);

    if ($global_val && !cfg_values_equal($global_val, $local_val))
    {
	my $gstr = ref($global_val) ? join(", ", @$global_val) : $global_val;
	my $lstr = ref($local_val) ? join(", ", @$local_val) : $local_val;
	warn "key conflict: global $key, $gstr\n",
		"key conflict: local  $key, $lstr\n",
		"keeping global config\n";
	die "and aborting -  on conflict is set to true" if defined $abort_on_conflict;
    }
    else {
	$global_cfg->param($key, $local_val);
    }
}

# write out the resulting global deployment config
$global_cfg->param('dev_container.version', $VERSION);
$global_cfg->write("$ENV{TARGET}/deployment.cfg") if $global_cfg->param();

sub cfg_values_equal
{
    my($v1, $v2) = @_;

    if (ref($v1) && !ref($v2))
    {
	$v2 = [$v2];
    }
    elsif (!ref($v1) && ref($v2))
    {
	$v1 = [$v1];
    }
    if (ref($v1))
    {
	if (@$v1 != @$v2)
	{
	    return 0;
	}
	for my $i (0..$#$v1)
	{
	    return 0 if $v1->[$i] ne $v2->[$i];
	}
	return 1;
    }
    else
    {
	return $v1 eq $v2;
    }
}



=pod

=head1  NAME

mkcfg

=head1  SYNOPSIS

=over

=item mkcfg -h, --help

=back

=head1  DESCRIPTION

The mkcfg command appends the module deploy.cfg file in the module
top level directory to the deployment.cfg file in the deployment top
level directory directory.

The deployment directory is specified by the $TARGET environment variable.

If neither file exists, then an empty deployment.cfg file is created.

If deploy.cfg exists but not deployment.cfg, then a deployment.cfg
is created that contains the contents of deploy.cfg.

If deployment.cfg exists but not deploy.cfg, then deployment.cfg
remains unchanged, but due to the write a new timestamp on the file
will occur.

If both files exist, a merge of the files will be attempted, and
as long as there are no conflicts between the values of a given key
in a given block the merge will succeed and a new deployment.cfg file
will be written.

If both files exist and there is a conflict between the values of
a given key in a given block, the program will issue a warning and
keep the global setting.

No order is assumed on the blocks in the output file.

If the deployment.cfg exists, under all cases a deployment.cfg.bak
file will be created as a backup.

=head1  COMMAND-LINE OPTIONS

=over

=item   -h, --help  
This documentation

=item   -a
When set, the progam will abort with a non-zero return
value if a convlict exists betweeen the deploy.cfg and the existing
deployment.cfg files

=back

=head1  AUTHORS

Thomas Brettin
Shane Canon
Dan Olson

