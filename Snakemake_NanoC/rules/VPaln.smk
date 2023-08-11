rule VPaln:
	input:
		"input/ViewpointSeq/VPseq.fa",
		"results/{sample}_U2Tcon.fastq"
	output:
		"results/{sample}_VPaln.sam"
	log:
		out="logs/vpAln/{sample}.out.log",
		err="logs/vpAln/{sample}.err.log"
	shell:
		"bwa mem -x ont2d {input} > {output}"
