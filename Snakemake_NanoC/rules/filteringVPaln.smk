rule filteringVPaln:
	input:
		"results/{sample}_VPaln.sam"
	output:
		"results/{sample}_VPaln_sortedOnlyMapped_MAQgteq50.sam"
	log:
		out="logs/filtervpAln/{sample}.out.log",
		err="logs/filtervpAln/{sample}.err.log"
	shell:
		"samtools view -bS {input} | samtools sort | samtools view -h -F 4 -F 2048 -q 50 -o {output}"

