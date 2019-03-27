cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerImageId: mruffalo/chromvar
baseCommand: Rscript

inputs:
  r_script:
    type: File
    default:
      class: File
      location: chromvar-entry-point.R
    inputBinding:
      position: 1
  peaks:
    type: File
    inputBinding:
      position: 2
  input_bam:
    type: File[]
    inputBinding:
      position: 3
outputs:
  rdata_output:
    type: File
    outputBinding:
      glob: output.RData
  plot_output:
    type: File
    outputBinding:
      glob: output.pdf
