rule comparing:
	input:
		"results/{sample}_VPaln_sortedOnlyMapped_MAQgteq50.sam",
		"results/{sample}_Galn_sortedOnlyMapped_MAQgteq25.sam"

	output:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f.tab"
	log:
		out="logs/comparing/{sample}.out.log",
		err="logs/comparing/{sample}.err.log"
	shell:
		"perl scripts/Comparing_matched_align_reads_RLC_wH.pl {input} {output}  > {log.out} 2> {log.err}"
