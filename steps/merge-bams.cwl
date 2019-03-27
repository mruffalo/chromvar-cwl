cwlVersion: v1.0
class: CommandLineTool
label: Merge BAM files
hints:
  DockerRequirement:
    dockerPull: biocontainers/samtools:v1.7.0_cv3
baseCommand: samtools

arguments:
  - merge
  - -n
  - id: output_bam_filename
    position: 1
    valueFrom: $(runtime.outdir)/merged.bam
inputs:
  input_bam:
    type: File[]
    inputBinding:
      position: 2
outputs:
  merged_bam:
    type: File
    outputBinding:
      glob: "merged.bam"
