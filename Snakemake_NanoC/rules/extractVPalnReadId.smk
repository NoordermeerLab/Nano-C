rule extractVPalnReadId:
	input:
		"results/{sample}_VPaln_sortedOnlyMapped_MAQgteq50.sam"
	output:
		"results/{sample}_VPaln_sortedOnlyMapped_MAQgteq50_readId.list"
	log:
		out="logs/extvpAln/{sample}.out.log",
		err="logs/extvpAln/{sample}.err.log"
	shell:
		"scripts/extractVPalnReadId.sh {input} {output}"

