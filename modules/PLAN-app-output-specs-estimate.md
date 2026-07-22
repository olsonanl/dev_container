# App Output Estimate — ground truth from QA run 2026-07-22

Companion data for **PLAN-app-output-specs.md**. This is the *observed* output
of each app, harvested by recursively listing the workspace result folder
(`.<output_file>/`) of one **completed** job per app from
`/home/olson/public_html/QA.2026-0722.1.html`, with the workspace object type
shown in the first column. Failed / preflight-skipped jobs were ignored.

The timestamped output basename (e.g. `out.2026-07-22-11-54-38`) has been
collapsed to `{output_file}` so the naming pattern is visible. Per-sample /
per-library / per-segment IDs (SRR…, SE1, A_HA_H5, JTAK0100000N, bin names,
ref accessions) are still literal below — see the plan's pattern taxonomy.

CAVEATS
- One sample per app: apps with parameter-conditional outputs (tree on/off,
  DE contrasts, recipe choice) are UNDER-counted here. Cross-check the service
  script.
- QA "OK" means the QA harness completed, NOT that the job produced full output.
  Some samples are degenerate: **GenomeAssembly2** below is a `JobFailed.txt`
  run (task exit 1) — re-sample a clean assembly before writing its spec.
- `unspecified` = file saved to the workspace with no type (usually an unmapped
  suffix in a recursive `p3-cp --map-suffix` copy). ~320 of ~700 observed files
  are `unspecified`; declaring outputs is also the lever to fix these.

---

### CodonTree

### /olson@patricbrc.org/PATRIC-QA/applications/App-CodonTree/2026/07/22/11-54-38/inp.json/.out.2026-07-22-11-54-38
    unspecified    53188  RAxML_info.out.2026-07-22-11-54-38
    unspecified     3007  RAxML_info.out.2026-07-22-11-54-38_proteins
    unspecified   796921  out.2026-07-22-11-54-38.afa
    unspecified     1628  out.2026-07-22-11-54-38.analysisStats
    txt            162  out.2026-07-22-11-54-38.genesPerGenome.txt
    txt           8606  out.2026-07-22-11-54-38.homologAlignmentStats.txt
    txt          27199  out.2026-07-22-11-54-38.homologsAndGenesIncludedInAlignment.txt
    unspecified     1246  out.2026-07-22-11-54-38.nex
    unspecified      105  out.2026-07-22-11-54-38.partitions
    unspecified      165  out.2026-07-22-11-54-38.raxmlCommand.sh
    svg           4025  out.2026-07-22-11-54-38.svg
    unspecified    99531  out.2026-07-22-11-54-38_proteins.afa
    nwk            345  out.2026-07-22-11-54-38_treeWithGenomeNames.nwk
    nwk            133  out.2026-07-22-11-54-38_tree_rooted.nwk
  html         23938  out.2026-07-22-11-54-38_report.html
  nwk            225  out.2026-07-22-11-54-38_tree.nwk
  phyloxml      3570  out.2026-07-22-11-54-38_tree.phyloxml

### ComparativeSystems

### /olson@patricbrc.org/PATRIC-QA/applications/App-ComparativeSystems/2026/07/22/11-54-49/basic.json/.out.2026-07-22-11-54-49
  json       4045251  out.2026-07-22-11-54-49_pathways_tables.json
  json       1763013  out.2026-07-22-11-54-49_proteinfams_tables.json
  tsv        2989813  out.2026-07-22-11-54-49_subsystems.tsv
  json       3495005  out.2026-07-22-11-54-49_subsystems_tables.json
  tsv          53394  out.2026-07-22-11-54-49_subsystems_variant_mtx.tsv
  txt            186  report.txt

### ComprehensiveSARS2Analysis

### /olson@patricbrc.org/PATRIC-QA/applications/App-ComprehensiveSARS2Analysis/2026/07/22/11-55-11/bug.79.auto.json/.out.2026-07-22-11-55-11
    contigs      30392  annotation.contigs.fasta
    embl         81453  annotation.embl
    feature_dna_fasta    70512  annotation.feature_dna.fasta
    feature_protein_fasta    26500  annotation.feature_protein.fasta
    feature_table     6612  annotation.features.txt
    genbank_file    79072  annotation.gb
    genome      116438  annotation.genome
    gff           7147  annotation.gff
    genbank_file    79003  annotation.merged.gb
    tar_gz       21389  annotation.tar.gz
    tsv          94467  annotation.txt
    xls         101888  annotation.xls
    json           950  quality.json
    txt              0  vigor4.stderr.txt
    txt          17210  vigor4.stdout.txt
    txt           2049  vigor_out-20260722-170409.ini
    txt         226459  vigor_out.aln
    feature_protein_fasta    47856  vigor_out.cds
    gff          16489  vigor_out.gff3
    feature_protein_fasta    28391  vigor_out.pep
    txt          13996  vigor_out.rpt
    txt           5983  vigor_out.tbl
    txt              0  vigor_out.warnings
  folder           0  .assembly/
    json           129  assembly-details.json
    txt          60995  assembly.align
    txt         643414  assembly.depth
    png           4028  assembly.detail.png
    contigs      30423  assembly.fasta
    png           6955  assembly.log.png
    txt       137634247  assembly.pileup.gz
    png           8255  assembly.png
    txt           5763  assembly.primer-trim.tbl
    txt           6584  assembly.primer-trim.txt
    bam       825497143  assembly.sorted.bam
    bai           2664  assembly.sorted.bam.bai
    txt            464  assembly.statistics.tsv
    txt            767  assembly.variants.tsv
    folder           0  sra-metadata/
  html         22508  FullGenomeReport.html
  genome      120353  annotated.genome
  job_result    35687  annotation
  job_result    10554  assembly
  contigs      30423  out.2026-07-22-11-55-11.fasta

### DifferentialExpression

### /olson@patricbrc.org/PATRIC-QA/applications/App-DifferentialExpression/2026/07/22/11-55-29/params.json/.out.2026-07-22-11-55-29
  diffexp_expression  4419132  expression.json
  diffexp_mapping   379848  mapping.json
  diffexp_sample     1087  sample.json

### FastqUtils

### /olson@patricbrc.org/PATRIC-QA/applications/App-FastqUtils/2026/07/22/11-55-33/Jira_BVBRC-1493.json/.out.2026-07-22-11-55-33
  txt           1367  SRR20184597_meta.txt

### GeneTree

### /olson@patricbrc.org/PATRIC-QA/applications/App-GeneTree/2026/07/22/11-57-38/Buchnera_acpS_fg_dna_gene_tree_test.json/.out.2026-07-22-11-57-38
  nwk            986  out.2026-07-22-11-57-38_fasttree.nwk
  phyloxml     16251  out.2026-07-22-11-57-38_fasttree.phyloxml
  txt         103317  out.2026-07-22-11-57-38_fasttree_log.txt
  html         11017  out.2026-07-22-11-57-38_gene_tree_report.html
  svg           8405  out7-22-11-57-38_fasttree.nwk.svg

### Genomad

### /olson@patricbrc.org/PATRIC-QA/applications/App-Genomad/2026/07/22/11-58-14/small.json/.out.2026-07-22-11-58-14
  contigs          0  phi-phage_plasmid.fna
  tsv            217  phi-phage_plasmid_genes.tsv
  feature_protein_fasta        0  phi-phage_plasmid_proteins.faa
  tsv            122  phi-phage_plasmid_summary.tsv
  json           546  phi-phage_summary.json
  contigs      30069  phi-phage_virus.fna
  tsv           7002  phi-phage_virus_genes.tsv
  feature_protein_fasta    16468  phi-phage_virus_proteins.faa
  tsv            267  phi-phage_virus_summary.tsv

