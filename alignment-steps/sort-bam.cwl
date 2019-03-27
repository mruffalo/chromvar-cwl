cwlVersion: v1.0
class: CommandLineTool
label: Sort BAM file
hints:
  DockerRequirement:
    dockerPull: biocontainers/samtools:v1.7.0_cv3
baseCommand: samtools

arguments:
  - sort
  - -n
  - id: output_bam_filename
    position: 2
    prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.input_bam.nameroot)_sorted.bam
inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.nameroot)_sorted.bam
