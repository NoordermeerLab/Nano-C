rule InteractCorrection:
	input:
		"results/{sample}.All.interact",

	output:
		"results/{sample}.All.Corrected.interact"
	log:
		out="logs/interactCorrection/{sample}.All.out.log",
		err="logs/interactCorrection/{sample}.All.err.log"
	shell:
		"perl scripts/Correcting_interactFiles_wH_Step1_singleInteractfile_.pl {input} {output}  > {log.out} 2> {log.err}"