### GenomeAlignment

### /olson@patricbrc.org/PATRIC-QA/applications/App-GenomeAlignment/2026/07/22/11-58-18/brucella.json/.out.2026-07-22-11-58-18
  txt       14359199  alignment.xmfa
  txt          55868  alignment.xmfa.backbone
  txt          21014  alignment.xmfa.bbcols

### GenomeAnnotation

### /olson@patricbrc.org/PATRIC-QA/applications/App-GenomeAnnotation/2026/07/22/11-58-21/archaea.json/.out.2026-07-22-11-58-21
  txt          31600  genome_quality_details.txt
  folder           0  load_files/
    json       2607421  feature_sequence.json
    json          1917  genome.json
    json             3  genome_amr.json
    json       2364830  genome_feature.json
    json       1751965  genome_sequence.json
    json           460  genome_typing.json
    json        686384  pathway.json
    json         30974  sp_gene.json
    json        654159  subsystem.json
    json             3  taxonomy.json
  contigs    1780578  out.2026-07-22-11-58-21.contigs.fasta
  embl       4039404  out.2026-07-22-11-58-21.embl
  feature_dna_fasta  1939036  out.2026-07-22-11-58-21.feature_dna.fasta
  feature_protein_fasta   761158  out.2026-07-22-11-58-21.feature_protein.fasta
  feature_table   275490  out.2026-07-22-11-58-21.features.txt
  genbank_file  3897489  out.2026-07-22-11-58-21.gb
  genome     7069837  out.2026-07-22-11-58-21.genome
  gff         298221  out.2026-07-22-11-58-21.gff
  genbank_file  3897437  out.2026-07-22-11-58-21.merged.gb
  tar_gz     1015511  out.2026-07-22-11-58-21.tar.gz
  tsv        2502684  out.2026-07-22-11-58-21.txt
  xls        2820608  out.2026-07-22-11-58-21.xls
  json        313673  quality.json
  txt            266  specialty-amrfinder.txt
  txt         738300  specialty-blast-alignments.txt
  txt           1824  specialty-blast.txt
  unspecified        3  specialty-rgi.json
  txt            360  specialty-rgi.txt

### GenomeAnnotationGenbank

### /olson@patricbrc.org/PATRIC-QA/applications/App-GenomeAnnotationGenbank/2026/07/22/11-59-38/GCA_902703305.json/.out.2026-07-22-11-59-38
  txt           3028  amr-mic.txt
  txt           2395  amr-sir.txt
  txt          44892  genome_quality_details.txt
  folder           0  load_files/
    json       8124705  feature_sequence.json
    json          2540  genome.json
    json         39873  genome_amr.json
    json      11552766  genome_feature.json
    json       5859319  genome_sequence.json
    json          6272  genome_typing.json
    json       1905825  pathway.json
    json       1862710  sp_gene.json
    json       2436552  subsystem.json
    json             3  taxonomy.json
  contigs    5676142  out.2026-07-22-11-59-38.contigs.fasta
  embl      12656215  out.2026-07-22-11-59-38.embl
  feature_dna_fasta  5604602  out.2026-07-22-11-59-38.feature_dna.fasta
  feature_protein_fasta  2242106  out.2026-07-22-11-59-38.feature_protein.fasta
  feature_table  1147976  out.2026-07-22-11-59-38.features.txt
  genbank_file 12191976  out.2026-07-22-11-59-38.gb
  genome    24603155  out.2026-07-22-11-59-38.genome
  gff         810560  out.2026-07-22-11-59-38.gff
  genbank_file 12083370  out.2026-07-22-11-59-38.merged.gb
  tar_gz     3226332  out.2026-07-22-11-59-38.tar.gz
  tsv        7898637  out.2026-07-22-11-59-38.txt
  xls        8855040  out.2026-07-22-11-59-38.xls
  txt           9380  specialty-amrfinder.txt
  txt        5826164  specialty-blast-alignments.txt
  txt         100205  specialty-blast.txt
  unspecified  2201011  specialty-rgi.json
  txt          99337  specialty-rgi.txt

### GenomeAssembly2

### /olson@patricbrc.org/PATRIC-QA/applications/App-GenomeAssembly2/2026/07/22/12-02-28/ERR1913166.json/.out.2026-07-22-12-02-28
  folder           0  details/
    txt           4821  spades.log

### GenomeComparison

### /olson@patricbrc.org/PATRIC-QA/applications/App-GenomeComparison/2026/07/22/12-03-02/bug.730720.json/.out.2026-07-22-12-03-02
  html       4807703  circos_final.html
  txt         331940  comp_genome_1.txt
  json       4895774  genome_comparison.json
  genome_comparison_table  1572472  genome_comparison.txt
  xls        4920832  genome_comparison.xls
  txt             32  karyotype.txt
  txt             19  large.tiles.txt
  html          2420  legend.html
  txt         318072  ref_genome.txt

### HASubtypeNumberingConversion

### /olson@patricbrc.org/PATRIC-QA/applications/App-HASubtypeNumberingConversion/2026/07/22/12-03-09/input.json/.out.2026-07-22-12-03-09
  txt         149306  blast.out
  contigs       1378  input.fasta
  unspecified     1117  query1.muscle.in
  txt           1154  query1.muscle.out
  contigs       2606  query1_result.fasta
  unspecified     1133  query2.muscle.in
  txt           1169  query2.muscle.out
  contigs       2605  query2_result.fasta
  tsv            385  sequence_annotation.tsv

### Homology

### /olson@patricbrc.org/PATRIC-QA/applications/App-Homology/2026/07/22/12-03-17/bug.4080322.json/.out.2026-07-22-12-03-17
  unspecified    18016  blast_out.archive
  json         14008  blast_out.json
  json           685  blast_out.metadata.json
  json         12046  blast_out.raw.json
  txt            874  blast_out.txt

### MSA

### /olson@patricbrc.org/PATRIC-QA/applications/App-MSA/2026/07/22/12-09-08/convert_input.json/.out.2026-07-22-12-09-08
  aligned_protein_fasta       30  out.2026-07-22-12-09-08.afa
  txt            131  out.2026-07-22-12-09-08.aln
  txt             78  out.2026-07-22-12-09-08.consensus.fasta
  svg          22557  out.2026-07-22-12-09-08.entropy.svg
  txt            129  out.2026-07-22-12-09-08.nexus
  txt             35  out.2026-07-22-12-09-08.phy
  txt             58  out.2026-07-22-12-09-08.pir
  tsv            233  out.2026-07-22-12-09-08.snp.tsv
  nwk             27  out.2026-07-22-12-09-08_fasttree.nwk
  txt           2009  out.2026-07-22-12-09-08_fasttree_log.txt

### MetaCATS

### /olson@patricbrc.org/PATRIC-QA/applications/App-MetaCATS/2026/07/22/12-10-59/auto_groups_aa.json/.out.2026-07-22-12-10-59
  tsv             44  out.2026-07-22-12-10-59-mcTable.tsv
  txt           2011  out.2026-07-22-12-10-59.mafft.log
  aligned_protein_fasta     1965  output.afa

### MetagenomeBinning

