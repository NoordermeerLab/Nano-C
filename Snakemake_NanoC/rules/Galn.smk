rule Galn:
	input:
		"input/maskedGenome/mm10_masked.fa",
		"results/{sample}_VPaln_readId.fastq"
	output:
		"results/{sample}_Galn.sam"
	log:
		out="logs/GAln/{sample}.out.log",
		err="logs/GAln/{sample}.err.log"
	shell:
		"bwa mem -x ont2d {input} > {output}"
