#!/usr/bin/perl
use warnings;
use strict;
use List::MoreUtils qw( uniq );
use List::MoreUtils qw( minmax );

print "\n\nEnter the Chromosome size file\n";
my %chrlenHash;

my $InputCS = $ARGV[0];
chomp($InputCS);
open L1, "<", $InputCS or die;

while(my $chromlength = <L1>)
{
	chomp($chromlength);
	my @sep = split '\t', $chromlength;
	chomp($sep[0]); 
	chomp($sep[1]);
	$chrlenHash{$sep[0]} = $sep[1];
}
close L1;

print "\n\nEnter the Comparing file\n";
my $InputF = $ARGV[1];
chomp($InputF);
open F1, "<", $InputF or die;
my @line = <F1>;
close F1;

print "\n\nEnter the Viewpoint File\n";
my @filevpname=(); my @fileCHR=(); my @fileviewpointCoor=();

my $InputVP = $ARGV[2];
chomp($InputVP);
open V1, "<", $InputVP or die;

while(my $vpfile = <V1>)
{
	chomp($vpfile);
	my @eachvp = split '\t', $vpfile;
	chomp($eachvp[0]);
	chomp($eachvp[1]);
	my @splvp = split ':', $eachvp[1];
	chomp($splvp[0]);
	push(@filevpname, $eachvp[0]);
	push(@fileviewpointCoor, $eachvp[1]);
	push(@fileCHR, $splvp[0]);
}
close V1;

print "\n\nStarting of New For-Loop\n";


