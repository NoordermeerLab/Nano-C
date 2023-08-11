rule convertingBedtoolOutStep2:
	input:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_US_withRestrictionFrags_n_OL_sorted_2.bed",
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f.tab"

	output:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_US_withRestrictionFrags_n_OL_sorted_2_Finaloutput.tab"
	log:
		out="logs/convertingBED2/{sample}.out.log",
		err="logs/convertingBED2/{sample}.err.log"
	shell:
		"perl scripts/Converting_usingHashTable_Nextstep.pl {input} {output}  > {log.out} 2> {log.err}"
