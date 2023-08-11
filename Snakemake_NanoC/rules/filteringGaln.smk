rule filteringGaln:
	input:
		"results/{sample}_Galn.sam"
	output:
		"results/{sample}_Galn_sortedOnlyMapped_MAQgteq25.sam"
	log:
		out="logs/filterGAln/{sample}.out.log",
		err="logs/filterGAln/{sample}.err.log"
	shell:
		"samtools view -bS {input} | samtools sort | samtools view -h -F 4 -q 25 -o {output}"

