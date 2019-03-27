#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0
label: Short read alignment pipeline
inputs:
  - id: hisat2_idx_basedir
    label: "HISAT2 index directory"
    type: Directory
  - id: hisat2_idx_basename
    label: "HISAT2 index basename"
    type: string
  - id: fastq_dir
    label: "Directory containing two FASTQ files"
    type: Directory
  - id: nthreads
    label: "Number of threads for alignment"
    type: int
    inputBinding:
      prefix: --threads
outputs:
  - id: output_bam
    outputSource: sort_bam/output_bam
    type: File
    label: "Sorted BAM file"
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
