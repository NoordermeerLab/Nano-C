rule InteractFinal:
	input:
		"results/{sample}.All.Corrected.interact",

	output:
		"results/{sample}.All.Corrected.Final.interact"
	log:
		out="logs/interactFinal/{sample}.All.out.log",
		err="logs/interactFinal/{sample}.All.err.log"
	shell:
		"perl scripts/Correcting_interactFiles_Step2_intCount_singleInteractfile_.pl {input} {output}  > {log.out} 2> {log.err}"
