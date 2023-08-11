rule CorrectionStep1:
	input:
		"results/Interact/"

	output:
		"results/Interact/CorrectionScript_status.out"
	log:
		out="logs/CorrectionS1/CS1.out.log",
		err="logs/CorrectionS1/CS1.err.log"
	shell:
		"perl scripts/Correcting_interactFiles_wH_Step1.pl {input} {output}  > {log.out} 2> {log.err}"
