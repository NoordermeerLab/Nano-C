rule convertingBedtoolOut:
	input:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_US_withRestrictionFrags_n_OL_sorted.bed"

	output:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_US_withRestrictionFrags_n_OL_sorted_2.bed"
	log:
		out="logs/convertingBED/{sample}.out.log",
		err="logs/convertingBED/{sample}.err.log"
	shell:
		"perl scripts/Converting_usingHashTable.pl {input} {output} > {log.out} 2> {log.err}"
