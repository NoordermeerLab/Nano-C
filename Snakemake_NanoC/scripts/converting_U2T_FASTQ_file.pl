#!/usr/bin/perl -w
use strict;
use File::Path;


print "\n\tStarting converting the FASTQ file:\n";
my $InputF = $ARGV[0];
chomp $InputF;
open F1, "<", $InputF or die;

my $output = $ARGV[1];
chomp($output);
open O1, ">", $output or die;


my @file=<F1>;
my $a=1;
for(my $i=0;$i<@file;$i++)
{
	chomp($file[$i]);
	if($i == $a)
	{
		$file[$i] =~ s/U/T/ig;
		print O1 "$file[$i]\n";
		$a=$a+4;
	}
	else
	{
		print O1 "$file[$i]\n";
	}
}
close F1;
close O1;
