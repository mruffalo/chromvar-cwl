#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0
label: chromVAR scATAC-seq pipeline
requirements:
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
inputs:
  - id: hisat2_idx_basedir
    label: "HISAT2 index directory"
    type: Directory
  - id: hisat2_idx_basename
    label: "HISAT2 index basename"
    type: string
  - id: fastq_directories
    label: "FASTQ parent directory"
    type: Directory[]
  - id: nthreads
    label: "Number of threads for alignment"
    type: int
    inputBinding:
      prefix: --threads
  - id: output_rdata_filename
    label: "chromVAR workspace output filename (.RData)"
    type: string
  - id: output_plot_filename
    label: "Motif enrichment output filename (.pdf)"
    type: string
outputs:
  - id: rdata_output
    outputSource:
      - chromvar/rdata_output
    type: File
  - id: plot_output
    outputSource:
      - chromvar/plot_output
    type: File
steps:
  - id: align_reads
    scatter: fastq_dir
    in:
      - id: hisat2_idx_basedir
        source: hisat2_idx_basedir
      - id: hisat2_idx_basename
        source: hisat2_idx_basename
      - id: fastq_dir
        source: fastq_directories
      - id: nthreads
        source: nthreads
    out:
      - id: output_bam
    run: alignment-pipeline.cwl
    label: Alignment
  - id: merge_bams
    in:
      - id: input_bam
        source: align_reads/output_bam
    out:
      - id: merged_bam
    run: steps/merge-bams.cwl
  - id: call_peaks
    in:
      - id: input_bam
        source: merge_bams/merged_bam
    out:
      - id: peak_output
    run: steps/call-peaks.cwl
  - id: chromvar
    in:
      - id: input_bam
        source: align_reads/output_bam
      - id: peaks
        source: call_peaks/peak_output
    out:
      - id: rdata_output
      - id: plot_output
    run: steps/chromvar.cwl