### /olson@patricbrc.org/PATRIC-QA/applications/App-MetagenomeBinning/2026/07/22/12-11-41/SRR8580939-contigs-bac.json/.out.2026-07-22-12-11-41
  json             3  bins.json
  txt            553  bins.stats.txt
  txt            277  coverage.stats.txt
  contigs     131109  unbinned.fasta
  contigs     130866  unplaced.fasta

### MetagenomicReadMapping

### /olson@patricbrc.org/PATRIC-QA/applications/App-MetagenomicReadMapping/2026/07/22/12-12-00/buchnera-CARD.json/.out.2026-07-22-12-12-00
  txt          16482  kma.aln
  txt         165801  kma.frag.gz
  txt           4543  kma.fsa
  txt            916  kma.mapstat
  txt            584  kma.res

### PrimerDesign

### /olson@patricbrc.org/PATRIC-QA/applications/App-PrimerDesign/2026/07/22/12-12-48/no_valid_solution_qa.json/.out.2026-07-22-12-12-48
  txt            809  out.2026-07-22-12-12-48_Primer3_output.txt
  html            26  out.2026-07-22-12-12-48_table.html

### RNASeq

### /olson@patricbrc.org/PATRIC-QA/applications/App-RNASeq/2026/07/22/12-13-17/SRP226172_Human_Single.json/.out.2026-07-22-12-13-17
    folder           0  SRR10307420/
      unspecified      222  SRR10307420.align_stdout
      bam       1262688511  SRR10307420.bam
      bai        3601456  SRR10307420.bam.bai
      html         31539  SRR10307420.bam.samstat.html
      unspecified    42712  SRR10307420.samtools_stats
      html        576310  SRR10307420_sample_fastqc.html
      unspecified   363308  SRR10307420_sample_fastqc.zip
      unspecified      165  SRR10307420_strand.infer
      unspecified  6180828  gene_abund.tab
      unspecified  5612582  merged_gene_abund.tab
      gff       359986997  merged_transcripts.gtf
      gff        7826524  transcripts.gtf
    folder           0  SRR10307421/
      unspecified      222  SRR10307421.align_stdout
      bam       1297010507  SRR10307421.bam
      bai        3991720  SRR10307421.bam.bai
      html         31542  SRR10307421.bam.samstat.html
      unspecified    42592  SRR10307421.samtools_stats
      html        571622  SRR10307421_sample_fastqc.html
      unspecified   355128  SRR10307421_sample_fastqc.zip
      unspecified      165  SRR10307421_strand.infer
      unspecified  5525238  gene_abund.tab
      unspecified  5601792  merged_gene_abund.tab
      gff       360219797  merged_transcripts.gtf
      gff        5334818  transcripts.gtf
  tsv        6466505  avirulent_vs_control.deseq2.tsv
  html          9155  bvbrc_rnaseq_report.html
  folder           0  control/
    folder           0  SRR10307418/
      unspecified      222  SRR10307418.align_stdout
      bam       1264841848  SRR10307418.bam
      bai        3758568  SRR10307418.bam.bai
      html         31537  SRR10307418.bam.samstat.html
      unspecified    42660  SRR10307418.samtools_stats
      html        571654  SRR10307418_sample_fastqc.html
      unspecified   357075  SRR10307418_sample_fastqc.zip
      unspecified      165  SRR10307418_strand.infer
      unspecified  5958786  gene_abund.tab
      unspecified  5619828  merged_gene_abund.tab
      gff       360334322  merged_transcripts.gtf
      gff        7076428  transcripts.gtf
    folder           0  SRR10307419/
      unspecified      222  SRR10307419.align_stdout
      bam       1179505245  SRR10307419.bam
      bai        3902200  SRR10307419.bam.bai
      html         31492  SRR10307419.bam.samstat.html
      unspecified    42597  SRR10307419.samtools_stats
      html        569506  SRR10307419_sample_fastqc.html
      unspecified   355628  SRR10307419_sample_fastqc.zip
      unspecified      165  SRR10307419_strand.infer
      unspecified  5660702  gene_abund.tab
      unspecified  5604415  merged_gene_abund.tab
      gff       360160251  merged_transcripts.gtf
      gff        5852803  transcripts.gtf
  csv        2275556  gene_counts_matrix.csv
  html       2032775  multiqc_report.html
  folder           0  report_images/
    png          32530  volcano_plot.png
  tsv            101  sample_metadata.tsv
  txt            288  sample_transcript_paths.txt
  tsv        2824025  tpm_counts_matrix.tsv
  csv        5572717  transcript_counts_matrix.csv

### SARS2Assembly

### /olson@patricbrc.org/PATRIC-QA/applications/App-SARS2Assembly/2026/07/22/12-13-45/inp.ERR4192740.json/.out.2026-07-22-12-13-45
  txt          60996  out.2026-07-22-12-13-45.align
  txt         639333  out.2026-07-22-12-13-45.depth
  png           4331  out.2026-07-22-12-13-45.detail.png
  contigs      30423  out.2026-07-22-12-13-45.fasta
  png           7860  out.2026-07-22-12-13-45.log.png
  txt       18524964  out.2026-07-22-12-13-45.pileup.gz
  png           7591  out.2026-07-22-12-13-45.png
  txt           5552  out.2026-07-22-12-13-45.primer-trim.tbl
  txt           6368  out.2026-07-22-12-13-45.primer-trim.txt
  bam       22794562  out.2026-07-22-12-13-45.sorted.bam
  bai            184  out.2026-07-22-12-13-45.sorted.bam.bai
  txt            459  out.2026-07-22-12-13-45.statistics.tsv
  txt            645  out.2026-07-22-12-13-45.variants.tsv
  folder           0  sra-metadata/
    json          2142  ERR4192740.json
    xml          13993  ERR4192740.xml

### SARS2Wastewater

