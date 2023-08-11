#!/usr/bin/perl
use warnings;
use strict;


print "\n Splitting Viewpoint coordinale file \n";

my $InputFile = $ARGV[0];
chomp($InputFile);

my $Output = $ARGV[1];
open O1, '>', $Output;

open F1, "<", $InputFile or die;
while(my $viewpoint = <F1>)
{
	chomp($viewpoint);
	print O1 "$viewpoint\n";
}
close L1;
