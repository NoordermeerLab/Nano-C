#!/usr/bin/perl -w
use warnings;
use strict;


print "Enter the Inputfile name:\n";
my $InputF = $ARGV[0];;
chomp($InputF);

print "\nEnter the output file name\n";
my $Output = $ARGV[1];
chomp($Output);
open OUT, ">", $Output or die;

my $xxx=0;
my @probid=();
my $uniqId;
my $lineinfo;
my %stuff;

open F1, "<", $InputF or die;
while(my $line = <F1>)
{
	chomp($line);
	if($line =~/^chr/)
	{
		my @column = split '\t', $line;

		if($column[8] eq $column[13]) 												#Checking for same chromosome for viewpoint containing reads |
		{
			if($column[9] > $column[14] && $column[9] < $column[15]) 				#Filtering out viewpoint containing reads;
			{
				print "$column[3]:\tViewpoint Overlapped\n"; #<>;
				push(@probid, $column[3]);
			}
			elsif($column[10] > $column[14] && $column[10] < $column[15]) 			#Filtering out viewpoint containing reads;
			{
				print "$column[3]:\tViewpoint Overlapped\n"; #<>;
				push(@probid, $column[3]);
			}
			else 																	#Nonviewpoint containing reads Array of hash generation;
			{
				$uniqId = $column[3];
				$lineinfo = $line;
				push( @{ $stuff{$uniqId} }, $lineinfo );
			}
		}
		else 																		#Nonviewpoint containing reads Array of hash generation;
		{
			$uniqId = $column[3];
			$lineinfo = $line;
			push( @{ $stuff{$uniqId} }, $lineinfo );
		}
	}
	else
	{
		$xxx ++;
		
		if($xxx > 2)
		{
			my @Hold=();
			foreach my $key (sort keys %stuff)
			{
				my $count = @{ $stuff{$key} };# 											Counting No. of hash value of each hash key;
				print "No. of Genomic reads per Viewpoint readId:\t$count\n"; 
				print "VP readId: $key\n"; #<>;
				if($count == 1)# 															printing out the single tone interaction;
				{
					for(my $i=0; $i<$count;$i++)
					{
						print "$stuff{$key}[$i]\n"; #<>;
						print OUT "$stuff{$key}[$i]\n";
					}
				}
				if($count > 1)# 															Creating all multicontact interactions in an Array to check overlap;
				{		
					for(my $i=0; $i<$count;$i++)
					{
						print "$stuff{$key}[$i]\n"; #<>;
						push(@Hold, $stuff{$key}[$i]);
					}
				}

				print "\nChecking inside the New filtering section\n"; 

				my $last; my @cols=(); my @Store=(); my $flag=0; my @reStore=();
				for(my $x=0; $x<@Hold; $x++)
				{
					chomp($Hold[$x]);
					@cols = split '\t', $Hold[$x];
					my $key = $cols[8];
					my $start = $cols[9];
					my $end = $cols[10];
					my $tempStore = $cols[0].":".$cols[1].":".$cols[2].":".$cols[3].":".$cols[4].":".$cols[5].":".$cols[6].":".$cols[7].":".$cols[11].":".$cols[12].":".$cols[13].":".$cols[14].":".$cols[15].":".$cols[16].":".$cols[17];
					push(@Store, $tempStore);
					if ($last) 
					{
						if ($last->[0] ne $key || $last->[2] < $start) 
						{
							print "1st IF:\n";
							my @reStore = split ':', $Store[$flag];
							if(@$last[0] eq $reStore[0] && @$last[1] != $reStore[1] && @$last[1] != $reStore[2] && @$last[2] != $reStore[1] && @$last[2] != $reStore[2])
							{
								if(@$last[2] < $reStore[12])
								{
									$reStore[1] = @$last[1];
								}
								if(@$last[1] > $reStore[13])
								{
									$reStore[2] = @$last[2];
								}
								print "$reStore[0]\t$reStore[1]\t$reStore[2]\t$reStore[3]\t$reStore[4]\t$reStore[5]\t$reStore[6]\t$reStore[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$reStore[8]\t$reStore[9]\t$reStore[10]\t$reStore[11]\t$reStore[12]\t$reStore[13]\t$reStore[14]\n"; #<>;
								print OUT "$reStore[0]\t$reStore[1]\t$reStore[2]\t$reStore[3]\t$reStore[4]\t$reStore[5]\t$reStore[6]\t$reStore[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$reStore[8]\t$reStore[9]\t$reStore[10]\t$reStore[11]\t$reStore[12]\t$reStore[13]\t$reStore[14]\n"; 
							}
							elsif(@$last[0] ne $reStore[0])
							{
								print "$reStore[0]\t$reStore[1]\t$reStore[2]\t$reStore[3]\t$reStore[4]\t$reStore[5]\t$reStore[6]\t$reStore[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$reStore[8]\t$reStore[9]\t$reStore[10]\t$reStore[11]\t$reStore[12]\t$reStore[13]\t$reStore[14]\n"; #<>;
								print OUT "$reStore[0]\t$reStore[1]\t$reStore[2]\t$reStore[3]\t$reStore[4]\t$reStore[5]\t$reStore[6]\t$reStore[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$reStore[8]\t$reStore[9]\t$reStore[10]\t$reStore[11]\t$reStore[12]\t$reStore[13]\t$reStore[14]\n";
							}
							else
							{
								if(@$last[1] < $reStore[11])
								{
									$reStore[1] = @$last[1];
								}
								if(@$last[2] > $reStore[12])
								{
									$reStore[2] = @$last[2];
								}
								print "$reStore[0]\t$reStore[1]\t$reStore[2]\t$reStore[3]\t$reStore[4]\t$reStore[5]\t$reStore[6]\t$reStore[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$reStore[8]\t$reStore[9]\t$reStore[10]\t$reStore[11]\t$reStore[12]\t$reStore[13]\t$reStore[14]\n"; #<>;
								print OUT "$reStore[0]\t$reStore[1]\t$reStore[2]\t$reStore[3]\t$reStore[4]\t$reStore[5]\t$reStore[6]\t$reStore[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$reStore[8]\t$reStore[9]\t$reStore[10]\t$reStore[11]\t$reStore[12]\t$reStore[13]\t$reStore[14]\n"; 
							}
							$flag++;
						}
						else
						{
						$start = $last->[1];
						$end   = $last->[2] if $end < $last->[2];
						}
					}
					$last = [$key, ,$start, $end];
				}
				if($count>1)
				{
					print "2nd IF:\n";
					if(@$last[0] eq $cols[0] && @$last[1] != $cols[1] && @$last[1] != $cols[2] && @$last[2] != $cols[1] && @$last[2] != $cols[2])
					{
						if(@$last[2] < $cols[14])
						{
							$cols[1] = @$last[1];
						}
						if(@$last[1] > $cols[15])
						{
							$cols[2] = @$last[2];
						}
					print "$cols[0]\t$cols[1]\t$cols[2]\t$cols[3]\t$cols[4]\t$cols[5]\t$cols[6]\t$cols[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$cols[11]\t$cols[12]\t$cols[13]\t$cols[14]\t$cols[15]\t$cols[16]\t$cols[17]\n"; #<>;
					print OUT "$cols[0]\t$cols[1]\t$cols[2]\t$cols[3]\t$cols[4]\t$cols[5]\t$cols[6]\t$cols[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$cols[11]\t$cols[12]\t$cols[13]\t$cols[14]\t$cols[15]\t$cols[16]\t$cols[17]\n";
					}
					elsif(@$last[0] ne $cols[0])
					{
						print "$cols[0]\t$cols[1]\t$cols[2]\t$cols[3]\t$cols[4]\t$cols[5]\t$cols[6]\t$cols[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$cols[11]\t$cols[12]\t$cols[13]\t$cols[14]\t$cols[15]\t$cols[16]\t$cols[17]\n"; #<>;
						print OUT "$cols[0]\t$cols[1]\t$cols[2]\t$cols[3]\t$cols[4]\t$cols[5]\t$cols[6]\t$cols[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$cols[11]\t$cols[12]\t$cols[13]\t$cols[14]\t$cols[15]\t$cols[16]\t$cols[17]\n"; 
					}
					else
					{
						if(@$last[1] < $cols[14])
						{
							$cols[1] = @$last[1];
						}
						if(@$last[2] > $cols[15])
						{
							$cols[2] = @$last[2];
						}
						print "$cols[0]\t$cols[1]\t$cols[2]\t$cols[3]\t$cols[4]\t$cols[5]\t$cols[6]\t$cols[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$cols[11]\t$cols[12]\t$cols[13]\t$cols[14]\t$cols[15]\t$cols[16]\t$cols[17]\n"; #<>;
						print OUT "$cols[0]\t$cols[1]\t$cols[2]\t$cols[3]\t$cols[4]\t$cols[5]\t$cols[6]\t$cols[7]\t@$last[0]\t@$last[1]\t@$last[2]\t$cols[11]\t$cols[12]\t$cols[13]\t$cols[14]\t$cols[15]\t$cols[16]\t$cols[17]\n"; 
					}
				}
				@Hold=();
			}
			@probid=();
			%stuff = ();
			print OUT "$line\n";
		}
		else
		{
			print OUT "$line\n";
		}
	}
}


close F1;
close OUT;
#---END of script---#

