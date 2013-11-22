package Bio::KBase::Workflow::KBW;


use strict;
use File::Spec;
use File::Find;

sub install_path
{
   return File::Spec->catpath((File::Spec->splitpath(__FILE__))[0,1], '');
}

sub list_workflows
{
   my $wfd = install_path();
   find (sub {print $File::Find::dir, "/", $_, "\n" unless -d;}, $wfd);
}
