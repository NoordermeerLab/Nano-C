#!/usr/bin/perl -w
use strict;

print "\n\n\tStarting the Converting BEDTool output\n\n";
my %stuff; my $left; my $right; 

my $InputF = $ARGV[0];
chomp($InputF);
open F1, "<", $InputF or die;

while(my $line = <F1>)
{
	chomp($line);
	my @row = split '\t', $line;
	
	if($row[10] > 4)
	{
		$left = $row[0].":".$row[1].":".$row[2].":".$row[3];
		$right = $row[7].":".$row[4].":".$row[5].":".$row[6].":".$row[10];
		push( @{ $stuff{$left} }, $right );
	}
}
close F1;

my $output = $ARGV[1];
chomp($output);
open O1, ">", $output or die;

	foreach my $left (sort keys %stuff)
	{
		my $count = @{ $stuff{$left} };
		if($count > 1)
		{
			print "$left\t$stuff{$left}[0]\t$stuff{$left}[-1]\n";
			print O1 "$left\t$stuff{$left}[0]\t$stuff{$left}[-1]\n";
		}
		else
		{
			print "$left\t$stuff{$left}[0]\n";
			print O1 "$left\t$stuff{$left}[0]\n";
		}
	}

close O1;