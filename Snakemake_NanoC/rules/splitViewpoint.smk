rule splitViewpoint:
	input:
		"input/VPcoor.bg"
	output:
		#expand("input/VPcoor.{prefix}.bed", prefix=vplist)
		"input/VPcoor"
	log:
		out="logs/splitViewpoint/VPcoor.out.log",
		err="logs/splitViewpoint/VPcoor.err.log"
	shell:
		#"perl scripts/Split_VPcoor.pl {input} {output} > {log.out} 2> {log.err}"
		"split -dl 1 --additional-suffix=.bed {input} {output}"
		#"awk '{print $0}' {input} > {output}"

