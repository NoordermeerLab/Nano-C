rule VPalnStat:
	input:
		"results/{sample}_VPaln.sam"
	output:
		"results/{sample}_VPaln_stat.tab"
	log:
		out="logs/vpAlnstat/{sample}.out.log",
		err="logs/vpAlnstat/{sample}.err.log"
	shell:
		"samtools flagstat {input} > {output}"