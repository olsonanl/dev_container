#
# Wrap a perl script for execution in the Windows deployment.
#
# Target looks like the following. Since we're essentially cross compiling we use
# values for TARGET_RUNTIME. We can use 
#
#rem @echo off
#setlocal
#set KB_TOP=c:\progra~1\PATRIC\deployment
#set KB_RUNTIME=c:\progra~1\PATRIC\runtime
#PATH %KB_TOP%\bin;%KB_RUNTIME%\bin;%PATH
#IF DEFINED PERL5LIB (
#        set PERL5LIB=%KB_TOP%\lib;%PERL5LIB% 
#) ELSE (
#        set PERL5LIB=%KB_TOP%\lib
#)
#set
#%KB_RUNTIME%\bin\perl %KB_TOP%\plbin\p3-all-genomes.pl %*
##

use strict;
use File::Spec::Win32;

@ARGV == 2 or die "Usage; $0 source dest\n";

my $src = shift;
my $dst = shift;

#
# Dst must be a .cmd script.
#
if ($dst !~ /\.cmd$/)
{
    $dst = "$dst.cmd";
}

my $top = $ENV{KB_OVERRIDE_TOP} // $ENV{KB_TOP};
my $runtime = $ENV{KB_OVERRIDE_RUNTIME} // $ENV{KB_RUNTIME};
my $perl_path = $ENV{KB_OVERRIDE_PERL_PATH} // $ENV{KB_PERL_PATH};

open(DST, ">", $dst) or die "Cannot write $dst: $!";

my $topc = File::Spec::Win32->canonpath($top);
my $runtimec = File::Spec::Win32->canonpath($runtime);
my $srcc = File::Spec::Win32->canonpath($src);

print DST <<END;
\@echo off
setlocal
set KB_TOP=$topc
set KB_RUNTIME=$runtimec
PATH \%KB_TOP\%\\bin;\%KB_RUNTIME\%\\bin;\%PATH\%
IF DEFINED PERL5LIB (
        set PERL5LIB=\%KB_TOP\%\\lib;\%PERL5LIB\% 
) ELSE (
        set PERL5LIB=\%KB_TOP\%\\lib
)
END

for my $var (split(/\s+/, $ENV{WRAP_VARIABLES}))
{
    my $val = $ENV{$var};
    if ($val ne "")
    {
	print DST "set $var=$val\n";
    }
}

for my $var (split(/\s+/, $ENV{PATH_ADDITIONS}))
{
    my $varc = File::Spec::Win32->canonpath($var);
    print DST "PATH $varc;\%PATH\%\n";
}

print DST "\%KB_RUNTIME\%\\bin\\perl $srcc \%*\n";
close(DST);

