cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: mruffalo/genrich:latest
baseCommand: Genrich
label: Call peaks with Genrich

arguments:
  - id: output_narrowpeak_filename
    position: 2
    prefix: -o
    valueFrom: $(runtime.outdir)/$(inputs.input_bam.nameroot).narrowPeak

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
      prefix: -t

outputs:
  peak_output:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.nameroot).narrowPeak