### /olson@patricbrc.org/PATRIC-QA/applications/App-SARS2Wastewater/2026/07/22/12-14-46/paired_end_reads.json/.out.2026-07-22-12-14-46
  html        147119  SARS2Wastewater_report.html
  folder           0  SRR18540965/
    tsv            350  SRR18540965_aggregated_result.tsv
    folder           0  assembly/
      txt          60900  SRR18540965.align
      txt         579297  SRR18540965.depth
      png           6560  SRR18540965.detail.png
      contigs      30379  SRR18540965.fasta
      bam        2925454  SRR18540965.ivar.bam
      reads        29852  SRR18540965.ivar.fa
      txt          29799  SRR18540965.ivar.qual.txt
      png           8222  SRR18540965.log.png
      unspecified 45552660  SRR18540965.pileup
      unspecified  1488020  SRR18540965.pileup.gz
      png           6551  SRR18540965.png
      tsv          27439  SRR18540965.primer-trim.tbl
      txt          28253  SRR18540965.primer-trim.txt
      bam        2925151  SRR18540965.sorted.bam
      bai            152  SRR18540965.sorted.bam.bai
      tsv            437  SRR18540965.statistics.tsv
      tsv           6558  SRR18540965.variants.tsv
      txt            502  SRR18540965_flagstat.txt
      reads        29883  reference_trimmed.fa
      unspecified       32  reference_trimmed.fa.fai
    folder           0  fastqc_results/
      html        603261  SRR18540965.ivar_fastqc.html
      html        603267  SRR18540965.sorted_fastqc.html
      html        583307  SRR18540965_R1_fastqc.html
      html        585305  SRR18540965_R2_fastqc.html
    folder           0  freyja/
      unspecified   665483  SRR18540965_freyja.depths
      tsv            376  SRR18540965_freyja_result.tsv
      tsv         300300  SRR18540965_freyja_variants.tsv
  folder           0  SRR18540966/
    tsv            261  SRR18540966_aggregated_result.tsv
    folder           0  assembly/
      txt          60900  SRR18540966.align
      txt         531158  SRR18540966.depth
      png           8550  SRR18540966.detail.png
      contigs      30395  SRR18540966.fasta
      bam        1351804  SRR18540966.ivar.bam
      reads        29868  SRR18540966.ivar.fa
      txt          29815  SRR18540966.ivar.qual.txt
      png           8248  SRR18540966.log.png
      unspecified 21064098  SRR18540966.pileup
      unspecified   740497  SRR18540966.pileup.gz
      png           6126  SRR18540966.png
      tsv          27242  SRR18540966.primer-trim.tbl
      txt          28054  SRR18540966.primer-trim.txt
      bam        1351150  SRR18540966.sorted.bam
      bai            152  SRR18540966.sorted.bam.bai
      tsv            434  SRR18540966.statistics.tsv
      tsv           5677  SRR18540966.variants.tsv
      txt            495  SRR18540966_flagstat.txt
      reads        29883  reference_trimmed.fa
      unspecified       32  reference_trimmed.fa.fai
    folder           0  fastqc_results/
      html        621229  SRR18540966.ivar_fastqc.html
      html        621235  SRR18540966.sorted_fastqc.html
      html        582033  SRR18540966_R1_fastqc.html
      html        586135  SRR18540966_R2_fastqc.html
    folder           0  freyja/
      unspecified   655041  SRR18540966_freyja.depths
      tsv            287  SRR18540966_freyja_result.tsv
      tsv         141867  SRR18540966_freyja_variants.tsv
  folder           0  SRR18540967/
    tsv            348  SRR18540967_aggregated_result.tsv
    folder           0  assembly/
      txt          60904  SRR18540967.align
      txt         559096  SRR18540967.depth
      png           8007  SRR18540967.detail.png
      contigs      30396  SRR18540967.fasta
      bam        1445861  SRR18540967.ivar.bam
      reads        29869  SRR18540967.ivar.fa
      txt          29816  SRR18540967.ivar.qual.txt
      png           8227  SRR18540967.log.png
      unspecified 22787073  SRR18540967.pileup
      unspecified   793486  SRR18540967.pileup.gz
      png           6594  SRR18540967.png
      tsv          27207  SRR18540967.primer-trim.tbl
      txt          28017  SRR18540967.primer-trim.txt
      bam        1445354  SRR18540967.sorted.bam
      bai            152  SRR18540967.sorted.bam.bai
      tsv            433  SRR18540967.statistics.tsv
      tsv           6383  SRR18540967.variants.tsv
      txt            494  SRR18540967_flagstat.txt
      reads        29883  reference_trimmed.fa
      unspecified       32  reference_trimmed.fa.fai
    folder           0  fastqc_results/
      html        621687  SRR18540967.ivar_fastqc.html
      html        621693  SRR18540967.sorted_fastqc.html
      html        577859  SRR18540967_R1_fastqc.html
      html        585524  SRR18540967_R2_fastqc.html
    folder           0  freyja/
      unspecified   652854  SRR18540967_freyja.depths
      tsv            374  SRR18540967_freyja_result.tsv
      tsv         158433  SRR18540967_freyja_variants.tsv
  tsv            865  freyja_result.tsv
  tsv            655  job_stats.tsv
  csv            291  sample_key.csv
  txt           1856  version_log.txt

### SequenceSubmission

