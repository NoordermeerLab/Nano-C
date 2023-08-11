rule extractGreadCoorU:
	input:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f.tab"
	output:
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_uniq.bed"
	log:
		out="logs/extGreadcor/{sample}.out.log",
		err="logs/extGreadcor/{sample}.err.log"
	shell:
		"scripts/GenomicReadCoor_uniq.sh {input} {output}"

