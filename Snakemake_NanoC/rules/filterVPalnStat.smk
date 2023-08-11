rule filterVPalnStat:
	input:
		"results/{sample}_VPaln_sortedOnlyMapped_MAQgteq50.sam"
	output:
		"results/{sample}_VPaln_sortedOnlyMapped_MAQgteq50_stat.tab"
	log:
		out="logs/fvpAlnstat/{sample}.out.log",
		err="logs/fvpAlnstat/{sample}.err.log"
	shell:
		"samtools flagstat {input} > {output}"