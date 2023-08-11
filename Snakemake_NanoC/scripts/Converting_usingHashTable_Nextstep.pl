#!/usr/bin/perl -w
use strict;
use List::MoreUtils qw(uniq);


print "\n\n\tStarting the Converting BEDTool output Second step\n\n";
my %hash;


my $InputF = $ARGV[0];
chomp($InputF);
open F1, "<", $InputF or die;

while(my $line = <F1>)
{
	chomp($line);
	my @row = split '\t', $line;
	my $len = @row;

	if($len == 2)
	{
		$hash{$row[0]} = $row[1];
	}
	if($len ==3)
	{
		my $rest = $row[1]."\t".$row[2];
		$hash{$row[0]} = $rest;
	}
}


print "\nHash Table Done\n";
close F1;

my $InputS = $ARGV[1];
chomp($InputS);
open F2, "<", $InputS or die;

my $output = $ARGV[2];
chomp($output);
open O1, ">", $output or die;

while(my $file = <F2>)
{
	chomp($file);
	my @spl = split '\t', $file;
	my $readEnd = $spl[12] + $spl[15];
	my $id = $spl[11].":".$spl[12].":".$readEnd.":".$spl[9];
	#print "$id\n"; <>;
	if(exists $hash{$id})
	{
		print "$file\t-->\t$hash{$id}\n"; #<>;
		print O1 "$file\t-->\t$hash{$id}\n";
	}
}

close F2;
close O1;