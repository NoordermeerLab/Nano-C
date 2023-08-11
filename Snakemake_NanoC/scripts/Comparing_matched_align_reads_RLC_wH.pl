#!/usr/bin/perl -w
use strict;
use List::MoreUtils qw(uniq);


print "\n\n\tStarting the Comparision between Viewpoint alignment and Genome alignment\n\n";
my %hash;
my $Vreadcount=0;

my $InputF = $ARGV[0];
chomp($InputF);
open F1, "<", $InputF or die;

while(my $viewpoint=<F1>)
{
	chomp($viewpoint);
	my @spl=split '\t', $viewpoint;
	if($spl[0] !~ m/^@/)
	{
		if(($spl[1] == 0) || ($spl[1] == 16))
		{
			$Vreadcount++;
			my @vciger=();
			my @vop=();
			my @vval=();
			@vciger = $spl[5] =~ /\d+|\D+/g;
			for(my $i=0;$i<@vciger;$i=$i+2)
			{
					push(@vop, $vciger[$i+1]);
					push(@vval, $vciger[$i]);
			}
			my @unique_vop = uniq @vop;
			my $vreadlen=0;
			for(my $a=0; $a<@unique_vop; $a++)
			{
				my $vsum =0;
				for(my $b=0;$b<@vop;$b++)
				{
					if($vop[$b] eq $unique_vop[$a])
					{
						$vsum = $vsum + $vval[$b]
					}
				}
				if($unique_vop[$a] eq 'M' || $unique_vop[$a] eq 'D')
				{
					$vreadlen = $vreadlen + $vsum;
				}
			}
			my $Vallfields = "$spl[1]".";"."$spl[2]".";"."$spl[3]".";"."$spl[4]".";"."$spl[5]".";"."$vreadlen";
			$hash{$spl[0]} = $Vallfields;
		}
	}
}
print "\n\tViewpoint mapping SAM file Hash done\n";
close F1;
print "\n\t Total number of Viewpoint primary mapping reads :\t$Vreadcount\n\n"; #<>;



my $InputS = $ARGV[1];
chomp($InputS);
open F2, "<", $InputS or die;


my $output = $ARGV[2];
chomp($output);
open O1, ">", $output or die;

my $Greadcount=0; 	my @hold=(); 	my $id; 	my @unique_hold=();

while(my $genome=<F2>)
{
	chomp($genome);
	my @sql=split '\t', $genome;
	if($sql[0] !~ m/^@/)
	{
		$Greadcount++;
		if($Greadcount == 1)
		{
			$id = $sql[0];
		}
		my @gciger=(); my @gop=(); my @gval=(); my @temp=(); my $GreadPos=0; 	my @flag=();
		$GreadPos = $sql[3] - 1;
		@gciger = $sql[5] =~ /\d+|\D+/g;
		for(my $i=0;$i<@gciger;$i=$i+2)
		{
			push(@gop, $gciger[$i+1]);
			push(@gval, $gciger[$i]);
		}
		my @unique_gop = uniq @gop;
		my $greadlen=0;
		for(my $a=0; $a<@unique_gop; $a++)
		{
			my $gsum =0;
			for(my $b=0;$b<@gop;$b++)
			{
				if($gop[$b] eq $unique_gop[$a])
				{
					$gsum = $gsum + $gval[$b]
				}
			}
			if($unique_gop[$a] eq 'M' || $unique_gop[$a] eq 'D')
			{
				$greadlen = $greadlen + $gsum;
			}
		}
		if(exists $hash{$sql[0]})
		{
			@temp = split /;/, $hash{$sql[0]};
			print O1 "$sql[0]\t$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[4]\t$temp[5]\tSeq\t-->\t$sql[0]\t$sql[1]\t$sql[2]\t$GreadPos\t$sql[4]\t$sql[5]\t$greadlen\tSeq\t|\n";
		}
	}
}
close F2;
close O1;
print "\n\t Total number of Genome mapping Reads :\t$Greadcount\n\n"; #<>;

### END of SCRIPT ###