### /olson@patricbrc.org/PATRIC-QA/applications/App-SequenceSubmission/2026/07/22/12-15-15/input.json/.out.2026-07-22-12-15-15
    folder           0  ManualSubmission/
      folder           0  test_reassortant_RGpassage_1997/
        xml            776  submission.xml
        unspecified    13183  submission.zip
        unspecified        0  submit.ready
      folder           0  test_swine_guangxi_2011/
        xml            760  submission.xml
        unspecified    12290  submission.zip
        unspecified        0  submit.ready
    folder           0  Submission/
      folder           0  test_reassortant_RGpassage_1997/
        xml            776  submission.xml
        unspecified     5583  submission.zip
        unspecified        0  submit.ready
      folder           0  test_swine_guangxi_2011/
        xml            760  submission.xml
        unspecified     5182  submission.zip
        unspecified        0  submit.ready
  folder           0  SequenceValidation/
    folder           0  test_reassortant_RGpassage_1997/
      unspecified     2722  test_reassortant_RGpassage_1997-1-20260722-171541.ini
      unspecified    11694  test_reassortant_RGpassage_1997-1.aln
      unspecified     2458  test_reassortant_RGpassage_1997-1.cds
      contigs       2376  test_reassortant_RGpassage_1997-1.fasta
      unspecified      561  test_reassortant_RGpassage_1997-1.gff3
      unspecified      912  test_reassortant_RGpassage_1997-1.pep
      unspecified     4623  test_reassortant_RGpassage_1997-1.rpt
      unspecified      232  test_reassortant_RGpassage_1997-1.tbl
      unspecified        0  test_reassortant_RGpassage_1997-1.warnings
      unspecified     2722  test_reassortant_RGpassage_1997-2-20260722-171544.ini
      unspecified    42371  test_reassortant_RGpassage_1997-2.aln
      unspecified     2454  test_reassortant_RGpassage_1997-2.cds
      contigs       2376  test_reassortant_RGpassage_1997-2.fasta
      unspecified      561  test_reassortant_RGpassage_1997-2.gff3
      unspecified      912  test_reassortant_RGpassage_1997-2.pep
      unspecified     4625  test_reassortant_RGpassage_1997-2.rpt
      unspecified      232  test_reassortant_RGpassage_1997-2.tbl
      unspecified        0  test_reassortant_RGpassage_1997-2.warnings
      unspecified     2720  test_reassortant_RGpassage_1997-20260722-171523.ini
      unspecified     2722  test_reassortant_RGpassage_1997-3-20260722-171537.ini
      unspecified    50332  test_reassortant_RGpassage_1997-3.aln
      unspecified     3185  test_reassortant_RGpassage_1997-3.cds
      contigs       2268  test_reassortant_RGpassage_1997-3.fasta
      unspecified     1421  test_reassortant_RGpassage_1997-3.gff3
      unspecified     1251  test_reassortant_RGpassage_1997-3.pep
      unspecified     4902  test_reassortant_RGpassage_1997-3.rpt
      unspecified      445  test_reassortant_RGpassage_1997-3.tbl
      unspecified        0  test_reassortant_RGpassage_1997-3.warnings
      unspecified     2722  test_reassortant_RGpassage_1997-4-20260722-171556.ini
      unspecified   208522  test_reassortant_RGpassage_1997-4.aln
      unspecified     1851  test_reassortant_RGpassage_1997-4.cds
      contigs       1776  test_reassortant_RGpassage_1997-4.fasta
      unspecified      560  test_reassortant_RGpassage_1997-4.gff3
      unspecified     1696  test_reassortant_RGpassage_1997-4.pep
      unspecified     5714  test_reassortant_RGpassage_1997-4.rpt
      unspecified      458  test_reassortant_RGpassage_1997-4.tbl
      unspecified        0  test_reassortant_RGpassage_1997-4.warnings
      unspecified     2722  test_reassortant_RGpassage_1997-5-20260722-171535.ini
      unspecified     7949  test_reassortant_RGpassage_1997-5.aln
      unspecified     1667  test_reassortant_RGpassage_1997-5.cds
      contigs       1600  test_reassortant_RGpassage_1997-5.fasta
      unspecified      560  test_reassortant_RGpassage_1997-5.gff3
      unspecified      652  test_reassortant_RGpassage_1997-5.pep
      unspecified     4628  test_reassortant_RGpassage_1997-5.rpt
      unspecified      234  test_reassortant_RGpassage_1997-5.tbl
      unspecified        0  test_reassortant_RGpassage_1997-5.warnings
      unspecified     2722  test_reassortant_RGpassage_1997-6-20260722-171551.ini
      unspecified    73954  test_reassortant_RGpassage_1997-6.aln
      unspecified     1568  test_reassortant_RGpassage_1997-6.cds
      contigs       1495  test_reassortant_RGpassage_1997-6.fasta
      unspecified      560  test_reassortant_RGpassage_1997-6.gff3
      unspecified      615  test_reassortant_RGpassage_1997-6.pep
      unspecified     4625  test_reassortant_RGpassage_1997-6.rpt
      unspecified      227  test_reassortant_RGpassage_1997-6.tbl
      unspecified        0  test_reassortant_RGpassage_1997-6.warnings
      unspecified     2722  test_reassortant_RGpassage_1997-7-20260722-171554.ini
      unspecified    16408  test_reassortant_RGpassage_1997-7.aln
      unspecified     1371  test_reassortant_RGpassage_1997-7.cds
      contigs       1062  test_reassortant_RGpassage_1997-7.fasta
      unspecified     1247  test_reassortant_RGpassage_1997-7.gff3
      unspecified      656  test_reassortant_RGpassage_1997-7.pep
      unspecified     4902  test_reassortant_RGpassage_1997-7.rpt
      unspecified      421  test_reassortant_RGpassage_1997-7.tbl
      unspecified        0  test_reassortant_RGpassage_1997-7.warnings
      unspecified     2722  test_reassortant_RGpassage_1997-8-20260722-171548.ini
      unspecified    44316  test_reassortant_RGpassage_1997-8.aln
      unspecified     1351  test_reassortant_RGpassage_1997-8.cds
      contigs        925  test_reassortant_RGpassage_1997-8.fasta
      unspecified     1245  test_reassortant_RGpassage_1997-8.gff3
      unspecified      654  test_reassortant_RGpassage_1997-8.pep
      unspecified     4919  test_reassortant_RGpassage_1997-8.rpt
      unspecified      456  test_reassortant_RGpassage_1997-8.tbl
      unspecified        0  test_reassortant_RGpassage_1997-8.warnings
      unspecified   455548  test_reassortant_RGpassage_1997.aln
      unspecified    15905  test_reassortant_RGpassage_1997.cds
      contigs      14574  test_reassortant_RGpassage_1997.fasta
      unspecified     6603  test_reassortant_RGpassage_1997.gff3
      unspecified     7348  test_reassortant_RGpassage_1997.pep
      unspecified    13676  test_reassortant_RGpassage_1997.rpt
      unspecified     2705  test_reassortant_RGpassage_1997.tbl
      unspecified        0  test_reassortant_RGpassage_1997.warnings
    folder           0  test_swine_guangxi_2011/
      unspecified     2706  test_swine_guangxi_2011-1-20260722-171621.ini
      unspecified    11538  test_swine_guangxi_2011-1.aln
      unspecified     2436  test_swine_guangxi_2011-1.cds
      contigs       2272  test_swine_guangxi_2011-1.fasta
      unspecified      501  test_swine_guangxi_2011-1.gff3
      unspecified      914  test_swine_guangxi_2011-1.pep
      unspecified     4534  test_swine_guangxi_2011-1.rpt
      unspecified      237  test_swine_guangxi_2011-1.tbl
      unspecified        0  test_swine_guangxi_2011-1.warnings
      unspecified     2706  test_swine_guangxi_2011-2-20260722-171646.ini
      unspecified    41861  test_swine_guangxi_2011-2.aln
      unspecified     2445  test_swine_guangxi_2011-2.cds
      contigs       2301  test_swine_guangxi_2011-2.fasta
      unspecified      469  test_swine_guangxi_2011-2.gff3
      unspecified      903  test_swine_guangxi_2011-2.pep
      unspecified     4536  test_swine_guangxi_2011-2.rpt
      unspecified      214  test_swine_guangxi_2011-2.tbl
      unspecified        0  test_swine_guangxi_2011-2.warnings
      unspecified     2704  test_swine_guangxi_2011-20260722-171603.ini
      unspecified     2706  test_swine_guangxi_2011-3-20260722-171643.ini
      unspecified    47722  test_swine_guangxi_2011-3.aln
      unspecified     3107  test_swine_guangxi_2011-3.cds
      contigs       2127  test_swine_guangxi_2011-3.fasta
      unspecified     1253  test_swine_guangxi_2011-3.gff3
      unspecified     1243  test_swine_guangxi_2011-3.pep
      unspecified     4805  test_swine_guangxi_2011-3.rpt
      unspecified      463  test_swine_guangxi_2011-3.tbl
      unspecified        0  test_swine_guangxi_2011-3.warnings
      unspecified     2706  test_swine_guangxi_2011-4-20260722-171624.ini
      unspecified   196887  test_swine_guangxi_2011-4.aln
      unspecified     1861  test_swine_guangxi_2011-4.cds
      contigs       1784  test_swine_guangxi_2011-4.fasta
      unspecified      472  test_swine_guangxi_2011-4.gff3
      unspecified     1676  test_swine_guangxi_2011-4.pep
      unspecified     5601  test_swine_guangxi_2011-4.rpt
      unspecified      434  test_swine_guangxi_2011-4.tbl
      unspecified        0  test_swine_guangxi_2011-4.warnings
      unspecified     2706  test_swine_guangxi_2011-5-20260722-171618.ini
      unspecified     7925  test_swine_guangxi_2011-5.aln
      unspecified     1659  test_swine_guangxi_2011-5.cds
      contigs       1569  test_swine_guangxi_2011-5.fasta
      unspecified      472  test_swine_guangxi_2011-5.gff3
      unspecified      644  test_swine_guangxi_2011-5.pep
      unspecified     4539  test_swine_guangxi_2011-5.rpt
      unspecified      218  test_swine_guangxi_2011-5.tbl
      unspecified        0  test_swine_guangxi_2011-5.warnings
      unspecified     2706  test_swine_guangxi_2011-6-20260722-171634.ini
      unspecified    69975  test_swine_guangxi_2011-6.aln
      unspecified     1566  test_swine_guangxi_2011-6.cds
      contigs       1461  test_swine_guangxi_2011-6.fasta
      unspecified      472  test_swine_guangxi_2011-6.gff3
      unspecified      609  test_swine_guangxi_2011-6.pep
      unspecified     4536  test_swine_guangxi_2011-6.rpt
      unspecified      211  test_swine_guangxi_2011-6.tbl
      unspecified        0  test_swine_guangxi_2011-6.warnings
      unspecified     2706  test_swine_guangxi_2011-7-20260722-171638.ini
      unspecified     4232  test_swine_guangxi_2011-7.aln
      unspecified      904  test_swine_guangxi_2011-7.cds
      contigs        786  test_swine_guangxi_2011-7.fasta
      unspecified      464  test_swine_guangxi_2011-7.gff3
      unspecified      389  test_swine_guangxi_2011-7.pep
      unspecified     4535  test_swine_guangxi_2011-7.rpt
      unspecified      210  test_swine_guangxi_2011-7.tbl
      unspecified        0  test_swine_guangxi_2011-7.warnings
      unspecified     2706  test_swine_guangxi_2011-8-20260722-171640.ini
      unspecified    41285  test_swine_guangxi_2011-8.aln
      unspecified      812  test_swine_guangxi_2011-8.cds
      contigs        687  test_swine_guangxi_2011-8.fasta
      unspecified      465  test_swine_guangxi_2011-8.gff3
      unspecified      364  test_swine_guangxi_2011-8.pep
      unspecified     4545  test_swine_guangxi_2011-8.rpt
      unspecified      221  test_swine_guangxi_2011-8.tbl
      unspecified        0  test_swine_guangxi_2011-8.warnings
      unspecified   421424  test_swine_guangxi_2011.aln
      unspecified    14790  test_swine_guangxi_2011.cds
      contigs      13619  test_swine_guangxi_2011.fasta
      unspecified     4456  test_swine_guangxi_2011.gff3
      unspecified     6742  test_swine_guangxi_2011.pep
      unspecified    12705  test_swine_guangxi_2011.rpt
      unspecified     2208  test_swine_guangxi_2011.tbl
      unspecified        0  test_swine_guangxi_2011.warnings
  csv           1277  Sequence_Validation_Report.csv
  contigs      28625  input.fasta
  csv            891  metadata.csv

