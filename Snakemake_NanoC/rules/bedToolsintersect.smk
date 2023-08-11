rule bedToolsintersect:
	input:
		a="results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_uniq_sort.bed",
		b="input/mm10_CATG_fragments_F_sorted.bg"
	output:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_US_withRestrictionFrags_n_OL_sorted.bed"
	log:
		out="logs/extGreadcor/{sample}.out.log",
		err="logs/extGreadcor/{sample}.err.log"
	shell:
		"bedtools intersect -a {input.a} -b {input.b} -wo -sorted > {output}"

