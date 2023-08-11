rule GalnStat:
	input:
		"results/{sample}_Galn.sam"
	output:
		"results/{sample}_Galn_stat.tab"
	log:
		out="logs/GAlnstat/{sample}.out.log",
		err="logs/GAlnstat/{sample}.err.log"
	shell:
		"samtools flagstat {input} > {output}"