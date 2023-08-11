rule InteractGen:
	input:
		"input/chrom.sizes",
		"results/{sample}_Comparing_merge_U2Tcon_aln_VP-Q50_and_WG-Q25_reads_RLC_wH_f_GenomicReadCoor_US_withRestrictionFrags_n_OL_sorted_2_Finaloutput.tab",
		"input/VPcoor.bg"

	output:
		"results/{sample}_{viewpoint}.interact"
	log:
		out="logs/interact/{sample}_{viewpoint}.out.log",
		err="logs/interact/{sample}_{viewpoint}.err.log"
	shell:
		"perl scripts/For_interact_f_corrected_withNLA_wH_fromLaptop_forNanoCdata_withSTDIN.pl {input} {output}  > {log.out} 2> {log.err}"