### StabilityPrediction

### /olson@patricbrc.org/PATRIC-QA/applications/App-StabilityPrediction/2026/07/22/12-15-18/t1.json/.out.2026-07-22-12-15-18

### StructureSequencePrediction

### /olson@patricbrc.org/PATRIC-QA/applications/App-StructureSequencePrediction/2026/07/22/12-15-22/lassa_ranked0_af2_random_r01001100.json/.out.2026-07-22-12-15-22
    folder           0  probs/
      unspecified  5074290  lassa_ranked0_af2.npz
      tsv             35  lassa_ranked0_af2.npz.tsv
    folder           0  scores/
      unspecified      680  lassa_ranked0_af2.npz
      tsv             19  lassa_ranked0_af2.npz.tsv
    folder           0  seqs/
      feature_protein_fasta    32812  lassa_ranked0_af2.fa
      aligned_protein_fasta    57256  lassa_ranked0_af2.fasta

### SubspeciesClassification

### /olson@patricbrc.org/PATRIC-QA/applications/App-SubspeciesClassification/2026/07/22/12-15-27/bovine.json/.out.2026-07-22-12-15-27
    nwk            825  1aAM749161.tre
    nwk            826  1aAM749829.tre
    nwk            826  1bAM749165.tre
    nwk            934  1bAM749168.tre
    nwk            825  1cAF144610.tre
    nwk            826  1cAF144614.tre
    nwk            824  1dAM749171.tre
    nwk            826  1dAM749172.tre
    nwk            826  1eAM749167.tre
    nwk            933  1eAM749175.tre
    nwk            936  1eAM749677.tre
    nwk            827  1eAM749690.tre
    nwk            932  1fAM749162.tre
    nwk            934  1fAM749163.tre
    nwk            826  1fAM749164.tre
    nwk            826  1fAM749178.tre
    nwk            968  1gAM749017.tre
    nwk            827  1gAM749182.tre
    nwk            826  1gAM900666.tre
    nwk            825  2AF104030.tre
    nwk            933  2AJ304381.tre
    nwk            823  2U18059.tre
    nwk            826  2aAM749823.tre
    tsv           1409  cladinator_results.tsv
    reads        25524  input.fasta
    json          5760  out.json
    nwk          19780  out.sing.tre
    reads       631886  ref_MSA_with_query_seqs.fasta
    tsv            389  result.tsv
  html         12404  out.2026-07-22-12-15-27_classification_report.html

### TaxonomicClassification

### /olson@patricbrc.org/PATRIC-QA/applications/App-TaxonomicClassification/2026/07/22/12-17-43/16S_multisample.json/.out.2026-07-22-12-17-43
    csv            260  SRR26088207_alpha_diversity.csv
    html       4569319  SRR26088207_alpha_diversity.html
    folder           0  bracken_output/
      unspecified     3474  SRR26088207.krona
      txt            575  SRR26088207_bracken_output.txt
      txt           2283  SRR26088207_bracken_report.txt
    folder           0  fastqc_results/
      folder           0  raw_read/
        html        709626  raw_SRR26088207_fastqc.html
        unspecified   461225  raw_SRR26088207_fastqc.zip
      folder           0  trimmed_read/
        html        824412  SRR26088207_trimmed_fastqc.html
        unspecified   502730  SRR26088207_trimmed_fastqc.zip
    folder           0  kraken_output/
      txt       20133521  SRR26088207_k2_output.txt
      txt          11710  SRR26088207_k2_report.txt
    folder           0  trimmed_read/
      txt           2825  SRR26088207.fastq.gz_trimming_report.txt
      reads     17465571  SRR26088207_trimmed.fastq.gz
  html        234255  SRR26088207_krona.html
  folder           0  SRR26127838/
    csv            259  SRR26127838_alpha_diversity.csv
    html       4569319  SRR26127838_alpha_diversity.html
    folder           0  bracken_output/
      unspecified     2145  SRR26127838.krona
      txt            423  SRR26127838_bracken_output.txt
      txt           1437  SRR26127838_bracken_report.txt
    folder           0  fastqc_results/
      folder           0  raw_reads/
        html        967459  raw_SRR26127838_R1_fastqc.html
        unspecified   858695  raw_SRR26127838_R1_fastqc.zip
        html        973322  raw_SRR26127838_R2_fastqc.html
        unspecified   866626  raw_SRR26127838_R2_fastqc.zip
      folder           0  trimmed_reads/
        html        956143  SRR26127838_R1_trimmed_fastqc.html
        unspecified   862537  SRR26127838_R1_trimmed_fastqc.zip
        html        976054  SRR26127838_R2_trimmed_fastqc.html
        unspecified   883623  SRR26127838_R2_trimmed_fastqc.zip
    folder           0  kraken_output/
      txt        6483439  SRR26127838_k2_output.txt
      txt           7003  SRR26127838_k2_report.txt
    folder           0  trimmed_reads/
      txt           2046  SRR26127838_R1.fastq.gz_trimming_report.txt
      reads      2601070  SRR26127838_R1_trimmed.fastq.gz
      txt           2207  SRR26127838_R2.fastq.gz_trimming_report.txt
      reads      3120800  SRR26127838_R2_trimmed.fastq.gz
  html        231293  SRR26127838_krona.html
  html       5005634  Taxonomic-Classification-Service-BVBRC_multiqc_report.html
  csv            225  alpha_diversity.csv
  html       4569374  alpha_diversity.html
  csv            465  beta_diversity.csv
  html       4567759  beta_stats_heatmap.html
  csv            171  multi_sample_table.csv
  html        389142  multisample_comparison.html
  html        239005  multisample_krona.html
  html        648358  multisample_sankey.html
  csv            235  sample_key.csv
  csv            315  summary_table.csv

### TnSeq