for(my $m=0; $m<@filevpname; $m++)
{
	chomp($fileCHR[$m]);
	my $CHR = $fileCHR[$m];

	print "The Chromosome Length:\n";
	my $chr_len =0;
	if(exists $chrlenHash{$CHR})
	{
		$chr_len = $chrlenHash{$CHR};
		chomp($chr_len);
	}
	print "$chr_len\n\n"; #<>;


	my $run = "LC";


	print "Enter the Viewpoint coordinate:\n";
	chomp($fileviewpointCoor[$m]);
	my $viewpointCoor = $fileviewpointCoor[$m];

	print "Enter the Viewpoint name:\n";
	chomp($filevpname[$m]);
	my $vpname = $filevpname[$m];
	print "\n$CHR\t$viewpointCoor\t$vpname\n";

	my %stuff;
	my $flag=0;
	my $tempNlaCount=0;

	for(my $f=0; $f<@line; $f++)
	{
		my $strand;	my $tempNla;

		chomp($line[$f]);
		my @spl=split '\t', $line[$f];
		my $lenthOFtheLine=@spl;

		chomp($spl[0]); chomp($spl[2]);

		my $viewpoint=$spl[2];
		if($viewpoint eq $viewpointCoor)																				#checking only viewpoint matched reads
		{
			if($spl[10] == 0 || $spl[10] == 2048)
			{
				$strand= '+';
			}
			if($spl[10] == 16 || $spl[10] == 2064)
			{
				$strand= '-';
			}
			my $endpos= $spl[12] + $spl[15];
			if($lenthOFtheLine == 20)
			{
				$tempNla = $spl[19];
			}
			if($lenthOFtheLine == 21)
			{
				$tempNla = $spl[19]."-".$spl[20];
				$tempNlaCount++;
			}
			my $genomePortion = $spl[9]."\t".$strand."\t".$spl[11]."\t".$spl[12]."\t".$endpos."\t".$tempNla;
			push( @{ $stuff{$spl[0]} }, $genomePortion );													#Generating Array of Hash for specific viewpoint
			$flag++;
		}
	}

	print "\n\n\n\tChromosome $CHR Array of Hash Done\n\tTotal No. of reads to be processed in $CHR is : $flag\n\tNumber of TempNLA count :$tempNlaCount\n";


	print "\nEnter the output file name\n";
	print "\n$ARGV[3]\n";

	my $Output = $ARGV[3];
	chomp($Output);
	open(O1, ">", $Output) or die;

	my @VP=split ':', $viewpointCoor;
	chomp($VP[0]); chomp($VP[1]);																			#ViewPoint chromosome & coordinates
	my @COOR=split '-', $VP[1];
	chomp($COOR[0]); chomp($COOR[1]); 																		#ViewPoint start & stop

	foreach my $key (sort keys %stuff)
	{
		my $count = @{ $stuff{$key} };
		print "No. of Genomic reads per Viewpoint readId:\t$count\n"; 
		print "VP readId: $key\n";																					#Viewpoint read_ID
		my @tempstrand=(); my @tempchr=(); my @tempstart=(); my @tempend=(); my @tempres=();
		for(my $i=0; $i<$count;$i++)
		{
			print "$stuff{$key}[$i]\n";
			my @hashvalue = split '\t', $stuff{$key}[$i];
			push(@tempstrand, $hashvalue[1]);
			push(@tempchr, $hashvalue[2]);
			push(@tempstart, $hashvalue[3]);
			push(@tempend, $hashvalue[4]);
			push(@tempres, $hashvalue[5]);
		}
		print "@tempstrand\n@tempchr\n@tempstart\n@tempend\n@tempres\n";
		(my $startMin, my $startMax) = minmax @tempstart;
		(my $endMin, my $endMax) = minmax @tempend;
		my $Noint=$count - 1;
		my $SameChrcount=0;
		my $check=0;

		my $trgetChrom; my $targetStart; my $targetEnd; my $targetStrand; my $targetNla; 
		for(my $x=0;$x<$count;$x++)
		{
			if($tempchr[$x] eq $VP[0])
			{
				$SameChrcount++;
				if($COOR[0] <= $tempstart[$x] && $tempstart[$x] <= $COOR[1])
				{
					$trgetChrom=$tempchr[$x];
					$targetStart=$tempstart[$x];
					$targetEnd=$tempend[$x];
					$targetStrand=$tempstrand[$x];
					$targetNla=$tempres[$x];
					$check++;
				}
				elsif($COOR[0] <= $tempend[$x] && $tempend[$x] <= $COOR[1])
				{
					$trgetChrom=$tempchr[$x];
					$targetStart=$tempstart[$x];
					$targetEnd=$tempend[$x];
					$targetStrand=$tempstrand[$x];
					$targetNla=$tempres[$x];
					$check++;
				}
				elsif($tempstart[$x] <= $COOR[0] && $COOR[0] <= $tempend[$x])
				{
					$trgetChrom=$tempchr[$x];
					$targetStart=$tempstart[$x];
					$targetEnd=$tempend[$x];
					$targetStrand=$tempstrand[$x];
					$targetNla=$tempres[$x];
					$check++;
				}
				elsif($tempstart[$x] <= $COOR[1] && $COOR[1] <= $tempend[$x])
				{
					$trgetChrom=$tempchr[$x];
					$targetStart=$tempstart[$x];
					$targetEnd=$tempend[$x];
					$targetStrand=$tempstrand[$x];
					$targetNla=$tempres[$x];
					$check++;
				}
			}
		}
		my $SameChrmIntCount = $SameChrcount -1;
		print "No. of Genomic read found inside the Viewpoint : $check\nNo. of same chromosome: $SameChrmIntCount\n"; 	#No. of different chromosome: $DiffChrcount\n";

		my $sourceChrom; my $sourceStart; my $sourceEnd; my $sourceStrand; my $sourceNla; my $chrom; my $chromStart; my $chromEnd;
		my $Hold_sourceStart; my $Hold_sourceEnd; my $Hold_targetStart; my $Hold_targetEnd; 

		if($check > 0 && $Noint > 0) #&& $Noint > 0
		{
			my @set = ('0' ..'9', 'A' .. 'F');							#|
			my $str = join '' => map $set[rand @set], 1 .. 6;			#| Generating random color
			my $color='#'.$str;											#|
			my $WVP = 1;
			for(my $x=0;$x<$count;$x++)
			{
				if($tempstart[$x] != $targetStart)
				{
					$sourceChrom= $tempchr[$x];
					$sourceStart= $tempstart[$x];
					$sourceEnd= $tempend[$x];
					$sourceStrand= $tempstrand[$x];
					$sourceNla=$tempres[$x];
					if($tempstart[$x] < $targetStart)
					{
						$chrom=$CHR;
						$chromStart= $tempstart[$x];
						$chromEnd= $targetEnd;
					}
					if($tempstart[$x] > $targetStart)
					{
						$chrom=$CHR;
						$chromStart= $targetStart;
						$chromEnd= $tempend[$x];
					}
					if($chromEnd > $chr_len)					#|
					{											#|checking for the max chromosome length
						$chromEnd = $chr_len;					#|
					}											#|
					$Hold_sourceStart=$sourceStart; $Hold_sourceEnd=$sourceEnd;			#|
					$Hold_targetStart=$targetStart; $Hold_targetEnd=$targetEnd;			#|
					my @Rangtemp=(); my @sortedRangetemp=();							#|
					my @SNLA=(); my @snlaLeft=(); my @snlaRight=();						#|
					@SNLA = split '-', $sourceNla;										#|
					chomp($SNLA[0]); chomp($SNLA[1]);									#|
					if($SNLA[1] ne "")													#|
					{																	#|
						@snlaLeft = split ':', $SNLA[0];								#|
						@snlaRight = split ':', $SNLA[1];								#|
						$sourceStart = $snlaLeft[2];									#|
						$sourceEnd = $snlaRight[3];										#|
						push(@Rangtemp, $sourceStart);									#|
						push(@Rangtemp, $sourceEnd);									#|
					}																	#|
					else																#|
					{																	#|
						@snlaLeft = split ':', $SNLA[0];								#|
						$sourceStart = $snlaLeft[2];									#|
						$sourceEnd = $snlaLeft[3];										#|
						push(@Rangtemp, $sourceStart);									#|
						push(@Rangtemp, $sourceEnd);									#|
					}																	#|#|NLA fragment replacement segment
					my @TNLA=(); my @tnlaLeft=(); my @tnlaRight=();
					@TNLA = split '-', $targetNla;										#|
					chomp($TNLA[0]); chomp($TNLA[1]);									#|
					if($TNLA[1] ne "")													#|
					{																	#|
						@tnlaLeft = split ':', $TNLA[0];								#|
						@tnlaRight = split ':', $TNLA[1];								#|
						$targetStart = $tnlaLeft[2];									#|
						$targetEnd = $tnlaRight[3];										#|
						push(@Rangtemp, $targetStart);									#|
						push(@Rangtemp, $targetEnd);									#|
					}																	#|
					else																#|
					{																	#|
						@tnlaLeft = split ':', $TNLA[0];								#|
						$targetStart = $tnlaLeft[2];									#|
						$targetEnd = $tnlaLeft[3];										#|
						push(@Rangtemp, $targetStart);									#|
						push(@Rangtemp, $targetEnd);									#|
					}																	#|
					@sortedRangetemp = sort @Rangtemp;									#|
					my $countRange = @sortedRangetemp;									#|
					$chromStart = $sortedRangetemp[0];									#|
					$chromEnd = $sortedRangetemp[$countRange - 1];						#|

					if($chromEnd > $chr_len)					#|
					{											#|
						$chromEnd = $chr_len;					#|checking for the max chromosome length AGAIN for NLA segment
					}											#|
					if($chromStart > $chr_len)					#|
					{											#|
						$chromStart = 0;						#|checking for the min chromosome length AGAIN for NLA segment
					}											#|
					if($chromStart > $chromEnd)					#|
					{											#|
						my $store = $chromStart;				#|
						$chromStart = $chromEnd;				#|checking for the min and max chromosome length AGAIN for NLA segment
						$chromEnd = $store;						#|
					}											#|
					my $repl_targetStart = $COOR[0]; my $repl_targetEnd = $COOR[1];
					if($sourceChrom ne $CHR)					#|
					{											#|
						$chromStart=$repl_targetStart;			#|Changing Inter chromosomal interaction area
						$chromEnd=$repl_targetEnd;				#|
					}											#|

					#print "$chrom\t$chromStart\t$chromEnd\t$key\t100\t100\t$Noint\t$color\t$sourceChrom\t$sourceStart\t$sourceEnd\t$WVP\t$sourceStrand\t$trgetChrom\t$repl_targetStart\t$repl_targetEnd\t$run\t$targetStrand\n";
					print O1 "$chrom\t$chromStart\t$chromEnd\t$key\t100\t100\t$Noint\t$color\t$sourceChrom\t$sourceStart\t$sourceEnd\t$WVP\t$sourceStrand\t$trgetChrom\t$repl_targetStart\t$repl_targetEnd\t$run\t$targetStrand\n";
					$sourceStart = $Hold_sourceStart; $sourceEnd = $Hold_sourceEnd; $targetStart = $Hold_targetStart; $targetEnd = $Hold_targetEnd;
				}
			}
		}

	#############################################################################################################################################

		#print "No of same chromosome: $check\n";
		if($check == 0 && $Noint > 0)
		{
			my $color='#000000';										#|Generating Black color
			my $WVP = 0;
			for(my $y=0;$y<$count;$y++)
			{
				$sourceChrom= $tempchr[$y];
				$sourceStart= $tempstart[$y];
				$sourceEnd= $tempend[$y];
				$sourceStrand= $tempstrand[$y];
				$sourceNla=$tempres[$y];
				my @SNLA=(); my @snlaLeft=(); my @snlaRight=();
				my @Rangtemp = (); my @sortedRangetemp=();
				if($sourceChrom eq $CHR)
				{
					$chrom = $sourceChrom;
					if($sourceStart < $COOR[0])
					{
						$chromStart = $sourceStart;
					}
					if($sourceEnd > $COOR[1])
					{
						$chromEnd = $sourceEnd;
					}
					@SNLA = split '-', $sourceNla;
					chomp($SNLA[0]); chomp($SNLA[1]);
					if($SNLA[1] ne "")
					{
						@snlaLeft = split ':', $SNLA[0];
						@snlaRight = split ':', $SNLA[1];
						$sourceStart = $snlaLeft[2];
						$sourceEnd = $snlaRight[3];
						push(@Rangtemp, $sourceStart);
						push(@Rangtemp, $sourceEnd);
						push(@Rangtemp, $COOR[0]);
						push(@Rangtemp, $COOR[1]);
					}
					else
					{
						@snlaLeft = split ':', $SNLA[0];
						$sourceStart = $snlaLeft[2];
						$sourceEnd = $snlaLeft[3];
						push(@Rangtemp, $sourceStart);
						push(@Rangtemp, $sourceEnd);
						push(@Rangtemp, $COOR[0]);
						push(@Rangtemp, $COOR[1]);
					}
					@sortedRangetemp = sort @Rangtemp;
					my $countRange = @sortedRangetemp;
					$chromStart = $sortedRangetemp[0];
					$chromEnd = $sortedRangetemp[$countRange - 1];
					if($chromEnd > $chr_len)					#|
					{											#|
						$chromEnd = $chr_len;					#|checking for the max chromosome length AGAIN for NLA segment
					}											#|
					#if($chromStart > $chr_len)					#|
					if($chromStart > $chr_len)					#|
					{											#|
						$chromStart = 0;						#|checking for the min chromosome length AGAIN for NLA segment
					}											#|
					if($chromStart > $chromEnd)					#|
					{											#|
						my $store = $chromStart;				#|
						$chromStart = $chromEnd;				#|checking for the min and max chromosome length AGAIN for NLA segment
						$chromEnd = $store;						#|
					}											#|
					$trgetChrom = $VP[0];
					$targetStart = $COOR[0];
					$targetEnd = $COOR[1];
					$targetStrand = '+';
				}
				if($sourceChrom ne $CHR)
				{
					$trgetChrom = $VP[0];
					$targetStart = $COOR[0];
					$targetEnd = $COOR[1];
					$targetStrand = '+';
					$chrom=$CHR;
					$chromStart=$COOR[0];
					$chromEnd=$COOR[1];
					@SNLA = split '-', $sourceNla;
					chomp($SNLA[0]); chomp($SNLA[1]);
					if($SNLA[1] ne "")
					{
						@snlaLeft = split ':', $SNLA[0];
						@snlaRight = split ':', $SNLA[1];
						$sourceStart = $snlaLeft[2];
						$sourceEnd = $snlaRight[3];
					}
					else
					{
						@snlaLeft = split ':', $SNLA[0];
						$sourceStart = $snlaLeft[2];
						$sourceEnd = $snlaLeft[3];
					}
				}
				my $wvp_Noint = $Noint + 1;#										| New addition for non viewpoint containint reads, interaction count |

				#print "$chrom\t$chromStart\t$chromEnd\t$key\t100\t100\t$wvp_Noint\t$color\t$sourceChrom\t$sourceStart\t$sourceEnd\t$WVP\t$sourceStrand\t$trgetChrom\t$targetStart\t$targetEnd\t$run\t$targetStrand\n";
				print O1 "$chrom\t$chromStart\t$chromEnd\t$key\t100\t100\t$wvp_Noint\t$color\t$sourceChrom\t$sourceStart\t$sourceEnd\t$WVP\t$sourceStrand\t$trgetChrom\t$targetStart\t$targetEnd\t$run\t$targetStrand\n";
			}
		}
	}
	%stuff = ();
	close O1;
}


###### END ######

