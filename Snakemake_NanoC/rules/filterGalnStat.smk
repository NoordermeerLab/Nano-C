rule filterGalnStat:
	input:
		"results/{sample}_Galn_sortedOnlyMapped_MAQgteq25.sam"
	output:
		"results/{sample}_Galn_sortedOnlyMapped_MAQgteq25_stat.tab"
	log:
		out="logs/fGAlnstat/{sample}.out.log",
		err="logs/fGAlnstat/{sample}.err.log"
	shell:
		"samtools flagstat {input} > {output}"