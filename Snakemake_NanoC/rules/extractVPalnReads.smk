rule extractVPalnReads:
	input:
		"results/{sample}_U2Tcon.fastq",
		"results/{sample}_VPaln_sortedOnlyMapped_MAQgteq50_readId.list"
	output:
		"results/{sample}_VPaln_readId.fastq"
	log:
		out="logs/extvpAln/{sample}.out.log",
		err="logs/extvpAln/{sample}.err.log"
	shell:
		"seqtk subseq {input} > {output}"

