#!/usr/bin/perl -w
use strict;
use diagnostics;
#use List::MoreUtils qw( uniq );
#use List::MoreUtils qw( minmax );

my @allids=();

print "Enter the Inputfile name:\n";
my $InputF = <STDIN>;
chomp $InputF;

my $prefix = $InputF;
$prefix =~ s/\.interact//;
$prefix =~ s/..\///;
my $OutputF = $prefix . "_Final.interact";

open F1, "<", $InputF or die;

while(my $line =<F1>)
{
	chomp($line);
	my @sql = split '\t', $line;
	chomp($sql[3]);
	push(@allids, $sql[3]);
}
close F1;

my %hash;
++$hash{$_} for @allids;
print "$_\t>$hash{$_}\n"
    for sort {$a <=> $b} keys %hash;

open O1, ">", $OutputF or die;


open F1, "<", $InputF or die;
while(my $line =<F1>)
{
	chomp($line);
	my @spl = split '\t', $line;
	chomp($spl[3]);
	if(exists $hash{$spl[3]})
	{

		my $temp=$hash{$spl[3]};
		#print "\n\n\n$temp\n\n"; <>;
		print "$spl[0]\t$spl[1]\t$spl[2]\t$spl[3]\t$spl[4]\t$spl[5]\t$temp\t$spl[7]\t$spl[8]\t$spl[9]\t$spl[10]\t$spl[11]\t$spl[12]\t$spl[13]\t$spl[14]\t$spl[15]\t$spl[16]\t$spl[17]\n";
		print O1 "$spl[0]\t$spl[1]\t$spl[2]\t$spl[3]\t$spl[4]\t$spl[5]\t$temp\t$spl[7]\t$spl[8]\t$spl[9]\t$spl[10]\t$spl[11]\t$spl[12]\t$spl[13]\t$spl[14]\t$spl[15]\t$spl[16]\t$spl[17]\n"; #<>;
	}
}


close F1;
close O1;