### /olson@patricbrc.org/PATRIC-QA/applications/App-TnSeq/2026/07/22/12-18-25/contigs_with_empty_alignments.json/.out.2026-07-22-12-18-25
  bam            608  control1.bam.bai
  txt           5660  control1.tn_stats
  txt         213581  control1_JTAK01000001.counts
  wig         100476  control1_JTAK01000001.wig
  txt         255313  control1_JTAK01000002.counts
  wig         120198  control1_JTAK01000002.wig
  txt          68688  control1_JTAK01000003.counts
  wig          31702  control1_JTAK01000003.wig
  txt         164305  control1_JTAK01000004.counts
  wig          77119  control1_JTAK01000004.wig
  txt         131810  control1_JTAK01000005.counts
  wig          61554  control1_JTAK01000005.wig
  txt         101571  control1_JTAK01000006.counts
  wig          47355  control1_JTAK01000006.wig
  txt           2939  control1_JTAK01000007.counts
  wig           1234  control1_JTAK01000007.wig
  txt          17758  control1_JTAK01000008.counts
  wig           7873  control1_JTAK01000008.wig
  txt          19451  control1_JTAK01000009.counts
  wig           8625  control1_JTAK01000009.wig
  txt            430  control1_JTAK01000010.counts
  wig            224  control1_JTAK01000010.wig
  txt          22060  control1_JTAK01000011.counts
  wig           9754  control1_JTAK01000011.wig
  txt           4819  control1_JTAK01000012.counts
  wig           2014  control1_JTAK01000012.wig
  txt           5128  control1_JTAK01000013.counts
  wig           2222  control1_JTAK01000013.wig
  txt           1853  control1_JTAK01000014.counts
  wig            797  control1_JTAK01000014.wig
  txt            644  control1_JTAK01000015.counts
  wig            309  control1_JTAK01000015.wig
  txt           2828  control1_JTAK01000016.counts
  wig           1182  control1_JTAK01000016.wig
  txt          66113  gumbel_control_JTAK01000001_transit.txt
  txt          73466  gumbel_control_JTAK01000002_transit.txt
  txt          23232  gumbel_control_JTAK01000003_transit.txt
  txt          54649  gumbel_control_JTAK01000004_transit.txt
  txt          34307  gumbel_control_JTAK01000005_transit.txt
  txt          34467  gumbel_control_JTAK01000006_transit.txt
  txt           6553  gumbel_control_JTAK01000008_transit.txt
  txt           6889  gumbel_control_JTAK01000009_transit.txt
  txt           8956  gumbel_control_JTAK01000011_transit.txt
  txt           1579  gumbel_control_JTAK01000013_transit.txt
  txt             25  output_keys.txt

### Variation

### /olson@patricbrc.org/PATRIC-QA/applications/App-Variation/2026/07/22/12-18-44/10184171.json/.out.2026-07-22-12-18-44
  unspecified     3992  SE1.aln.bam.bai
  contigs    1098588  SE1.consensus.fa
  bigwig     3943342  SE1.cov.bigwig
  tsv        2276583  SE1.var.annotated.tsv
  vcf        3466801  SE1.var.snpEff.vcf
  vcf        1445804  SE1.var.vcf
  unspecified   219538  SE1.var.vcf.gz
  unspecified      743  SE1.var.vcf.gz.tbi
  folder           0  Text_Files_Circular_Viewer/
    txt           1986  SE1.Deletion_var_circular_view_input.txt
    txt           1488  SE1.High_var_circular_view_input.txt
    txt           1943  SE1.Insertion_var_circular_view_input.txt
    txt         133208  SE1.Low_var_circular_view_input.txt
    txt          81790  SE1.Moderate_var_circular_view_input.txt
    txt          21411  SE1.Modifier_var_circular_view_input.txt
    txt          81526  SE1.Nonsyn_var_circular_view_input.txt
    txt           1986  all.Deletion_var_circular_view_input.txt
    txt           1464  all.High_var_circular_view_input.txt
    txt           1919  all.Insertion_var_circular_view_input.txt
    txt         133208  all.Low_var_circular_view_input.txt
    txt          81790  all.Moderate_var_circular_view_input.txt
    txt          21411  all.Modifier_var_circular_view_input.txt
    txt          81526  all.Nonsyn_var_circular_view_input.txt
  html      10601103  all.var.html
  tsv        2316208  all.var.tsv
  txt             53  libs.txt
  txt           1133  summary.txt

### ViralAssembly

