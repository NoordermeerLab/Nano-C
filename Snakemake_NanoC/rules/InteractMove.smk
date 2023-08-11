rule InteractMove:
	input:
		"results/{viewpoint}.interact"

	output:
		"results/Interact/{viewpoint}.interact"
	log:
		out="logs/moving/{viewpoint}.out.log",
		err="logs/moving/{viewpoint}.err.log"
	shell:
		"mv {input} {output}  > {log.out} 2> {log.err}"