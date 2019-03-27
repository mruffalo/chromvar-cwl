cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: humancellatlas/hisat2:2-2.1.0-a
baseCommand: hisat2

arguments:
  - prefix: -S
    valueFrom: $(runtime.outdir)/$(inputs.fastq_dir.basename).sam
  - prefix: -x
    valueFrom: $(inputs.hisat2_idx_basedir.path)/$(inputs.hisat2_idx_basename)
  - prefix: "-1"
    valueFrom: $(inputs.fastq_dir.path)/$(inputs.fastq_dir.basename)_1.fastq
  - prefix: "-2"
    valueFrom: $(inputs.fastq_dir.path)/$(inputs.fastq_dir.basename)_2.fastq

inputs:
  hisat2_idx_basedir:
    label: "Path to directory containing the reference index"
    doc: "Path to directory containing the reference index"
    type: Directory
  hisat2_idx_basename:
    label: "Basename of the hisat2 index files"
    doc: "Basename of the hisat2 index files, not including extensions like .1.ht2"
    type: string
  fastq_dir:
    label: "Directory containing two FASTQ files"
    type: Directory
  dta:
    label: "Report alignments tailored for transcript assemblers"
    doc: >-
      Report alignments tailored for transcript assemblers including
      StringTie. With this option, HISAT2 requires longer anchor lengths
      for de novo discovery of splice sites. This leads to fewer
      alignments with short-anchors, which helps transcript assemblers
      improve significantly in computation and memory usage.
    type: boolean?
    default: true
    inputBinding:
      prefix: --downstream-transcriptome-assembly
  time:
    label: "Print the wall-clock time"
    doc: >-
      Print the wall-clock time required to load the index files and
      align the reads. This is printed to the 'standard error'
      ('stderr') filehandle.
    type: boolean?
    default: true
    inputBinding:
      prefix: --time
  nthreads:
    label: "Launch `nthreads` parallel search threads"
    doc: >-
      Launch `nthreads` parallel search threads (default: 1). Threads
      will run on separate processors/cores and synchronize when parsing
      reads and outputting alignments. Searching for alignments is
      highly parallel, and speedup is close to linear. Increasing -p
      increases HISAT2's memory footprint.
    type: int
    inputBinding:
      prefix: --threads

outputs:
  sam_output:
    type: File
    outputBinding:
      glob: $(inputs.fastq_dir.basename).sam