### /olson@patricbrc.org/PATRIC-QA/applications/App-ViralAssembly/2026/07/22/12-20-23/viral_test_paired.json/.out.2026-07-22-12-20-23
  contigs        989  A_MP.fasta
  contigs       1420  A_NA_N1.fasta
  contigs       1504  A_NP.fasta
  contigs        845  A_NS.fasta
  contigs       2158  A_PA.fasta
  contigs       2282  A_PB1.fasta
  contigs       2288  A_PB2.fasta
  html          4092  AssemblyReport.html
  reads     98069250  SRR28752451_1.fastq
  reads     98079632  SRR28752451_2.fastq
  folder           0  irma/
    unspecified   625101  A_HA_H5.bam
    unspecified       96  A_HA_H5.bam.bai
    unspecified     2145  A_HA_H5.vcf
    unspecified  3689278  A_MP.bam
    unspecified       96  A_MP.bam.bai
    unspecified     2037  A_MP.vcf
    unspecified  1089603  A_NA_N1.bam
    unspecified       96  A_NA_N1.bam.bai
    unspecified     2052  A_NA_N1.vcf
    unspecified  1654206  A_NP.bam
    unspecified       96  A_NP.bam.bai
    unspecified     2037  A_NP.vcf
    unspecified  2857526  A_NS.bam
    unspecified       96  A_NS.bam.bai
    unspecified     2026  A_NS.vcf
    unspecified   518063  A_PA.bam
    unspecified       96  A_PA.bam.bai
    unspecified     2037  A_PA.vcf
    unspecified   404109  A_PB1.bam
    unspecified       96  A_PB1.bam.bai
    unspecified     2042  A_PB1.vcf
    unspecified   548819  A_PB2.bam
    unspecified       96  A_PB2.bam.bai
    unspecified     2133  A_PB2.vcf
    folder           0  amended_consensus/
      reads         2289  irma_1.fa
      reads         2283  irma_2.fa
      reads         2160  irma_3.fa
      reads         1713  irma_4.fa
      reads         1506  irma_5.fa
      reads         1419  irma_6.fa
      reads          991  irma_7.fa
      reads          847  irma_8.fa
    folder           0  figures/
      unspecified   111561  A_HA_H5-coverageDiagram.pdf
      unspecified    19022  A_HA_H5-heuristics.pdf
      unspecified    68997  A_MP-coverageDiagram.pdf
      unspecified    19083  A_MP-heuristics.pdf
      unspecified    94610  A_NA_N1-coverageDiagram.pdf
      unspecified    19069  A_NA_N1-heuristics.pdf
      unspecified   100635  A_NP-coverageDiagram.pdf
      unspecified    19118  A_NP-heuristics.pdf
      unspecified    59034  A_NS-coverageDiagram.pdf
      unspecified    18841  A_NS-heuristics.pdf
      unspecified   138078  A_PA-coverageDiagram.pdf
      unspecified    18918  A_PA-heuristics.pdf
      unspecified   142235  A_PB1-coverageDiagram.pdf
      unspecified    19098  A_PB1-heuristics.pdf
      unspecified   144809  A_PB2-coverageDiagram.pdf
      unspecified    19052  A_PB2-heuristics.pdf
      unspecified    10163  READ_PERCENTAGES.pdf
    folder           0  intermediate/
      folder           0  0-ITERATIVE-REFERENCES/
        unspecified     1717  R0-A_HA_H5.ref
        unspecified      989  R0-A_MP.ref
        unspecified     1423  R0-A_NA_N1.ref
        unspecified     1504  R0-A_NP.ref
        unspecified      870  R0-A_NS.ref
        unspecified     2158  R0-A_PA.ref
        unspecified     2282  R0-A_PB1.ref
        unspecified     2288  R0-A_PB2.ref
        unspecified     1717  R1-A_HA_H5.ref
        unspecified      989  R1-A_MP.ref
        unspecified     1423  R1-A_NA_N1.ref
        unspecified     1504  R1-A_NP.ref
        unspecified      845  R1-A_NS.ref
        unspecified     2158  R1-A_PA.ref
        unspecified     2282  R1-A_PB1.ref
        unspecified     2288  R1-A_PB2.ref
        unspecified     1717  R2-A_HA_H5.ref
        unspecified      989  R2-A_MP.ref
        unspecified     1423  R2-A_NA_N1.ref
        unspecified     1504  R2-A_NP.ref
        unspecified      845  R2-A_NS.ref
        unspecified     2158  R2-A_PA.ref
        unspecified     2282  R2-A_PB1.ref
        unspecified     2288  R2-A_PB2.ref
      folder           0  1-MATCH_BLAT/
        tar_gz     1967406  R1.tar.gz
        tar_gz       27876  R2.tar.gz
        tar_gz         450  R3.tar.gz
      folder           0  2-SORT_BLAT/
        tar_gz      516028  R1.tar.gz
        txt            202  R1.txt
        tar_gz        9635  R2.tar.gz
        txt            105  R2.txt
        folder           0  R3/
      folder           0  3-ALIGN_SAM/
        tar_gz      990399  storedCounts.tar.gz
      folder           0  4-ASSEMBLE_SSW/
        unspecified  1126427  F1-A_HA_H5.bam
        unspecified     1717  F1-A_HA_H5.ref
        unspecified  6509062  F1-A_MP.bam
        unspecified      989  F1-A_MP.ref
        unspecified  1904196  F1-A_NA_N1.bam
        unspecified     1423  F1-A_NA_N1.ref
        unspecified  2914333  F1-A_NP.bam
        unspecified     1504  F1-A_NP.ref
        unspecified  5083426  F1-A_NS.bam
        unspecified      845  F1-A_NS.ref
        unspecified   920223  F1-A_PA.bam
        unspecified     2158  F1-A_PA.ref
        unspecified   720035  F1-A_PB1.bam
        unspecified     2282  F1-A_PB1.ref
        unspecified   977175  F1-A_PB2.bam
        unspecified     2288  F1-A_PB2.ref
        unspecified  1110430  F2-A_HA_H5.bam
        unspecified     1714  F2-A_HA_H5.ref
        unspecified  6507917  F2-A_MP.bam
        unspecified      989  F2-A_MP.ref
        unspecified  1870635  F2-A_NA_N1.bam
        unspecified     1420  F2-A_NA_N1.ref
        unspecified  2914473  F2-A_NP.bam
        unspecified     1504  F2-A_NP.ref
        unspecified  5083500  F2-A_NS.bam
        unspecified      845  F2-A_NS.ref
        unspecified   920533  F2-A_PA.bam
        unspecified     2158  F2-A_PA.ref
        unspecified   720133  F2-A_PB1.bam
        unspecified     2282  F2-A_PB1.ref
        unspecified   978217  F2-A_PB2.bam
        unspecified     2288  F2-A_PB2.ref
        unspecified  1108937  F3-A_HA_H5.bam
        unspecified     1714  F3-A_HA_H5.ref
        unspecified  1870253  F3-A_NA_N1.bam
        unspecified     1420  F3-A_NA_N1.ref
        tar_gz    15600040  reads.tar.gz
    folder           0  logs/
      txt           1601  ASSEMBLY_log.txt
      unspecified     5230  FLU-irma.sh
      txt           1400  NR_COUNTS_log.txt
      txt          16620  QC_log.txt
      txt            581  READ_log.txt
      txt           2893  run_info.txt
    folder           0  matrices/
    folder           0  secondary/
      reads          340  R1-A_HA_H2.fa
      reads         7491  R1-A_NA_N4.fa
      reads          168  R1-A_NA_N5.fa
      reads          510  R1-A_NA_N8.fa
      reads          171  R1-B_PB1.fa
      tar_gz      276649  unmatched_read_patterns.tar.gz
    folder           0  tables/
      txt         425378  A_HA_H5-allAlleles.txt
      txt          76846  A_HA_H5-coverage.txt
      txt            164  A_HA_H5-deletions.txt
      txt            132  A_HA_H5-insertions.txt
      txt            199  A_HA_H5-pairingStats.txt
      txt            389  A_HA_H5-variants.txt
      txt         382762  A_MP-allAlleles.txt
      txt          42974  A_MP-coverage.txt
      txt           1194  A_MP-deletions.txt
      txt            549  A_MP-insertions.txt
      txt            201  A_MP-pairingStats.txt
      txt            229  A_MP-variants.txt
      txt         440340  A_NA_N1-allAlleles.txt
      txt          63618  A_NA_N1-coverage.txt
      txt            325  A_NA_N1-deletions.txt
      txt            237  A_NA_N1-insertions.txt
      txt            199  A_NA_N1-pairingStats.txt
      txt            229  A_NA_N1-variants.txt
      txt         483070  A_NP-allAlleles.txt
      txt          63170  A_NP-coverage.txt
      txt            457  A_NP-deletions.txt
      txt            249  A_NP-insertions.txt
      txt            205  A_NP-pairingStats.txt
      txt            229  A_NP-variants.txt
      txt         321529  A_NS-allAlleles.txt
      txt          36673  A_NS-coverage.txt
      txt           1036  A_NS-deletions.txt
      txt            237  A_NS-insertions.txt
      txt            202  A_NS-pairingStats.txt
      txt            229  A_NS-variants.txt
      txt         486807  A_PA-allAlleles.txt
      txt          89655  A_PA-coverage.txt
      txt            237  A_PA-deletions.txt
      txt            367  A_PA-insertions.txt
      txt            184  A_PA-pairingStats.txt
      txt            229  A_PA-variants.txt
      txt         455673  A_PB1-allAlleles.txt
      txt          95398  A_PB1-coverage.txt
      txt            166  A_PB1-deletions.txt
      txt            132  A_PB1-insertions.txt
      txt            224  A_PB1-pairingStats.txt
      txt            229  A_PB1-variants.txt
      txt         516648  A_PB2-allAlleles.txt
      txt          97715  A_PB2-coverage.txt
      txt            240  A_PB2-deletions.txt
      txt            132  A_PB2-insertions.txt
      txt            189  A_PB2-pairingStats.txt
      txt            386  A_PB2-variants.txt
      txt            523  READ_COUNTS.txt
  contigs      13200  out.2026-07-22-12-20-23_all.fasta
  folder           0  quast/
    folder           0  basic_stats/
      unspecified    14225  GC_content_plot.pdf
      unspecified    12659  Nx_plot.pdf
      unspecified    13503  cumulative_plot.pdf
      unspecified    13468  out.2026-07-22-12-20-23_all_GC_content_plot.pdf
    html         53372  icarus.html
    folder           0  icarus_viewers/
      html        780720  contig_size_viewer.html
    unspecified     2497  quast.log
    html        368753  report.html
    unspecified    25448  report.pdf
    unspecified     1183  report.tex
    tsv            490  report.tsv
    txt           1447  report.txt
    unspecified     1016  transposed_report.tex
    tsv            490  transposed_report.tsv
    txt           1021  transposed_report.txt

