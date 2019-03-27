cwlVersion: v1.0
class: CommandLineTool
label: Convert SAM to BAM
hints:
  DockerRequirement:
    dockerPull: biocontainers/samtools:v1.7.0_cv3
baseCommand: samtools

arguments:
  - view
  - id: bam_file
    position: 2
    prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.input_sam.nameroot).bam
inputs:
  write_bam_output:
    type: boolean
    inputBinding:
      prefix: -b
  input_is_sam:
    type: boolean
    inputBinding:
      prefix: -S
  input_sam:
    type: File
    inputBinding:
      position: 1
outputs:
  unsorted_bam:
    type: File
    outputBinding:
      glob: $(inputs.input_sam.nameroot).bam
