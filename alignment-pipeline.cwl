#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0
label: Short read alignment pipeline
inputs:
  - id: hisat2_idx_basedir
    label: "Path to directory containing the reference index"
    doc: "Path to directory containing the reference index"
    type: Directory
  - id: hisat2_idx_basename
    label: "Basename of the hisat2 index files"
    doc: "Basename of the hisat2 index files, not including extensions like .1.ht2"
    type: string
  - id: fastq_dir
    label: "Directory containing two FASTQ files"
    type: Directory
  - id: nthreads
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
  - id: output_bam
    outputSource: sort_bam/output_bam
    type: File
    label: Sorted BAM file
steps:
  - id: align_reads
    in:
      - id: hisat2_idx_basedir
        source: hisat2_idx_basedir
      - id: hisat2_idx_basename
        source: hisat2_idx_basename
      - id: fastq_dir
        source: fastq_dir
      - id: nthreads
        source: nthreads
    out:
      - sam_output
    run: alignment-steps/align-reads.cwl
    label: Align reads
  - id: convert_to_bam
    in:
      - id: write_bam_output
        default: true
      - id: input_is_sam
        default: true
      - id: input_sam
        source: align_reads/sam_output
    out:
      - unsorted_bam
    run: alignment-steps/convert-to-bam.cwl
    label: STAR
  - id: sort_bam
    in:
      - id: input_bam
        source: convert_to_bam/unsorted_bam
    out:
      - output_bam
    run: alignment-steps/sort-bam.cwl
    label: Sort BAM file
