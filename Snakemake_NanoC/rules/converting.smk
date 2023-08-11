rule converting:
	input:
		"input/{sample}.fastq"
	output:
		"results/{sample}_U2Tcon.fastq"
	log:
		out="logs/converting/{sample}.out.log",
		err="logs/converting/{sample}.err.log"
	shell:
		"perl scripts/converting_U2T_FASTQ_file.pl {input} {output}  > {log.out} 2> {log.err}"
