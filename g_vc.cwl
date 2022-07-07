class: Workflow
cwlVersion: v1.2
id: >-
  bristol-myers-squibb/integrated-wes-wgs-production-ready-pipelines/germline-calling/6
doc: "**Germline Calling** is workflow made around the **Sentieon Haplotyper** tool. The Haplotyper algorithm performs Haplotype variant calling.\n\nThis pipeline is a part of the project to transfer BMS variant calling procedures from custom bash scripts to the Platform in October 2017. Output files are named with naming patterns mimicking those in the client-produced runs. This pipeline uses commercial Sentieon tools that require a client-specific licence.\n\n*A list of **all inputs and parameters** with corresponding docs can be found at the bottom of the page.*\n\n### Common Use Cases\n\n**Normal BAM file** is used as input and it should be sorted and indexed. This can be done by using the **BAM prep** workflow. The **Input tar with reference** input should contain the reference genome with all necessary indexes. For VCF output that this workflow produces, Variant Calling Metrics are calculated and an annotated VCF file is produced.\n\n### Changes Introduced by Seven Bridges\n\n* Outputs are named by sample IDs e.g.: NormalID.raw.vcf\n\n### Common Issues and Important Notes\n\n* Since Sentieon tools are licenced, errors with the licence will cause the pipeline to fail with an informative error message.\n* More information about Sentieon tools can be found on this [link](https://support.sentieon.com/manual/_downloads/Sentieon.pdf).\n\n### Performance Benchmarking\n\nIn the following table you can find estimates of **Germline Calling** run times and costs. All samples are aligned against **hg19 human reference**. \n\n*Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*\n\n| Threads and CPUs        | Memory          | Input size        | WGS/WES           | Duration       | Cost          | Instance (AWS)  |\n| -------------:|:-------------:| -----:|:-------------:| ------------- | ------------- | ------------- |\n|16|30000| 10.5 GB GB     | WES | 12 minutes| $0.16 |    c4.4xlarge |\n|16|30000| 14.2 GB     | WES | 20 minutes| $0.26 |    c4.4xlarge |\n\n\n### API Python Implementation\n\nThe app's draft task can also be submitted via the **API**. In order to learn how to get your **Authentication token** and **API endpoint** for corresponding platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).\n\n```python\n# Initialize the SBG Python API\nfrom sevenbridges import Api\napi = Api(token=\"enter_your_token\", url=\"enter_api_endpoint\")\n# Get project_id/app_id from your address bar. Example: https://igor.sbgenomics.com/u/your_username/project/app\nproject_id = \"your_username/project\"\napp_id = \"your_username/project/app\"\n# Replace inputs with appropriate values\ninputs = {\n\t\"input_tar_with_reference\": api.files.query(project=project_id, names=[\"enter_filename\"])[0], \n\t\"licsrvr_host_and_port\": \"sevenbridges\", \n\t\"snpeff_database\": api.files.query(project=project_id, names=[\"enter_filename\"])[0], \n\t\"dbsnp_database\": api.files.query(project=project_id, names=[\"enter_filename\"])[0], \n\t\"target_bed\": api.files.query(project=project_id, names=[\"enter_filename\"])[0], \n\t\"input_reads\": api.files.query(project=project_id, names=[\"enter_filename\"])[0], \n\t\"assembly\": \"hg19\"}\n# Creates draft task\ntask = api.tasks.create(name=\"Germline Calling - API Run\", project=project_id, app=app_id, inputs=inputs, run=False)\n```\n\nInstructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [the client documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).\n\nAdditionally, [API R](https://github.com/sbg/sevenbridges-r) client is available. To learn more about using this API client please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/)."
label: Germline Calling
$namespaces:
  sbg: 'https://sevenbridges.com'
inputs:
  - id: licsrvr_host_and_port
    type: string
    label: License server host and port
    doc: >-
      License server host and port in the format (HOST:PORT) (parentheses
      omitted).
    'sbg:x': -657
    'sbg:y': -478
  - id: input_reads
    'sbg:fileTypes': BAM
    type: File
    label: Input reads
    doc: Input aligned reads in BAM format.
    secondaryFiles:
      - pattern: .bai
        required: true
    'sbg:x': -645.11767578125
    'sbg:y': -107.64787292480469
  - id: snpeff_database
    'sbg:fileTypes': ZIP
    type: File
    label: SnpEff database file
    doc: >-
      SnpEff database file is zip archive that can be downloaded from the SnpEff
      official site, or using the SnpEff download app.
    'sbg:x': -649.2353515625
    'sbg:y': -303.32061767578125
  - id: dbsnp_database
    'sbg:fileTypes': VCF.GZ
    type: File
    label: Database dbSNP
    doc: dbSNP database containing known variants.
    secondaryFiles:
      - pattern: .tbi
        required: false
      - pattern: .idx
        required: false
    'sbg:x': -646.676513671875
    'sbg:y': 23.05811309814453
  - id: target_bed
    'sbg:fileTypes': BED
    type: File?
    label: Target BED
    doc: Target BED with regions of interest.
    'sbg:x': -643.558837890625
    'sbg:y': 491.14715576171875
  - id: in_reference
    'sbg:fileTypes': 'FASTA, FA'
    type: File
    label: Reference
    doc: Reference Genome in FASTA format.
    secondaryFiles:
      - pattern: .fai
        required: true
    'sbg:x': -637.0294799804688
    'sbg:y': 175.49928283691406
  - id: ancestry_resources_files
    'sbg:fileTypes': TAR
    type: File?
    label: Ancestry Admixture resources files
    doc: >-
      TAR archive with the directory containing resources required to run the
      pipeline:

      1. Autosomal_SNP_list_only_rs_v2.txt (2 columns (rsID\trsID) for the
      Ancestry Informative Markers - AIMs)

      2. PAP.bed, PAP.bim, PAP.fam (genotypes of hypothetical/putative ancestral
      population)

      3. snp151Commonhg19.bed OR snp151Commonhg19.bed (dbSNP151 table, hg19 or
      hg38, rsID mappings to chr, start, end, only SNPs)

      4. template_merge.pop (template required for running ADMIXTURE program)
    'sbg:x': -641.558837890625
    'sbg:y': 336.3529968261719
outputs:
  - id: raw_vcf
    outputSource:
      - bms_rename_app_raw_vcf/out_file
    'sbg:fileTypes': VCF
    type: File
    label: Raw VCF
    doc: Renamed output file.
    secondaryFiles:
      - pattern: .tbi
        required: false
    'sbg:x': 1016.784423828125
    'sbg:y': -376.4706726074219
  - id: annotated_vcf
    outputSource:
      - bms_rename_app_snpeff_annotated_vcf/out_file
    'sbg:fileTypes': VCF
    type: File
    label: SnpEff Annotated VCF
    doc: Renamed output file.
    secondaryFiles:
      - pattern: .tbi
        required: false
    'sbg:x': 1028.490478515625
    'sbg:y': -32.61084747314453
  - id: raw_gvcf
    outputSource:
      - bms_rename_app/out_file
    'sbg:fileTypes': 'VCF, VCF.GZ'
    type: File
    label: Raw gVCF
    doc: Raw compressed gVCF.
    secondaryFiles:
      - pattern: .tbi
        required: false
    'sbg:x': 1025.2427978515625
    'sbg:y': 311.11431884765625
  - id: admixture_proportions_with_pedigree_info
    outputSource:
      - ancestry_admixture_pipeline/admixture_proportions_with_pedigree_info
    'sbg:fileTypes': ADMIXTURE.PEDIGREE.TXT
    type: File
    label: Admixture proportions with pedigree info
    doc: Admixture proportions with pedigree info report file.
    'sbg:x': 1028.5299072265625
    'sbg:y': 145.1833038330078
steps:
  - id: sample_from_file
    in:
      - id: in_file
        linkMerge: merge_flattened
        source:
          - input_reads
    out:
      - id: out_sample_id
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: bristol-myers-squibb/iwes-cwltool-validated-pipelines/sample-from-file/0
      baseCommand:
        - echo
        - extracting
        - sample
        - from
        - file
      inputs:
        - id: in_file
          type: 'File[]'
          label: Input file
          doc: Input file with metadata.
      outputs:
        - id: out_sample_id
          doc: Metadata field from input file.
          label: Metadata field from input file
          type: string
          outputBinding:
            outputEval: |-
              ${
                  var file = [].concat(inputs.in_file)[0];
                  if (file.metadata){
                      if (file.metadata['sample_id']){
                          var file_name = file.metadata['sample_id'];
                      } else {
                          var file_name = file.nameroot;
                          if (file_name.includes('-')){
                              var file_name = file_name.split('-').slice(0)[0];
                          }
                      }
                  } else {
                      var file_name = file.nameroot;
                      if (file_name.includes('-')){
                          var file_name = file_name.split('-').slice(0)[0];
                      }
                  }
                  return file_name;
              }
      label: Sample from file
      requirements:
        - class: ResourceRequirement
          ramMin: 1000
          coresMin: 1
        - class: DockerRequirement
          dockerPull: 'bms-images.sbgenomics.com/bristol-myers-squibb/ubuntu:20.04'
        - class: InlineJavascriptRequirement
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145231
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:appVersion':
        - v1.2
      'sbg:id': bristol-myers-squibb/iwes-cwltool-validated-pipelines/sample-from-file/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145231
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145231
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': a62a80496bb1b98d8e413ff13b1f2b5f2b999ab32c11cf21fe5e4478d6467bdeb
    label: Sample from file
    'sbg:x': -66
    'sbg:y': -359.8439636230469
  - id: bms_rename_app_raw_vcf
    in:
      - id: suffix_string
        default: .HC.vcf.gz
      - id: first_part_of_string
        source: sample_from_file/out_sample_id
      - id: in_file
        source: haplotypecaller_genotyping/output
    out:
      - id: out_file
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/bms-rename-app-raw-vcf/0
      baseCommand: []
      inputs:
        - 'sbg:category': Name inputs
          id: suffix_string
          type: string?
          label: Suffix String
          doc: Tool string in desired format with extension.
        - 'sbg:category': Name inputs
          'sbg:toolDefaultValue': None
          id: second_part_of_string
          type: string?
          label: String 2
          doc: Second part of the output name. Overrides the input file.
        - 'sbg:category': Name inputs
          id: first_part_of_string
          type: string?
          label: String 1
          doc: First part of the output name. Overrides the input file.
        - 'sbg:stageInput': link
          'sbg:category': File Inputs
          id: in_file
          type: File
          inputBinding:
            shellQuote: false
            position: 1
            'sbg:cmdInclude': true
          label: Input file
          doc: Input file.
        - 'sbg:category': Name inputs
          id: second_part_of_string_file
          type: File?
          label: File - second part of name string
          doc: >-
            File whose name shall be used for the second part of the output
            name.
        - 'sbg:category': Name inputs
          id: first_part_of_string_file
          type: File?
          label: File - first part of name string
          doc: File whose name shall be used for the first part of the output name.
      outputs:
        - id: out_file
          doc: Renamed output file.
          label: Output file
          type: File
          outputBinding:
            glob: |-
              ${
                  if (inputs.first_part_of_string) {
                      var first = inputs.first_part_of_string;
                  } else {
                      if (inputs.first_part_of_string_file){
                          var first_input_file = [].concat(inputs.first_part_of_string_file)[0];
                      } else {
                          var first_input_file = [].concat(inputs.in_file)[0];
                      }
                      if (first_input_file.metadata){
                          if (first_input_file.metadata['sample_id']){
                              var first = first_input_file.metadata['sample_id'];
                          } else {
                              var first = first_input_file.nameroot.split('.')[0];
                          }
                      } else {
                          var first = first_input_file.nameroot.split('.')[0];
                      }
                  }
                  var junct = '-';
                  
                  if (inputs.second_part_of_string) {
                      var second = inputs.second_part_of_string;
                  } else if (inputs.second_part_of_string_file){
                      var second_input_file = [].concat(inputs.second_part_of_string_file)[0];
                      if (second_input_file.metadata){
                          if (second_input_file.metadata['sample_id']){
                              var second = second_input_file.metadata['sample_id'];
                          } else {
                              var second = second_input_file.nameroot.split('.')[0];
                          }
                      } else {
                          var second = second_input_file.nameroot.split('.')[0];
                      }
                  } else {
                      junct = '';
                      var second = '';
                  }
                  if (inputs.suffix_string) {
                      var last = inputs.suffix_string;
                  } else {
                      var last = '';
                  }
                  return  first + junct + second + last;
              }
            outputEval: '$(inheritMetadata(self, inputs.in_file))'
          secondaryFiles:
            - pattern: .bai
              required: false
            - pattern: ^.bai
              required: false
            - pattern: .fai
              required: false
            - pattern: ^.fai
              required: false
            - pattern: .dict
              required: false
            - pattern: ^.dict
              required: false
            - pattern: .idx
              required: false
            - pattern: ^.idx
              required: false
            - pattern: .tbi
              required: false
            - pattern: ^.tbi
              required: false
            - pattern: .csi
              required: false
            - pattern: ^.csi
              required: false
      label: BMS Rename App
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: |-
            ${
              if (inputs.in_file) {
                return 'cp';
              } else {
                return 'echo NO input given, skipping... #';
              }
            }
        - prefix: ''
          shellQuote: false
          position: 10
          valueFrom: |-
            ${
                if (inputs.first_part_of_string) {
                    var first = inputs.first_part_of_string;
                } else {
                    if (inputs.first_part_of_string_file){
                        var first_input_file = [].concat(inputs.first_part_of_string_file)[0];
                    } else {
                        var first_input_file = [].concat(inputs.in_file)[0];
                    }
                    if (first_input_file.metadata){
                        if (first_input_file.metadata['sample_id']){
                            var first = first_input_file.metadata['sample_id'];
                        } else {
                            var first = first_input_file.nameroot.split('.')[0];
                        }
                    } else {
                        var first = first_input_file.nameroot.split('.')[0];
                    }
                }
                var junct = '-';
                
                if (inputs.second_part_of_string) {
                    var second = inputs.second_part_of_string;
                } else if (inputs.second_part_of_string_file){
                    var second_input_file = [].concat(inputs.second_part_of_string_file)[0];
                    if (second_input_file.metadata){
                        if (second_input_file.metadata['sample_id']){
                            var second = second_input_file.metadata['sample_id'];
                        } else {
                            var second = second_input_file.nameroot.split('.')[0];
                        }
                    } else {
                        var second = second_input_file.nameroot.split('.')[0];
                    }
                } else {
                    junct = '';
                    var second = '';
                }
                if (inputs.suffix_string) {
                    var last = inputs.suffix_string;
                } else {
                    var last = '';
                }
                return  first + junct + second + last;
            }
        - prefix: ''
          shellQuote: false
          position: 20
          valueFrom: |-
            ${
                
                if (!inputs.in_file.hasOwnProperty('secondaryFiles')){
                    return "|| : # No secondary files found";
                }
                if (!inputs.in_file.secondaryFiles){
                    return "|| : # No secondary files found";
                }
                
                var secondary_files = [];
                for (var i = 0; i<inputs.in_file.secondaryFiles.length; i++){
                    if (inputs.in_file.secondaryFiles[i]){
                        secondary_files.push(inputs.in_file.secondaryFiles[i]);
                    }
                }
                
                var new_basename = "";
                
                if (inputs.in_file){
                    var original_main = [].concat(inputs.in_file)[0];
                    var lom = original_main.path.length;
                    
                    if (inputs.first_part_of_string){
                        var first = inputs.first_part_of_string;
                    } else if (inputs.first_part_of_string_file){
                        var first = [].concat(inputs.first_part_of_string_file)[0].nameroot.split('.')[0];
                    } else if (inputs.in_file.hasOwnProperty('metadata') && inputs.in_file.metadata){
                        if (inputs.input_file.metadata['sample_id']){
                            var first = inputs.in_file.metadata['sample_id'];
                        }
                    }
                    junct = '-';
                    if (inputs.second_part_of_string) {
                        var second = inputs.second_part_of_string;
                    } else if (inputs.second_part_of_string_file) {
                        var second = [].concat(inputs.second_part_of_string_file)[0].basename.split('.')[0];
                    } else {
                        var second = '';
                        var junct = '';
                    }

                    if (inputs.suffix_string) {
                        var last = inputs.suffix_string;
                    } else {
                        var last = '';
                    }
                    new_basename = first + junct + second + last;
                }
                var cmds = [];
                for (var i=0; i < secondary_files.length; i++) {
                    var sf = secondary_files[i];
                    var basename = new_basename;
                    var ext = "";
                    for (var j=0; j < original_main.basename.length; j++){
                        if (original_main.basename[j] != sf.basename[j]){
                            var l = original_main.basename.length - j
                            basename = new_basename.slice(0, -l)
                            ext = sf.basename.slice(j)
                            break;
                        }
                    }
                    if (!ext){
                        ext = sf.basename.split(original_main.basename).pop()
                    }
                    
                    if (ext){
                        cmds.push("&& cp ".concat(sf.path, " ", basename, ext));
                    }
                }
                return cmds.join(" ");
            }
      requirements:
        - class: ShellCommandRequirement
        - class: ResourceRequirement
          ramMin: 1000
          coresMin: 1
        - class: DockerRequirement
          dockerPull: 'bms-images.sbgenomics.com/bristol-myers-squibb/ubuntu:20.04'
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file)) {
                      file['metadata'] = {}
                  }
                  for (var key in metadata) {
                      file['metadata'][key] = metadata[key];
                  }
                  return file
              };
              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!o2) {
                      return o1;
                  };
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                      for (var key in commonMetadata) {
                          if (!(key in example)) {
                              delete commonMetadata[key]
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145232
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:appVersion':
        - v1.2
      'sbg:id': >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/bms-rename-app-raw-vcf/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145232
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145232
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': ae7e3182c2c69c931a451b1260d7e1e222f8fcb82bc614e798a069d2f83080155
    label: BMS Rename App (Raw VCF)
    'sbg:x': 652.5296630859375
    'sbg:y': -379.02947998046875
  - id: bms_rename_app_snpeff_annotated_vcf
    in:
      - id: suffix_string
        default: .snpEff.vcf
      - id: first_part_of_string
        source: sample_from_file/out_sample_id
      - id: in_file
        source: effect/AnnotatedEFFVCF
    out:
      - id: out_file
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/bms-rename-app-raw-vcf/0
      baseCommand: []
      inputs:
        - 'sbg:category': Name inputs
          id: suffix_string
          type: string?
          label: Suffix String
          doc: Tool string in desired format with extension.
        - 'sbg:category': Name inputs
          'sbg:toolDefaultValue': None
          id: second_part_of_string
          type: string?
          label: String 2
          doc: Second part of the output name. Overrides the input file.
        - 'sbg:category': Name inputs
          id: first_part_of_string
          type: string?
          label: String 1
          doc: First part of the output name. Overrides the input file.
        - 'sbg:stageInput': link
          'sbg:category': File Inputs
          id: in_file
          type: File
          inputBinding:
            shellQuote: false
            position: 1
            'sbg:cmdInclude': true
          label: Input file
          doc: Input file.
        - 'sbg:category': Name inputs
          id: second_part_of_string_file
          type: File?
          label: File - second part of name string
          doc: >-
            File whose name shall be used for the second part of the output
            name.
        - 'sbg:category': Name inputs
          id: first_part_of_string_file
          type: File?
          label: File - first part of name string
          doc: File whose name shall be used for the first part of the output name.
      outputs:
        - id: out_file
          doc: Renamed output file.
          label: Output file
          type: File
          outputBinding:
            glob: |-
              ${
                  if (inputs.first_part_of_string) {
                      var first = inputs.first_part_of_string;
                  } else {
                      if (inputs.first_part_of_string_file){
                          var first_input_file = [].concat(inputs.first_part_of_string_file)[0];
                      } else {
                          var first_input_file = [].concat(inputs.in_file)[0];
                      }
                      if (first_input_file.metadata){
                          if (first_input_file.metadata['sample_id']){
                              var first = first_input_file.metadata['sample_id'];
                          } else {
                              var first = first_input_file.nameroot.split('.')[0];
                          }
                      } else {
                          var first = first_input_file.nameroot.split('.')[0];
                      }
                  }
                  var junct = '-';
                  
                  if (inputs.second_part_of_string) {
                      var second = inputs.second_part_of_string;
                  } else if (inputs.second_part_of_string_file){
                      var second_input_file = [].concat(inputs.second_part_of_string_file)[0];
                      if (second_input_file.metadata){
                          if (second_input_file.metadata['sample_id']){
                              var second = second_input_file.metadata['sample_id'];
                          } else {
                              var second = second_input_file.nameroot.split('.')[0];
                          }
                      } else {
                          var second = second_input_file.nameroot.split('.')[0];
                      }
                  } else {
                      junct = '';
                      var second = '';
                  }
                  if (inputs.suffix_string) {
                      var last = inputs.suffix_string;
                  } else {
                      var last = '';
                  }
                  return  first + junct + second + last;
              }
            outputEval: '$(inheritMetadata(self, inputs.in_file))'
          secondaryFiles:
            - pattern: .bai
              required: false
            - pattern: ^.bai
              required: false
            - pattern: .fai
              required: false
            - pattern: ^.fai
              required: false
            - pattern: .dict
              required: false
            - pattern: ^.dict
              required: false
            - pattern: .idx
              required: false
            - pattern: ^.idx
              required: false
            - pattern: .tbi
              required: false
            - pattern: ^.tbi
              required: false
            - pattern: .csi
              required: false
            - pattern: ^.csi
              required: false
      label: BMS Rename App
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: |-
            ${
              if (inputs.in_file) {
                return 'cp';
              } else {
                return 'echo NO input given, skipping... #';
              }
            }
        - prefix: ''
          shellQuote: false
          position: 10
          valueFrom: |-
            ${
                if (inputs.first_part_of_string) {
                    var first = inputs.first_part_of_string;
                } else {
                    if (inputs.first_part_of_string_file){
                        var first_input_file = [].concat(inputs.first_part_of_string_file)[0];
                    } else {
                        var first_input_file = [].concat(inputs.in_file)[0];
                    }
                    if (first_input_file.metadata){
                        if (first_input_file.metadata['sample_id']){
                            var first = first_input_file.metadata['sample_id'];
                        } else {
                            var first = first_input_file.nameroot.split('.')[0];
                        }
                    } else {
                        var first = first_input_file.nameroot.split('.')[0];
                    }
                }
                var junct = '-';
                
                if (inputs.second_part_of_string) {
                    var second = inputs.second_part_of_string;
                } else if (inputs.second_part_of_string_file){
                    var second_input_file = [].concat(inputs.second_part_of_string_file)[0];
                    if (second_input_file.metadata){
                        if (second_input_file.metadata['sample_id']){
                            var second = second_input_file.metadata['sample_id'];
                        } else {
                            var second = second_input_file.nameroot.split('.')[0];
                        }
                    } else {
                        var second = second_input_file.nameroot.split('.')[0];
                    }
                } else {
                    junct = '';
                    var second = '';
                }
                if (inputs.suffix_string) {
                    var last = inputs.suffix_string;
                } else {
                    var last = '';
                }
                return  first + junct + second + last;
            }
        - prefix: ''
          shellQuote: false
          position: 20
          valueFrom: |-
            ${
                
                if (!inputs.in_file.hasOwnProperty('secondaryFiles')){
                    return "|| : # No secondary files found";
                }
                if (!inputs.in_file.secondaryFiles){
                    return "|| : # No secondary files found";
                }
                
                var secondary_files = [];
                for (var i = 0; i<inputs.in_file.secondaryFiles.length; i++){
                    if (inputs.in_file.secondaryFiles[i]){
                        secondary_files.push(inputs.in_file.secondaryFiles[i]);
                    }
                }
                
                var new_basename = "";
                
                if (inputs.in_file){
                    var original_main = [].concat(inputs.in_file)[0];
                    var lom = original_main.path.length;
                    
                    if (inputs.first_part_of_string){
                        var first = inputs.first_part_of_string;
                    } else if (inputs.first_part_of_string_file){
                        var first = [].concat(inputs.first_part_of_string_file)[0].nameroot.split('.')[0];
                    } else if (inputs.in_file.hasOwnProperty('metadata') && inputs.in_file.metadata){
                        if (inputs.input_file.metadata['sample_id']){
                            var first = inputs.in_file.metadata['sample_id'];
                        }
                    }
                    junct = '-';
                    if (inputs.second_part_of_string) {
                        var second = inputs.second_part_of_string;
                    } else if (inputs.second_part_of_string_file) {
                        var second = [].concat(inputs.second_part_of_string_file)[0].basename.split('.')[0];
                    } else {
                        var second = '';
                        var junct = '';
                    }

                    if (inputs.suffix_string) {
                        var last = inputs.suffix_string;
                    } else {
                        var last = '';
                    }
                    new_basename = first + junct + second + last;
                }
                var cmds = [];
                for (var i=0; i < secondary_files.length; i++) {
                    var sf = secondary_files[i];
                    var basename = new_basename;
                    var ext = "";
                    for (var j=0; j < original_main.basename.length; j++){
                        if (original_main.basename[j] != sf.basename[j]){
                            var l = original_main.basename.length - j
                            basename = new_basename.slice(0, -l)
                            ext = sf.basename.slice(j)
                            break;
                        }
                    }
                    if (!ext){
                        ext = sf.basename.split(original_main.basename).pop()
                    }
                    
                    if (ext){
                        cmds.push("&& cp ".concat(sf.path, " ", basename, ext));
                    }
                }
                return cmds.join(" ");
            }
      requirements:
        - class: ShellCommandRequirement
        - class: ResourceRequirement
          ramMin: 1000
          coresMin: 1
        - class: DockerRequirement
          dockerPull: 'bms-images.sbgenomics.com/bristol-myers-squibb/ubuntu:20.04'
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file)) {
                      file['metadata'] = {}
                  }
                  for (var key in metadata) {
                      file['metadata'][key] = metadata[key];
                  }
                  return file
              };
              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!o2) {
                      return o1;
                  };
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                      for (var key in commonMetadata) {
                          if (!(key in example)) {
                              delete commonMetadata[key]
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145232
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:appVersion':
        - v1.2
      'sbg:id': >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/bms-rename-app-raw-vcf/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145232
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145232
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': ae7e3182c2c69c931a451b1260d7e1e222f8fcb82bc614e798a069d2f83080155
    label: BMS Rename App (SnpEff Annotated VCF)
    'sbg:x': 656.9412841796875
    'sbg:y': -28.4411678314209
  - id: sbg_prepare_intervals
    in:
      - id: bed_file
        source: target_bed
      - id: split_mode
        default: File per chr with alt contig in a single file
      - id: format
        default: chr start end
    out:
      - id: intervals
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/sbg-prepare-intervals/0
      baseCommand:
        - python
        - sbg_prepare_intervals.py
      inputs:
        - 'sbg:category': File Inputs
          id: bed_file
          type: File?
          inputBinding:
            prefix: '--bed'
            shellQuote: false
            position: 1
          label: Input BED file
          doc: Input BED file containing intervals. Required for modes 3 and 4.
          'sbg:fileTypes': BED
        - 'sbg:category': File Input
          id: fai_file
          type: File?
          inputBinding:
            prefix: '--fai'
            shellQuote: false
            position: 2
            valueFrom: |-
              ${
                  self = [].concat(self)[0];
                  if (self.nameext == '.fa' || self.nameext == '.fasta'){
                      if (self.hasOwnProperty('secondaryFiles')){
                          for (var i = 0; i<self.secondaryFiles.length; i++){
                              if (self.secondaryFiles[i].nameext == '.fai'){
                                  return self.secondaryFiles[i].path;
                              }
                          }
                      }
                  }
                  return self.path;
              }
          label: Input FAI file
          doc: FAI file is converted to BED format if BED file is not provided.
          'sbg:fileTypes': 'FAI, FASTA'
          secondaryFiles:
            - pattern: |-
                ${
                    if (self.nameext == ".fa" || self.nameext == ".fasta"){
                        return self.basename + ".fai";
                    }
                    return "";
                }
              required: true
        - 'sbg:category': Config inputs
          id: split_mode
          type:
            - 'null'
            - type: enum
              symbols:
                - File per interval
                - File per chr with alt contig in a single file
                - Output original BED
                - File per interval with alt contig in a single file
              name: split_mode
          inputBinding:
            prefix: '--mode'
            shellQuote: false
            position: 3
            valueFrom: |-
              ${
                var mode = inputs.split_mode;
                switch (mode){
                  case "File per interval": 
                    return 1
                  case "File per chr with alt contig in a single file": 
                    return 2
                  case "Output original BED": 
                    return 3
                  case "File per interval with alt contig in a single file": 
                    return 4  
                }
                return 3
              }
          label: Split mode
          doc: >-
            Depending on selected Split Mode value, output files are generated
            in accordance with description below: 1. File per interval - The
            tool creates one interval file per line of the input BED(FAI) file.
            Each interval file contains a single line (one of the lines of
            BED(FAI) input file).  2. File per chr with alt contig in a single
            file - For each contig(chromosome) a single file is created
            containing all the intervals corresponding to it . All the intervals
            (lines) other than (chr1, chr2 ... chrY or 1, 2 ... Y) are saved as
            ("others.bed").  3. Output original BED - BED file is required for
            execution of this mode. If mode 3 is applied input is passed to the
            output.  4. File per interval with alt contig in a single file - For
            each chromosome a single file is created for each interval. All the
            intervals (lines) other than (chr1, chr2 ... chrY or 1, 2 ... Y) are
            saved as ("others.bed"). NOTE: Do not use option 1 (File per
            interval) with exome BED or a BED with a lot of GL contigs, as it
            will create a large number of files.
        - 'sbg:category': Config inputs
          id: format
          type:
            - 'null'
            - type: enum
              symbols:
                - chr start end
                - 'chr:start-end'
              name: format
          label: Interval format
          doc: Format of the intervals in the generated files.
      outputs:
        - id: intervals
          doc: Array of BED files generated as per selected Split Mode.
          label: Intervals
          type: 'File[]?'
          outputBinding:
            glob: Intervals/*.bed
          'sbg:fileTypes': BED
      doc: >-
        Depending on selected Split Mode value, output files are generated in
        accordance with description below: 


        1. File per interval - The tool creates one interval file per line of
        the input BED(FAI) file.

        Each interval file contains a single line (one of the lines of BED(FAI)
        input file).


        2. File per chr with alt contig in a single file - For each
        contig(chromosome) a single file

        is created containing all the intervals corresponding to it .

        All the intervals (lines) other than (chr1, chr2 ... chrY or 1, 2 ... Y)
        are saved as

        ("others.bed").


        3. Output original BED - BED file is required for execution of this
        mode. If mode 3 is applied input is passed to the output.


        4. File per interval with alt contig in a single file - For each
        chromosome a single file is created for each interval.

        All the intervals (lines) other than (chr1, chr2 ... chrY or 1, 2 ... Y)
        are saved as

        ("others.bed").


        ##### Common issues: 

        Do not use option 1 (File per interval) with exome BED or a BED with a
        lot of GL contigs, as it will create a large number of files.
      label: SBG Prepare Intervals
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: |-
            ${
                if (inputs.format){
                    return '--format ' + '"' + inputs.format + '"';
                }
                return "";
            }
      requirements:
        - class: ShellCommandRequirement
        - class: ResourceRequirement
          ramMin: 1000
          coresMin: 1
        - class: DockerRequirement
          dockerPull: 'images.sbgenomics.com/bogdang/sbg_prepare_intervals:1.0'
        - class: InitialWorkDirRequirement
          listing:
            - entryname: sbg_prepare_intervals.py
              entry: >-
                """

                Usage:
                    sbg_prepare_intervals.py [options] [--fastq FILE --bed FILE --mode INT --format STR --others STR]

                Description:
                    Purpose of this tool is to split BED file into files based on the selected mode.
                    If bed file is not provided fai(fasta index) file is converted to bed.

                Options:

                    -h, --help            Show this message.

                    -v, -V, --version     Tool version.

                    -b, -B, --bed FILE    Path to input bed file.

                    --fai FILE            Path to input fai file.

                    --format STR          Output file format.

                    --mode INT            Select input mode.
                """



                import os

                import sys

                import glob

                import shutil

                from docopt import docopt


                default_extension = '.bed'  # for output files



                def create_file(contents, contig_name,
                extension=default_extension):
                    """function for creating a file for all intervals in a contig"""

                    new_file = open("Intervals/" + contig_name + extension, "w")
                    new_file.write(contents)
                    new_file.close()


                def add_to_file(line, name, extension=default_extension):
                    """function for adding a line to a file"""

                    new_file = open("Intervals/" + name + extension, "a")
                    if lformat == formats[1]:
                        sep = line.split("\t")
                        line = sep[0] + ":" + sep[1] + "-" + sep[2]
                    new_file.write(line)
                    new_file.close()


                def fai2bed(fai):
                    """function to create a bed file from fai file"""

                    region_thr = 10000000  # threshold used to determine starting point accounting for telomeres in chromosomes
                    basename = fai[0:fai.rfind(".")]
                    with open(fai, "r") as ins:
                        new_array = []
                        for line in ins:
                            len_reg = int(line.split()[1])
                            cutoff = 0 if (
                            len_reg < region_thr) else 0  # sd\\telomeres or start with 1
                            new_line = line.split()[0] + '\t' + str(cutoff) + '\t' + str(
                                len_reg + cutoff)
                            new_array.append(new_line)
                    new_file = open(basename + ".bed", "w")
                    new_file.write("\n".join(new_array))
                    return basename + ".bed"


                def chr_intervals(no_of_chrms=23):
                    """returns all possible designations for chromosome intervals"""

                    chrms = []
                    for i in range(1, no_of_chrms):
                        chrms.append("chr" + str(i))
                        chrms.append(str(i))
                    chrms.extend(["x", "y", "chrx", "chry"])
                    return chrms


                def mode_1(orig_file):
                    """mode 1: every line is a new file"""

                    with open(orig_file, "r") as ins:
                        prev = ""
                        counter = 0
                        names = []
                        for line in ins:
                            if is_header(line):
                                continue
                            if line.split()[0] == prev:
                                counter += 1
                            else:
                                counter = 0
                            suffix = "" if (counter == 0) else "_" + str(counter)
                            create_file(line, line.split()[0] + suffix)
                            names.append(line.split()[0] + suffix)
                            prev = line.split()[0]

                        create_file(str(names), "names", extension=".txt")


                def mode_2(orig_file, others_name):
                    """mode 2: separate file is created for each chromosome, and one file is created for other intervals"""

                    chrms = chr_intervals()
                    names = []

                    with open(orig_file, 'r') as ins:
                        for line in ins:
                            if is_header(line):
                                continue
                            name = line.split()[0]
                            if name.lower() in chrms:
                                name = name
                            else:
                                name = others_name
                            try:
                                add_to_file(line, name)
                                if not name in names:
                                    names.append(name)
                            except:
                                raise Exception(
                                    "Couldn't create or write in the file in mode 2")

                        create_file(str(names), "names", extension=".txt")


                def mode_3(orig_file, extension=default_extension):
                    """mode 3: input file is staged to output"""

                    orig_name = orig_file.split("/")[len(orig_file.split("/")) - 1]
                    output_file = r"./Intervals/" + orig_name[
                                                    0:orig_name.rfind('.')] + extension

                    shutil.copyfile(orig_file, output_file)

                    names = [orig_name[0:orig_name.rfind('.')]]
                    create_file(str(names), "names", extension=".txt")


                def mode_4(orig_file, others_name):
                    """mode 4: every interval in chromosomes is in a separate file. Other intervals are in a single file"""

                    chrms = chr_intervals()
                    names = []

                    with open(orig_file, "r") as ins:
                        counter = {}
                        for line in ins:
                            if line.startswith('@'):
                                continue
                            name = line.split()[0].lower()
                            if name in chrms:
                                if name in counter:
                                    counter[name] += 1
                                else:
                                    counter[name] = 0
                                suffix = "" if (counter[name] == 0) else "_" + str(counter[name])
                                create_file(line, name + suffix)
                                names.append(name + suffix)
                                prev = name
                            else:
                                name = others_name
                                if not name in names:
                                    names.append(name)
                                try:
                                    add_to_file(line, name)
                                except:
                                    raise Exception(
                                        "Couldn't create or write in the file in mode 4")

                    create_file(str(names), "names", extension=".txt")


                def prepare_intervals():
                    # reading input files and split mode from command line
                    args = docopt(__doc__, version='1.0')

                    bed_file = args['--bed']
                    fai_file = args['--fai']
                    split_mode = int(args['--mode'])

                    # define file name for non-chromosomal contigs
                    others_name = 'others'

                    global formats, lformat
                    formats = ["chr start end", "chr:start-end"]
                    lformat = args['--format']
                    if lformat == None:
                        lformat = formats[0]
                    if not lformat in formats:
                        raise Exception('Unsuported interval format')

                    if not os.path.exists(r"./Intervals"):
                        os.mkdir(r"./Intervals")
                    else:
                        files = glob.glob(r"./Intervals/*")
                        for f in files:
                            os.remove(f)

                    # create variable input_file taking bed_file as priority
                    if bed_file:
                        input_file = bed_file
                    elif fai_file:
                        input_file = fai2bed(fai_file)
                    else:
                        raise Exception('No input files are provided')

                    # calling adequate split mode function
                    if split_mode == 1:
                        mode_1(input_file)
                    elif split_mode == 2:
                        mode_2(input_file, others_name)
                    elif split_mode == 3:
                        if bed_file:
                            mode_3(input_file)
                        else:
                            raise Exception('Bed file is required for mode 3')
                    elif split_mode == 4:
                        mode_4(input_file, others_name)
                    else:
                        raise Exception('Split mode value is not set')


                def is_header(line):
                    x = line.split('\t')
                    try:
                        int(x[1])
                        int(x[2])
                        header = False
                    except:
                        sys.stderr.write('Line is skipped: {}'.format(line))
                        header = True
                    return header


                if __name__ == '__main__':
                    prepare_intervals()
              writable: false
        - class: InlineJavascriptRequirement
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145233
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:toolAuthor': Seven Bridges Genomics
      'sbg:license': Apache License 2.0
      'sbg:toolkit': SBGTools
      'sbg:toolkitVersion': '1.0'
      'sbg:categories':
        - Converters
      'sbg:appVersion':
        - v1.2
      'sbg:id': >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/sbg-prepare-intervals/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145233
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145233
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': a1168e2abbbdb701df4dca244ba689d6d58608946fae5417d3912603b41587c04
    label: SBG Prepare Intervals
    'sbg:x': -348.12701416015625
    'sbg:y': 398.2785339355469
  - id: bms_rename_app
    in:
      - id: suffix_string
        default: .HC.g.vcf.gz
      - id: first_part_of_string
        source: sample_from_file/out_sample_id
      - id: in_file
        source: gatk_merge_vcfs/out_variants
    out:
      - id: out_file
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/bms-rename-app-raw-vcf/0
      baseCommand: []
      inputs:
        - 'sbg:category': Name inputs
          id: suffix_string
          type: string?
          label: Suffix String
          doc: Tool string in desired format with extension.
        - 'sbg:category': Name inputs
          'sbg:toolDefaultValue': None
          id: second_part_of_string
          type: string?
          label: String 2
          doc: Second part of the output name. Overrides the input file.
        - 'sbg:category': Name inputs
          id: first_part_of_string
          type: string?
          label: String 1
          doc: First part of the output name. Overrides the input file.
        - 'sbg:stageInput': link
          'sbg:category': File Inputs
          id: in_file
          type: File
          inputBinding:
            shellQuote: false
            position: 1
            'sbg:cmdInclude': true
          label: Input file
          doc: Input file.
        - 'sbg:category': Name inputs
          id: second_part_of_string_file
          type: File?
          label: File - second part of name string
          doc: >-
            File whose name shall be used for the second part of the output
            name.
        - 'sbg:category': Name inputs
          id: first_part_of_string_file
          type: File?
          label: File - first part of name string
          doc: File whose name shall be used for the first part of the output name.
      outputs:
        - id: out_file
          doc: Renamed output file.
          label: Output file
          type: File
          outputBinding:
            glob: |-
              ${
                  if (inputs.first_part_of_string) {
                      var first = inputs.first_part_of_string;
                  } else {
                      if (inputs.first_part_of_string_file){
                          var first_input_file = [].concat(inputs.first_part_of_string_file)[0];
                      } else {
                          var first_input_file = [].concat(inputs.in_file)[0];
                      }
                      if (first_input_file.metadata){
                          if (first_input_file.metadata['sample_id']){
                              var first = first_input_file.metadata['sample_id'];
                          } else {
                              var first = first_input_file.nameroot.split('.')[0];
                          }
                      } else {
                          var first = first_input_file.nameroot.split('.')[0];
                      }
                  }
                  var junct = '-';
                  
                  if (inputs.second_part_of_string) {
                      var second = inputs.second_part_of_string;
                  } else if (inputs.second_part_of_string_file){
                      var second_input_file = [].concat(inputs.second_part_of_string_file)[0];
                      if (second_input_file.metadata){
                          if (second_input_file.metadata['sample_id']){
                              var second = second_input_file.metadata['sample_id'];
                          } else {
                              var second = second_input_file.nameroot.split('.')[0];
                          }
                      } else {
                          var second = second_input_file.nameroot.split('.')[0];
                      }
                  } else {
                      junct = '';
                      var second = '';
                  }
                  if (inputs.suffix_string) {
                      var last = inputs.suffix_string;
                  } else {
                      var last = '';
                  }
                  return  first + junct + second + last;
              }
            outputEval: '$(inheritMetadata(self, inputs.in_file))'
          secondaryFiles:
            - pattern: .bai
              required: false
            - pattern: ^.bai
              required: false
            - pattern: .fai
              required: false
            - pattern: ^.fai
              required: false
            - pattern: .dict
              required: false
            - pattern: ^.dict
              required: false
            - pattern: .idx
              required: false
            - pattern: ^.idx
              required: false
            - pattern: .tbi
              required: false
            - pattern: ^.tbi
              required: false
            - pattern: .csi
              required: false
            - pattern: ^.csi
              required: false
      label: BMS Rename App
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: |-
            ${
              if (inputs.in_file) {
                return 'cp';
              } else {
                return 'echo NO input given, skipping... #';
              }
            }
        - prefix: ''
          shellQuote: false
          position: 10
          valueFrom: |-
            ${
                if (inputs.first_part_of_string) {
                    var first = inputs.first_part_of_string;
                } else {
                    if (inputs.first_part_of_string_file){
                        var first_input_file = [].concat(inputs.first_part_of_string_file)[0];
                    } else {
                        var first_input_file = [].concat(inputs.in_file)[0];
                    }
                    if (first_input_file.metadata){
                        if (first_input_file.metadata['sample_id']){
                            var first = first_input_file.metadata['sample_id'];
                        } else {
                            var first = first_input_file.nameroot.split('.')[0];
                        }
                    } else {
                        var first = first_input_file.nameroot.split('.')[0];
                    }
                }
                var junct = '-';
                
                if (inputs.second_part_of_string) {
                    var second = inputs.second_part_of_string;
                } else if (inputs.second_part_of_string_file){
                    var second_input_file = [].concat(inputs.second_part_of_string_file)[0];
                    if (second_input_file.metadata){
                        if (second_input_file.metadata['sample_id']){
                            var second = second_input_file.metadata['sample_id'];
                        } else {
                            var second = second_input_file.nameroot.split('.')[0];
                        }
                    } else {
                        var second = second_input_file.nameroot.split('.')[0];
                    }
                } else {
                    junct = '';
                    var second = '';
                }
                if (inputs.suffix_string) {
                    var last = inputs.suffix_string;
                } else {
                    var last = '';
                }
                return  first + junct + second + last;
            }
        - prefix: ''
          shellQuote: false
          position: 20
          valueFrom: |-
            ${
                
                if (!inputs.in_file.hasOwnProperty('secondaryFiles')){
                    return "|| : # No secondary files found";
                }
                if (!inputs.in_file.secondaryFiles){
                    return "|| : # No secondary files found";
                }
                
                var secondary_files = [];
                for (var i = 0; i<inputs.in_file.secondaryFiles.length; i++){
                    if (inputs.in_file.secondaryFiles[i]){
                        secondary_files.push(inputs.in_file.secondaryFiles[i]);
                    }
                }
                
                var new_basename = "";
                
                if (inputs.in_file){
                    var original_main = [].concat(inputs.in_file)[0];
                    var lom = original_main.path.length;
                    
                    if (inputs.first_part_of_string){
                        var first = inputs.first_part_of_string;
                    } else if (inputs.first_part_of_string_file){
                        var first = [].concat(inputs.first_part_of_string_file)[0].nameroot.split('.')[0];
                    } else if (inputs.in_file.hasOwnProperty('metadata') && inputs.in_file.metadata){
                        if (inputs.input_file.metadata['sample_id']){
                            var first = inputs.in_file.metadata['sample_id'];
                        }
                    }
                    junct = '-';
                    if (inputs.second_part_of_string) {
                        var second = inputs.second_part_of_string;
                    } else if (inputs.second_part_of_string_file) {
                        var second = [].concat(inputs.second_part_of_string_file)[0].basename.split('.')[0];
                    } else {
                        var second = '';
                        var junct = '';
                    }

                    if (inputs.suffix_string) {
                        var last = inputs.suffix_string;
                    } else {
                        var last = '';
                    }
                    new_basename = first + junct + second + last;
                }
                var cmds = [];
                for (var i=0; i < secondary_files.length; i++) {
                    var sf = secondary_files[i];
                    var basename = new_basename;
                    var ext = "";
                    for (var j=0; j < original_main.basename.length; j++){
                        if (original_main.basename[j] != sf.basename[j]){
                            var l = original_main.basename.length - j
                            basename = new_basename.slice(0, -l)
                            ext = sf.basename.slice(j)
                            break;
                        }
                    }
                    if (!ext){
                        ext = sf.basename.split(original_main.basename).pop()
                    }
                    
                    if (ext){
                        cmds.push("&& cp ".concat(sf.path, " ", basename, ext));
                    }
                }
                return cmds.join(" ");
            }
      requirements:
        - class: ShellCommandRequirement
        - class: ResourceRequirement
          ramMin: 1000
          coresMin: 1
        - class: DockerRequirement
          dockerPull: 'bms-images.sbgenomics.com/bristol-myers-squibb/ubuntu:20.04'
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file)) {
                      file['metadata'] = {}
                  }
                  for (var key in metadata) {
                      file['metadata'][key] = metadata[key];
                  }
                  return file
              };
              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!o2) {
                      return o1;
                  };
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                      for (var key in commonMetadata) {
                          if (!(key in example)) {
                              delete commonMetadata[key]
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145232
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:appVersion':
        - v1.2
      'sbg:id': >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/bms-rename-app-raw-vcf/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145232
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145232
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': ae7e3182c2c69c931a451b1260d7e1e222f8fcb82bc614e798a069d2f83080155
    label: BMS Rename App
    'sbg:x': 658.0885009765625
    'sbg:y': 312.7941589355469
  - id: gatk_merge_vcfs
    in:
      - id: in_variants
        source:
          - haplotypecaller_genotyping_gvcf/output
      - id: output_file_format
        default: vcf.gz
    out:
      - id: out_variants
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: bristol-myers-squibb/iwes-cwltool-validated-pipelines/gatk-merge-vcfs/0
      baseCommand: []
      inputs:
        - 'sbg:altPrefix': '-I'
          'sbg:category': Required Arguments
          id: in_variants
          type: 'File[]'
          inputBinding:
            shellQuote: false
            position: 4
            valueFrom: |-
              ${
                  if (self)
                  {
                      var cmd = [];
                      for (var i = 0; i < self.length; i++) 
                      {
                          cmd.push('--INPUT', self[i].path);
                          
                      }
                      return cmd.join(' ');
                  }
              }
          label: Input variants file
          doc: >-
            VCF or BCF input files (file format is determined by file
            extension).
          'sbg:fileTypes': 'VCF, VCF.GZ, BCF'
          secondaryFiles:
            - pattern: |-
                ${
                    if (self.nameext == ".vcf")
                    {
                        return self.basename + ".idx";
                    }
                    else
                    {
                        return self.basename + ".tbi";
                    }
                }
              required: true
        - 'sbg:category': Optional Arguments
          'sbg:toolDefaultValue': '2'
          id: compression_level
          type: int?
          inputBinding:
            prefix: '--COMPRESSION_LEVEL'
            shellQuote: false
            position: 4
          label: Compression level
          doc: >-
            Compression level for all compressed files created (e.g. BAM and
            VCF).
        - 'sbg:category': Optional Arguments
          'sbg:toolDefaultValue': '500000'
          id: max_records_in_ram
          type: int?
          inputBinding:
            prefix: '--MAX_RECORDS_IN_RAM'
            shellQuote: false
            position: 4
          label: Max records in RAM
          doc: >-
            When writing files that need to be sorted, this will specify the
            number of records stored in RAM before spilling to disk. Increasing
            this number reduces the number of file handles needed to sort the
            file, and increases the amount of RAM needed.
        - 'sbg:category': Platform Options
          id: memory_overhead_per_job
          type: int?
          label: Memory overhead per job
          doc: >-
            This input allows a user to set the desired overhead memory when
            running a tool or adding it to a workflow. This amount will be added
            to the Memory per job in the Memory requirements section but it will
            not be added to the -Xmx parameter leaving some memory not occupied
            which can be used as stack memory (-Xmx parameter defines heap
            memory). This input should be defined in MB (for both the platform
            part and the -Xmx part if Java tool is wrapped).
        - 'sbg:category': Platform Options
          'sbg:toolDefaultValue': 2048 MB
          id: memory_per_job
          type: int?
          label: Memory per job
          doc: >-
            This input allows a user to set the desired memory requirement when
            running a tool or adding it to a workflow. This value should be
            propagated to the -Xmx parameter too.This input should be defined in
            MB (for both the platform part and the -Xmx part if Java tool is
            wrapped).
        - 'sbg:altPrefix': '-D'
          'sbg:category': Optional Arguments
          'sbg:toolDefaultValue': 'null'
          id: sequence_dictionary
          type: File?
          inputBinding:
            prefix: '--SEQUENCE_DICTIONARY'
            shellQuote: false
            position: 4
          label: Sequence dictionary
          doc: >-
            The index sequence dictionary to use instead of the sequence
            dictionary in the input files.
          'sbg:fileTypes': DICT
        - 'sbg:category': Platform options
          'sbg:toolDefaultValue': '1'
          id: cpu_per_job
          type: int?
          label: CPU per job
          doc: >-
            This input allows a user to set the desired CPU requirement when
            running a tool or adding it to a workflow.
        - 'sbg:category': Optional Arguments
          id: output_file_format
          type:
            - 'null'
            - type: enum
              symbols:
                - vcf
                - bcf
                - vcf.gz
              name: output_file_format
          label: Output file format
          doc: Output file format.
        - 'sbg:category': Optional Arguments
          id: output_prefix
          type: string?
          label: Output prefix
          doc: Output file name prefix.
      outputs:
        - id: out_variants
          doc: >-
            The merged VCF or BCF file. File format is determined by file
            extension.
          label: Output merged VCF or BCF file
          type: File?
          outputBinding:
            glob: |-
              ${
                  var in_variants = [].concat(inputs.in_variants);
                  
                  var vcf_count = 0;
                  var vcf_gz_count = 0;
                  var bcf_count = 0;
                  var gvcf_count = 0;
                  var gvcf_gz_count = 0;
                  
                  for (var i = 0; i < in_variants.length; i++)
                  {
                      if (in_variants[i].path.endsWith('vcf') && !(in_variants[i].path.endsWith('g.vcf')) )
                          vcf_count += 1
                      else if (in_variants[i].path.endsWith('vcf.gz') && !(in_variants[i].path.endsWith('g.vcf.gz')))
                          vcf_gz_count += 1
                      else if (in_variants[i].path.endsWith('bcf'))
                          bcf_count += 1
                      else if (in_variants[i].path.endsWith('g.vcf'))
                          gvcf_count += 1
                      else if (in_variants[i].path.endsWith('g.vcf.gz'))
                          gvcf_gz_count += 1
                      
                  }
                  
                  var max_ext = Math.max(vcf_count, vcf_gz_count, bcf_count, gvcf_count, gvcf_gz_count)
                  var most_frequent_ext = (max_ext == vcf_count) ? "vcf" : (max_ext == vcf_gz_count) ? "vcf.gz" : (max_ext == bcf_count) ? "bcf" : (max_ext == gvcf_count) ? "g.vcf" : "g.vcf.gz";
                  var out_format = inputs.output_file_format;
                  var out_ext = "";
                  if (out_format)
                  {
                      out_ext = ((most_frequent_ext == "g.vcf" || most_frequent_ext == "g.vcf.gz") && (out_format == "vcf" || out_format == "vcf.gz")) ? "g." + out_format : ((most_frequent_ext == "g.vcf" || most_frequent_ext == "g.vcf.gz") && (out_format == "bcf" )) ? most_frequent_ext : out_format;   
                  }
                  else
                  {
                      out_ext = most_frequent_ext;
                  }
                  return "*" + out_ext;
                  
              }
            outputEval: '$(inheritMetadata(self, inputs.in_variants))'
          secondaryFiles:
            - pattern: .tbi
              required: false
          'sbg:fileTypes': 'VCF, VCF.GZ, BCF'
      doc: >-
        The **GATK MergeVcfs** tool combines multiple variant files into a
        single variant file. 


        *A list of **all inputs and parameters** with corresponding descriptions
        can be found at the bottom of the page.*


        ###Common Use Cases


        * The **MergeVcfs** tool requires one or more input files in VCF format
        on its **Input variant files** (`--INPUT`) input. The input files can be
        in VCF format (can be gzipped, i.e. ending in ".vcf.gz", or binary
        compressed, i.e. ending in ".bcf"). The tool generates a VCF file on its
        **Output merged VCF or BCF file** output.


        * The **MergeVcfs** tool supports a sequence dictionary file (typically
        name ending in .dict) on its **Sequence dictionary**
        (`--SEQUENCE_DICTIONARY`) input if the input VCF does not contain a
        complete contig list and if the output index is to be created (true by
        default).


        * The output file is sorted (i) according to the dictionary and (ii) by
        coordinate.


        * Usage example:


        ```

        gatk MergeVcfs \
                  --INPUT input_variants.01.vcf \
                  --INPUT input_variants.02.vcf.gz \
                  --OUTPUT output_variants.vcf.gz
        ```


        ###Changes Introduced by Seven Bridges


        * The output file will be prefixed using the **Output prefix**
        parameter. In case **Output prefix** is not provided, the input files
        provided on the **Input variant files** input will be alphabetically
        sorted by name and  output prefix will be equal to the Sample ID
        metadata from the first element from that list, if the Sample ID
        metadata exists. Otherwise, output prefix will be inferred from the
        filename of the first element from this list. Moreover, the number of
        input files will be added after the output prefix as well as the tool
        specific extension which is **merged**. This way, having identical names
        of the output files between runs is avoided.


        * The user has a possibility to specify the output file format using the
        **Output file format** argument. The default output format is "vcf.gz".


        ###Common Issues and Important Notes


        * Note 1: If running this tool on multi-sample input files (originating
        from e.g. some scatter-gather runs), the input files must contain the
        same sample names in the same column order. 


        * Note 2: Input file headers must contain compatible declarations for
        common annotations (INFO, FORMAT fields) and filters.


        * Note 3: Input files variant records must be sorted by their contig and
        position following the sequence dictionary provided or the header contig
        list.


        ###Performance Benchmarking


        This tool is ultra fast, with a running time less than a minute on the
        default AWS c4.2xlarge instance.


        ###References


        [1] [GATK
        MergeVcfs](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_vcf_MergeVcfs.php)
      label: GATK Merge VCFs
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: /opt/gatk
        - shellQuote: false
          position: 1
          valueFrom: '--java-options'
        - prefix: ''
          shellQuote: false
          position: 2
          valueFrom: |-
            ${
                if (inputs.memory_per_job) {
                    return '\"-Xmx'.concat(inputs.memory_per_job, 'M') + '\"';
                }
                return '\"-Xms2000m\"';
            }
        - shellQuote: false
          position: 3
          valueFrom: MergeVcfs
        - prefix: ''
          shellQuote: false
          position: 4
          valueFrom: |-
            ${
                var in_variants = [].concat(inputs.in_variants);
                var output_prefix = "";
                
                var vcf_count = 0;
                var vcf_gz_count = 0;
                var bcf_count = 0;
                var gvcf_count = 0;
                var gvcf_gz_count = 0;
                
                for (var i = 0; i < in_variants.length; i++)
                {
                    if (in_variants[i].path.endsWith('vcf') && !(in_variants[i].path.endsWith('g.vcf')) )
                        vcf_count += 1
                    else if (in_variants[i].path.endsWith('vcf.gz') && !(in_variants[i].path.endsWith('g.vcf.gz')))
                        vcf_gz_count += 1
                    else if (in_variants[i].path.endsWith('bcf'))
                        bcf_count += 1
                    else if (in_variants[i].path.endsWith('g.vcf'))
                        gvcf_count += 1
                    else if (in_variants[i].path.endsWith('g.vcf.gz'))
                        gvcf_gz_count += 1
                    
                }
                
                var max_ext = Math.max(vcf_count, vcf_gz_count, bcf_count, gvcf_count, gvcf_gz_count)
                var most_frequent_ext = (max_ext == vcf_count) ? "vcf" : (max_ext == vcf_gz_count) ? "vcf.gz" : (max_ext == bcf_count) ? "bcf" : (max_ext == gvcf_count) ? "g.vcf" : "g.vcf.gz";
                var out_format = inputs.output_file_format;
                var out_ext = "";
                if (out_format)
                {
                    out_ext = ((most_frequent_ext == "g.vcf" || most_frequent_ext == "g.vcf.gz") && (out_format == "vcf" || out_format == "vcf.gz")) ? "g." + out_format : ((most_frequent_ext == "g.vcf" || most_frequent_ext == "g.vcf.gz") && (out_format == "bcf" )) ? most_frequent_ext : out_format;
                }
                else
                {
                    out_ext = most_frequent_ext;
                }
                
                if (inputs.output_prefix)
                {
                    output_prefix = inputs.output_prefix;
                }
                else
                {
                    if (in_variants.length > 1)
                    {
                        in_variants.sort(function(file1, file2) {
                            var file1_name = file1.basename.toUpperCase();
                            var file2_name = file2.basename.toUpperCase();
                            if (file1_name < file2_name) {
                                return -1;
                            }
                            if (file1_name > file2_name) {
                                return 1;
                            }
                            // names must be equal
                            return 0;
                        });
                    }
                    
                    var in_variants_first =  in_variants[0];
                    if (in_variants_first.metadata && in_variants_first.metadata.sample_id)
                    {
                        output_prefix = in_variants_first.metadata.sample_id;

                    }
                    else
                    {
                        output_prefix = in_variants_first.basename.split('.')[0];
                    }
                    
                    if (in_variants.length > 1)
                    {
                        output_prefix = output_prefix + "." + in_variants.length;
                    }
                }
                
                return "--OUTPUT " + output_prefix + ".merged." + out_ext;
            }
      requirements:
        - class: ShellCommandRequirement
        - class: ResourceRequirement
          ramMin: |-
            ${
                var memory = 3500;
                if (inputs.memory_per_job) 
                {
                    memory = inputs.memory_per_job;
                }
                if (inputs.memory_overhead_per_job)
                {
                    memory += inputs.memory_overhead_per_job;
                }
                return memory;
            }
          coresMin: |-
            ${
                return inputs.cpu_per_job ? inputs.cpu_per_job : 1
            }
        - class: DockerRequirement
          dockerPull: 'bms-images.sbgenomics.com/bristol-myers-squibb/gatk-4-1-7-0:0'
        - class: InitialWorkDirRequirement
          listing: []
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-
              var updateMetadata = function(file, key, value) {
                  file['metadata'][key] = value;
                  return file;
              };


              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file))
                      file['metadata'] = metadata;
                  else {
                      for (var key in metadata) {
                          file['metadata'][key] = metadata[key];
                      }
                  }
                  return file
              };

              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };

              var toArray = function(file) {
                  return [].concat(file);
              };

              var groupBy = function(files, key) {
                  var groupedFiles = [];
                  var tempDict = {};
                  for (var i = 0; i < files.length; i++) {
                      var value = files[i]['metadata'][key];
                      if (value in tempDict)
                          tempDict[value].push(files[i]);
                      else tempDict[value] = [files[i]];
                  }
                  for (var key in tempDict) {
                      groupedFiles.push(tempDict[key]);
                  }
                  return groupedFiles;
              };

              var orderBy = function(files, key, order) {
                  var compareFunction = function(a, b) {
                      if (a['metadata'][key].constructor === Number) {
                          return a['metadata'][key] - b['metadata'][key];
                      } else {
                          var nameA = a['metadata'][key].toUpperCase();
                          var nameB = b['metadata'][key].toUpperCase();
                          if (nameA < nameB) {
                              return -1;
                          }
                          if (nameA > nameB) {
                              return 1;
                          }
                          return 0;
                      }
                  };

                  files = files.sort(compareFunction);
                  if (order == undefined || order == "asc")
                      return files;
                  else
                      return files.reverse();
              };
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file))
                      file['metadata'] = metadata;
                  else {
                      for (var key in metadata) {
                          file['metadata'][key] = metadata[key];
                      }
                  }
                  return file
              };

              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };
      'sbg:categories':
        - Utilities
        - VCF Processing
      'sbg:license': Open source BSD (3-clause) license
      'sbg:toolAuthor': Broad Institute
      'sbg:toolkit': GATK
      'sbg:toolkitVersion': 4.1.7.0
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145234
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:links':
        - id: 'https://software.broadinstitute.org/gatk/'
          label: Homepage
        - id: 'https://github.com/broadinstitute/gatk/'
          label: Source Code
        - id: >-
            https://github.com/broadinstitute/gatk/releases/download/4.1.0.0/gatk-4.1.0.0.zip
          label: Download
        - id: 'https://www.ncbi.nlm.nih.gov/pubmed?term=20644199'
          label: Publications
        - id: >-
            https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_vcf_MergeVcfs.php
          label: Documentation
      'sbg:appVersion':
        - v1.2
      'sbg:id': bristol-myers-squibb/iwes-cwltool-validated-pipelines/gatk-merge-vcfs/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145234
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145234
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': adbda2c521f8c6f2854731e5f2b8ddb3ea2c647d0c894e3e341e944f993cd0372
    label: GATK Merge VCFs
    'sbg:x': 194.5807342529297
    'sbg:y': 307.2890625
  - id: haplotypecaller_genotyping
    in:
      - id: GenomeReference
        source: in_reference
      - id: inputBAM
        source: input_reads
      - id: ReferenceSNP
        source: dbsnp_database
      - id: interval
        source: target_bed
      - id: threads
        default: 16
      - id: licsrvr_host_and_port
        source: licsrvr_host_and_port
      - id: cpu_per_job
        default: 16
    out:
      - id: output
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/haplotypecaller-genotyping/0
      baseCommand: []
      inputs:
        - id: GenomeReference
          type: File
          inputBinding:
            prefix: '-r'
            shellQuote: false
            position: 0
          label: Genome reference (fasta)
          secondaryFiles:
            - pattern: .fai
              required: true
        - id: inputBAM
          type: File
          inputBinding:
            prefix: '-i'
            shellQuote: false
            position: 0
          label: input BAM file
          'sbg:fileTypes': BAM
          secondaryFiles:
            - pattern: ^.bai
              required: true
        - id: ReferenceSNP
          type: File?
          inputBinding:
            prefix: '-d'
            shellQuote: false
            position: 6
          label: reference SNP (dbSNP)
          'sbg:fileTypes': 'VCF.GZ, VCF'
          secondaryFiles:
            - pattern: .tbi
              required: true
        - id: minBaseQual
          type: int?
          inputBinding:
            prefix: '--min_base_qual'
            shellQuote: false
            position: 6
        - id: pruneFactor
          type: int?
          inputBinding:
            prefix: '--prune_factor'
            shellQuote: false
            position: 6
        - id: emitConfidence
          type: int?
          inputBinding:
            prefix: '--emit_conf'
            shellQuote: false
            position: 6
        - id: callConfidence
          type: int?
          inputBinding:
            prefix: '--call_conf'
            shellQuote: false
            position: 6
        - 'sbg:category': Algo Options
          'sbg:toolDefaultValue': '1 in gvcf mode, 0 otherwise'
          id: phasing
          type:
            - 'null'
            - type: enum
              symbols:
                - Enable
                - Disable
              name: phasing
          inputBinding:
            shellQuote: false
            position: 6
            valueFrom: |-
              ${
                  var expr = '';
                  
                  if (self == '') {
                      self = null;
                      inputs.phasing = null
                  };

                  if (inputs.phasing) {
                      if (inputs.phasing == 'Enable') {
                          expr = '--phasing 1';
                      } else {
                          expr = '--phasing 0';
                      }
                  }

                  return expr;
              }
          label: Phasing
          doc: Disable/enable phasing (diploid only).
        - id: emitMode
          type:
            - 'null'
            - type: enum
              symbols:
                - VARIANT
                - CONFIDENT
                - ALL
                - GVCF
              name: emitMode
          inputBinding:
            prefix: '--emit_mode'
            shellQuote: false
            position: 6
        - id: PCRIndelModel
          type:
            - 'null'
            - type: enum
              symbols:
                - HOSTILE
                - AGGRESIVE
                - CONSERVATIVE
                - NONE
              name: PCRIndelModel
          inputBinding:
            prefix: '--pcr_indel_model'
            shellQuote: false
            position: 6
        - id: interval
          type: File?
          inputBinding:
            prefix: '--interval'
            shellQuote: false
            position: 0
        - id: minMapQuality
          type: int?
          inputBinding:
            prefix: '--min_map_qual'
            shellQuote: false
            position: 6
        - id: trimSoftClipped
          type: boolean?
          inputBinding:
            prefix: '--trim_soft_clip'
            shellQuote: false
            position: 6
        - id: ploidy
          type: int?
          inputBinding:
            prefix: '--ploidy'
            shellQuote: false
            position: 6
        - id: threads
          type: int?
          inputBinding:
            prefix: '-t'
            shellQuote: false
            position: 0
          label: SentieonHaplotyper threads
        - 'sbg:category': Execution
          id: licsrvr_host_and_port
          type: string
          label: License server host and port
          doc: >-
            License server host and port in the format (HOST:PORT) (parentheses
            omitted).
        - 'sbg:category': Execution
          'sbg:toolDefaultValue': '1'
          id: cpu_per_job
          type: int?
          label: CPU per job
          doc: >-
            Number of CPUs per job. Appropriate instance will be chosen based on
            this parameter.
        - 'sbg:category': Execution
          id: mem_per_job
          type: int?
          label: Memory per job
          doc: >-
            Memory per job in MB. Appropriate instance will be chosen based on
            this parameter.
      outputs:
        - id: output
          doc: HaplotypeCaller variants.
          label: HaplotypeCaller variants
          type: File
          outputBinding:
            glob: '*.vcf.gz'
            outputEval: '$(inheritMetadata(self, inputs.inputBAM))'
          secondaryFiles:
            - pattern: .tbi
              required: false
          'sbg:fileTypes': 'VCF.GZ, VCF'
      doc: >-
        **Sentieon Haplotyper** is an algorithm designed to detect germline
        variants with Haplotype variant calling. It is capable of calling SNPs
        and indels simultaneously via local de-novo assembly of haplotypes in an
        active region. In other words, whenever the program encounters a region
        showing signs of variation, it discards the existing mapping information
        and completely reassembles the reads in that region.


        A list of **all inputs and parameters** with corresponding descriptions
        can be found at the bottom of the page.


        ### Common Use Cases


        * The input to the Haplotyper algorithm are BAM file and FASTA
        reference; its output is a VCF file. _Database dbSNP_ can be added to
        label found known variants. _BQSR Table_ can be given if one wants to
        perform recalibration on the fly. 


        * Using _BAM Output_ option, one can output a BAM file with containing
        modified reads after the local reassembly done by the variant calling.
        This option should only be used in conjunction with a small BED file for
        troubleshooting purposes.


        ### Changes Introduced by Seven Bridges


        * No modifications to the original tool representation have been made.


        ### Common Issues and Important Notes


        * No common issues specific to the tool's execution on the Seven Bridges
        Platform have been detected.


        ### Performance Benchmarking


        In the following table you can find estimates of running time and cost.
        All samples are aligned against **GRCh37 human reference index**. 


        *Cost can be significantly reduced by using **spot instances**. Visit
        the [Knowledge
        Center](https://docs.sevenbridges.com/docs/about-spot-instances) for
        more details.*            



        | BAM File Size [GB] | Mean coverage |Duration (min) | Cores | Cost ($)
        | Instance (AWS)  |

        |--------------------------|----------------|----------------|-------|----------|------------|

        | 1.29                     | 6X             | 1             | 16     |
        0.013     | c4.4xlarge |

        | 7.45                     | 40X             | 3             | 16     |
        0.039     | c4.4xlarge |

        | 8.36                    | 46X             | 3             | 16    |
        0.039      | c4.4xlarge |

        | 181.87                    | 42X             | 47             | 58    |
        1.80     | m5.12xlarge |

        | 220.17                    | 50X             | 53            | 53     |
        2.03      | m5.12xlarge |

        | 252.65                   | 52X             | 32            | 47    |
        1.76    | m5.12xlarge |



        ### References

        [1 - Sentieon
        manual](https://support.sentieon.com/manual/_downloads/Sentieon.pdf)
      label: Sentieon HaplotypeCaller
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: >-
            ${     var command = 'export SENTIEON_LICENSE=';     var command =
            command + inputs.licsrvr_host_and_port;     return command;  }
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: '&&'
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: ' $SENTIEON_PATH/bin/sentieon'
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: driver
        - prefix: '--algo'
          shellQuote: false
          position: 5
          valueFrom: Haplotyper
        - prefix: ''
          shellQuote: false
          position: 35
          valueFrom: |-
            ${ 
                var ext=".vcf.gz";
                if(inputs.emitMode === 'GVCF'){ 
                    ext=".g.vcf.gz"
                }
                else ext=".vcf.gz";
                
                return inputs.inputBAM.basename.replace(/.coord|.name|.mdup|.bam$/gi, '') + ext;
            }
      requirements:
        - class: ShellCommandRequirement
        - class: NetworkAccess
          networkAccess: true
        - class: ResourceRequirement
          ramMin: |-
            ${
                if (inputs.mem_per_job) {
                    return inputs.mem_per_job;
                } else {
                    return 1000;
                }

            }
          coresMin: |-
            ${
                if (inputs.cpu_per_job) {
                    return inputs.cpu_per_job;} 
                else {
                    return 1;}

            }
        - class: DockerRequirement
          dockerPull: 'images.sbgenomics.com/luka.topalovic/sentieon20201001:0'
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file))
                      file['metadata'] = metadata;
                  else {
                      for (var key in metadata) {
                          file['metadata'][key] = metadata[key];
                      }
                  }
                  return file
              };

              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145235
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:toolkit': Sentieon
      'sbg:toolkitVersion': '20201001'
      'sbg:categories':
        - Variant Calling
      'sbg:license': Client license
      'sbg:appVersion':
        - v1.2
      'sbg:id': >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/haplotypecaller-genotyping/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145235
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145235
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': a7ff3d6ee625f54324f0eebfb2032b95da416f5ea304243d35113eebf856fd7c7
    label: Sentieon HaplotypeCaller
    'sbg:x': -130.3828125
    'sbg:y': -8.734375
  - id: haplotypecaller_genotyping_gvcf
    in:
      - id: GenomeReference
        source: in_reference
      - id: inputBAM
        source: input_reads
      - id: ReferenceSNP
        source: dbsnp_database
      - id: phasing
        default: Enable
      - id: emitMode
        default: GVCF
      - id: interval
        source: sbg_prepare_intervals/intervals
      - id: threads
        default: 16
      - id: licsrvr_host_and_port
        source: licsrvr_host_and_port
      - id: cpu_per_job
        default: 6
      - id: mem_per_job
        default: 5000
    out:
      - id: output
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/haplotypecaller-genotyping/0
      baseCommand: []
      inputs:
        - id: GenomeReference
          type: File
          inputBinding:
            prefix: '-r'
            shellQuote: false
            position: 0
          label: Genome reference (fasta)
          secondaryFiles:
            - pattern: .fai
              required: true
        - id: inputBAM
          type: File
          inputBinding:
            prefix: '-i'
            shellQuote: false
            position: 0
          label: input BAM file
          'sbg:fileTypes': BAM
          secondaryFiles:
            - pattern: ^.bai
              required: true
        - id: ReferenceSNP
          type: File?
          inputBinding:
            prefix: '-d'
            shellQuote: false
            position: 6
          label: reference SNP (dbSNP)
          'sbg:fileTypes': 'VCF.GZ, VCF'
          secondaryFiles:
            - pattern: .tbi
              required: true
        - id: minBaseQual
          type: int?
          inputBinding:
            prefix: '--min_base_qual'
            shellQuote: false
            position: 6
        - id: pruneFactor
          type: int?
          inputBinding:
            prefix: '--prune_factor'
            shellQuote: false
            position: 6
        - id: emitConfidence
          type: int?
          inputBinding:
            prefix: '--emit_conf'
            shellQuote: false
            position: 6
        - id: callConfidence
          type: int?
          inputBinding:
            prefix: '--call_conf'
            shellQuote: false
            position: 6
        - 'sbg:category': Algo Options
          'sbg:toolDefaultValue': '1 in gvcf mode, 0 otherwise'
          id: phasing
          type:
            - 'null'
            - type: enum
              symbols:
                - Enable
                - Disable
              name: phasing
          inputBinding:
            shellQuote: false
            position: 6
            valueFrom: |-
              ${
                  var expr = '';
                  
                  if (self == '') {
                      self = null;
                      inputs.phasing = null
                  };

                  if (inputs.phasing) {
                      if (inputs.phasing == 'Enable') {
                          expr = '--phasing 1';
                      } else {
                          expr = '--phasing 0';
                      }
                  }

                  return expr;
              }
          label: Phasing
          doc: Disable/enable phasing (diploid only).
        - id: emitMode
          type:
            - 'null'
            - type: enum
              symbols:
                - VARIANT
                - CONFIDENT
                - ALL
                - GVCF
              name: emitMode
          inputBinding:
            prefix: '--emit_mode'
            shellQuote: false
            position: 6
        - id: PCRIndelModel
          type:
            - 'null'
            - type: enum
              symbols:
                - HOSTILE
                - AGGRESIVE
                - CONSERVATIVE
                - NONE
              name: PCRIndelModel
          inputBinding:
            prefix: '--pcr_indel_model'
            shellQuote: false
            position: 6
        - id: interval
          type: File?
          inputBinding:
            prefix: '--interval'
            shellQuote: false
            position: 0
        - id: minMapQuality
          type: int?
          inputBinding:
            prefix: '--min_map_qual'
            shellQuote: false
            position: 6
        - id: trimSoftClipped
          type: boolean?
          inputBinding:
            prefix: '--trim_soft_clip'
            shellQuote: false
            position: 6
        - id: ploidy
          type: int?
          inputBinding:
            prefix: '--ploidy'
            shellQuote: false
            position: 6
        - id: threads
          type: int?
          inputBinding:
            prefix: '-t'
            shellQuote: false
            position: 0
          label: SentieonHaplotyper threads
        - 'sbg:category': Execution
          id: licsrvr_host_and_port
          type: string
          label: License server host and port
          doc: >-
            License server host and port in the format (HOST:PORT) (parentheses
            omitted).
        - 'sbg:category': Execution
          'sbg:toolDefaultValue': '1'
          id: cpu_per_job
          type: int?
          label: CPU per job
          doc: >-
            Number of CPUs per job. Appropriate instance will be chosen based on
            this parameter.
        - 'sbg:category': Execution
          id: mem_per_job
          type: int?
          label: Memory per job
          doc: >-
            Memory per job in MB. Appropriate instance will be chosen based on
            this parameter.
      outputs:
        - id: output
          doc: HaplotypeCaller variants.
          label: HaplotypeCaller variants
          type: File
          outputBinding:
            glob: '*.vcf.gz'
            outputEval: '$(inheritMetadata(self, inputs.inputBAM))'
          secondaryFiles:
            - pattern: .tbi
              required: false
          'sbg:fileTypes': 'VCF.GZ, VCF'
      doc: >-
        **Sentieon Haplotyper** is an algorithm designed to detect germline
        variants with Haplotype variant calling. It is capable of calling SNPs
        and indels simultaneously via local de-novo assembly of haplotypes in an
        active region. In other words, whenever the program encounters a region
        showing signs of variation, it discards the existing mapping information
        and completely reassembles the reads in that region.


        A list of **all inputs and parameters** with corresponding descriptions
        can be found at the bottom of the page.


        ### Common Use Cases


        * The input to the Haplotyper algorithm are BAM file and FASTA
        reference; its output is a VCF file. _Database dbSNP_ can be added to
        label found known variants. _BQSR Table_ can be given if one wants to
        perform recalibration on the fly. 


        * Using _BAM Output_ option, one can output a BAM file with containing
        modified reads after the local reassembly done by the variant calling.
        This option should only be used in conjunction with a small BED file for
        troubleshooting purposes.


        ### Changes Introduced by Seven Bridges


        * No modifications to the original tool representation have been made.


        ### Common Issues and Important Notes


        * No common issues specific to the tool's execution on the Seven Bridges
        Platform have been detected.


        ### Performance Benchmarking


        In the following table you can find estimates of running time and cost.
        All samples are aligned against **GRCh37 human reference index**. 


        *Cost can be significantly reduced by using **spot instances**. Visit
        the [Knowledge
        Center](https://docs.sevenbridges.com/docs/about-spot-instances) for
        more details.*            



        | BAM File Size [GB] | Mean coverage |Duration (min) | Cores | Cost ($)
        | Instance (AWS)  |

        |--------------------------|----------------|----------------|-------|----------|------------|

        | 1.29                     | 6X             | 1             | 16     |
        0.013     | c4.4xlarge |

        | 7.45                     | 40X             | 3             | 16     |
        0.039     | c4.4xlarge |

        | 8.36                    | 46X             | 3             | 16    |
        0.039      | c4.4xlarge |

        | 181.87                    | 42X             | 47             | 58    |
        1.80     | m5.12xlarge |

        | 220.17                    | 50X             | 53            | 53     |
        2.03      | m5.12xlarge |

        | 252.65                   | 52X             | 32            | 47    |
        1.76    | m5.12xlarge |



        ### References

        [1 - Sentieon
        manual](https://support.sentieon.com/manual/_downloads/Sentieon.pdf)
      label: Sentieon HaplotypeCaller
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: >-
            ${     var command = 'export SENTIEON_LICENSE=';     var command =
            command + inputs.licsrvr_host_and_port;     return command;  }
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: '&&'
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: ' $SENTIEON_PATH/bin/sentieon'
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: driver
        - prefix: '--algo'
          shellQuote: false
          position: 5
          valueFrom: Haplotyper
        - prefix: ''
          shellQuote: false
          position: 35
          valueFrom: |-
            ${ 
                var ext=".vcf.gz";
                if(inputs.emitMode === 'GVCF'){ 
                    ext=".g.vcf.gz"
                }
                else ext=".vcf.gz";
                
                return inputs.inputBAM.basename.replace(/.coord|.name|.mdup|.bam$/gi, '') + ext;
            }
      requirements:
        - class: ShellCommandRequirement
        - class: NetworkAccess
          networkAccess: true
        - class: ResourceRequirement
          ramMin: |-
            ${
                if (inputs.mem_per_job) {
                    return inputs.mem_per_job;
                } else {
                    return 1000;
                }

            }
          coresMin: |-
            ${
                if (inputs.cpu_per_job) {
                    return inputs.cpu_per_job;} 
                else {
                    return 1;}

            }
        - class: DockerRequirement
          dockerPull: 'images.sbgenomics.com/luka.topalovic/sentieon20201001:0'
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file))
                      file['metadata'] = metadata;
                  else {
                      for (var key in metadata) {
                          file['metadata'][key] = metadata[key];
                      }
                  }
                  return file
              };

              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145235
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:toolkit': Sentieon
      'sbg:toolkitVersion': '20201001'
      'sbg:categories':
        - Variant Calling
      'sbg:license': Client license
      'sbg:appVersion':
        - v1.2
      'sbg:id': >-
        bristol-myers-squibb/iwes-cwltool-validated-pipelines/haplotypecaller-genotyping/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145235
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145235
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': a7ff3d6ee625f54324f0eebfb2032b95da416f5ea304243d35113eebf856fd7c7
    label: Sentieon HaplotypeCaller GVCF
    scatter:
      - interval
    'sbg:x': -133.79428100585938
    'sbg:y': 305.75262451171875
  - id: effect
    in:
      - id: inputVCF
        source: haplotypecaller_genotyping/output
      - id: SNPEff_data_directory
        source: snpeff_database
    out:
      - id: AnnotatedEFFVCF
      - id: statEFF
      - id: statGeneEFF
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: bristol-myers-squibb/iwes-cwltool-validated-pipelines/effect/0
      baseCommand: []
      inputs:
        - id: nextProt
          type: boolean?
          inputBinding:
            prefix: '-nextProt'
            shellQuote: false
            position: 0
        - id: intervals
          type: 'File[]?'
          inputBinding:
            prefix: '-interval'
            itemSeparator: ' -interval '
            shellQuote: false
            position: 0
          label: Intervals
          doc: >-
            Use a custom intervals in TXT/BED/BigBed/VCF/GFF file (you may use
            this option many times).

            This contains the annotation information.
        - id: motif
          type: boolean?
          inputBinding:
            prefix: '-motif'
            shellQuote: false
            position: 0
          doc: Annotate using motif database
        - id: only_transcripts
          type: File?
          inputBinding:
            prefix: '-onlyTr'
            shellQuote: false
            position: 0
          doc: Only use the transcripts
        - id: only_protein
          type: boolean?
          inputBinding:
            prefix: '-onlyProtein'
            shellQuote: false
            position: 0
          doc: Anotate only protein coding transcripts
        - id: inputVCF
          type: File
          inputBinding:
            shellQuote: false
            position: 10
          doc: VCF file to annotate
          secondaryFiles:
            - pattern: .tbi
              required: true
        - id: prefix_chr
          type: boolean?
          inputBinding:
            prefix: '-chr'
            shellQuote: false
            position: 0
          doc: Add prefix 'chr' in front of chromosomes
        - id: filter_intervals
          type: 'File[]?'
          inputBinding:
            prefix: '-fi'
            itemSeparator: ' -fi '
            shellQuote: false
            position: 0
          doc: Restrict analysis to these regions
          'sbg:fileTypes': bed
        - id: use_gene_id
          type: boolean?
          inputBinding:
            prefix: '-geneId'
            shellQuote: false
            position: 0
          doc: Use gene id instead of gene name
        - id: LOF_NMD
          type: boolean?
          inputBinding:
            prefix: '-lof'
            shellQuote: false
            position: 0
          doc: Add Loss of Function and Nonsense Mediated Decay annotations
        - id: canonical
          type: boolean?
          inputBinding:
            prefix: '-canon'
            shellQuote: false
            position: 0
          doc: Annotate cannonical transcripts only
        - id: padding
          type: int?
          inputBinding:
            prefix: '-ud'
            shellQuote: false
            position: 0
          doc: Upstream and Downstream interval size padding
        - id: cancer
          type: boolean?
          inputBinding:
            prefix: '-cancer'
            shellQuote: false
            position: 0
          doc: >-
            Using the -cancer command line option, you can compare somatic vs
            germline samples.
        - id: Cancer_samples
          type: File?
          inputBinding:
            prefix: '-cancerSamples'
            shellQuote: false
            position: 0
          doc: File with germline and cancer samples
        - id: SNPEff_data_directory
          type: File
          inputBinding:
            shellQuote: false
            position: -9
          label: Tarball (tar.gz) with snpeff directory
          doc: |-
            tarball with snpeff directory.
            When extracted it will create the directory `snpEff`
        - 'sbg:toolDefaultValue': '1'
          id: cpu_per_job
          type: int?
          label: CPUs per job
          doc: Number of CPUs per job
        - 'sbg:toolDefaultValue': '8000'
          id: mem_per_job
          type: int?
          label: Memory per job (MB)
          doc: Memory per job
        - 'sbg:toolDefaultValue': '0'
          id: mem_overhead_per_job
          type: int?
          label: Memory overhead per job (MB)
          doc: Memory overhead per job (MB)
        - 'sbg:toolDefaultValue': 'False'
          id: compress_output
          type: boolean?
          label: Compress Output
          doc: Performs bgzip and tabix on the output vcf
      outputs:
        - id: AnnotatedEFFVCF
          label: VCF file annotated wiht the Effect
          type: File
          outputBinding:
            glob: |-
              ${
                  if (inputs.compress_output){
                      return inputs.inputVCF.basename;
                  }
                  return inputs.inputVCF.nameroot;
              }
            outputEval: '$(inheritMetadata(self, inputs.inputVCF))'
          secondaryFiles:
            - pattern: .tbi
              required: false
        - id: statEFF
          doc: html file with annotation statistics from SNPEFF
          type: File?
          outputBinding:
            glob: '*.html'
            outputEval: '$(inheritMetadata(self, inputs.inputVCF))'
        - id: statGeneEFF
          doc: txt file with annotation statistics from SNPEFF
          type: File?
          outputBinding:
            glob: '*genes.txt'
            outputEval: '$(inheritMetadata(self, inputs.inputVCF))'
      label: SnpEff Annotation
      arguments:
        - prefix: ''
          shellQuote: false
          position: -1
          valueFrom: |-
            ${
                var mem = 8000;
                var overhead = 0;
                if (inputs.mem_per_job){
                    mem = inputs.mem_per_job;
                }
                if (inputs.mem_overhead_per_job){
                    overhead = inputs.mem_overhead_per_job;
                }
                return 'java -Xmx'.concat(mem-overhead, 'M -jar /opt/snpEff/snpEff.jar');
            }
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: eff
        - prefix: '-v'
          shellQuote: false
          position: 0
          valueFrom: ' '
        - prefix: '-stats'
          shellQuote: false
          position: 0
          valueFrom: '$(inputs.inputVCF.basename.replace(".vcf.gz", ".stats.html"))'
        - prefix: '-config'
          shellQuote: false
          position: 0
          valueFrom: /opt/snpEff/snpEff.config
        - prefix: ''
          shellQuote: false
          position: 9
          valueFrom: GRCh38.86
        - prefix: ''
          shellQuote: false
          position: 20
          valueFrom: |-
            ${
                if (inputs.compress_output){
                    var name = inputs.inputVCF.basename;
                    return "| bgzip > " + name + " && tabix -p vcf " + name;
                }
                return " > " + inputs.inputVCF.nameroot;
            }
        - prefix: '-dataDir'
          shellQuote: false
          position: 5
          valueFrom: >-
            ${ return runtime.outdir + "/" +
            inputs.SNPEff_data_directory.basename.replace(".tar.gz","") }
        - prefix: ''
          shellQuote: false
          position: -10
          valueFrom: 'tar  -xvzf '
        - prefix: ''
          shellQuote: false
          position: -8
          valueFrom: '&&'
      requirements:
        - class: ShellCommandRequirement
        - class: ResourceRequirement
          ramMin: |-
            ${
                var mem=8000;
                if (inputs.mem_per_job){
                    mem = inputs.mem_per_job;
                }
                return mem;
            }
          coresMin: |-
            ${
                var cpu = 1;
                if (inputs.cpu_per_job){
                    cpu = inputs.cpu_per_job;
                }
                return cpu;
            }
        - class: DockerRequirement
          dockerPull: 'images.sbgenomics.com/bristol-myers-squibb/celgene/snpeff4.3t:0'
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file))
                      file['metadata'] = metadata;
                  else {
                      for (var key in metadata) {
                          file['metadata'][key] = metadata[key];
                      }
                  }
                  return file
              };

              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                      }
                  }
                  return o1;
              };
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file)) {
                      file['metadata'] = {}
                  }
                  for (var key in metadata) {
                      file['metadata'][key] = metadata[key];
                  }
                  return file
              };
              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!o2) {
                      return o1;
                  };
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                      for (var key in commonMetadata) {
                          if (!(key in example)) {
                              delete commonMetadata[key]
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                      if (o1.secondaryFiles) {
                          o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)
                      }
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                          if (o1[i].secondaryFiles) {
                              o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)
                          }
                      }
                  }
                  return o1;
              };
      'sbg:projectName': iWES CWLtool validated pipelines
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
          'sbg:modifiedOn': 1638145237
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:toolkit': SnpSift
      'sbg:toolkitVersion': 4.3t
      'sbg:appVersion':
        - v1.2
      'sbg:id': bristol-myers-squibb/iwes-cwltool-validated-pipelines/effect/0
      'sbg:revision': 0
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1638145237
      'sbg:modifiedBy': bristol-myers-squibb/jovana_babic
      'sbg:createdOn': 1638145237
      'sbg:createdBy': bristol-myers-squibb/jovana_babic
      'sbg:project': bristol-myers-squibb/iwes-cwltool-validated-pipelines
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/jovana_babic
      'sbg:latestRevision': 0
      'sbg:publisher': sbg
      'sbg:content_hash': ac134528fefee107d3ea2aca818d3d7f2037b40f349fd96143e5882ef5848832a
    label: SnpEff Annotation
    'sbg:x': 201.558837890625
    'sbg:y': -33.35270309448242
  - id: ancestry_admixture_pipeline
    in:
      - id: vcf_file
        source: haplotypecaller_genotyping/output
      - id: resources_files_tar_archive
        source: ancestry_resources_files
    out:
      - id: admixture_proportions_with_pedigree_info
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: >-
        bristol-myers-squibb/ancestry-iwes-integration-dev/ancestry-admixture-pipeline/2
      baseCommand: []
      inputs:
        - id: vcf_file
          type: File
          inputBinding:
            shellQuote: false
            position: 2
          label: Input VCF
          doc: Input VCF to calculate samples admixture/ancestry estimates.
          'sbg:fileTypes': VCF
        - id: resources_files_tar_archive
          type: File
          label: Resources files
          doc: >-
            TAR archive with the directory containing resources required to run
            the pipeline:

            1. Autosomal_SNP_list_only_rs_v2.txt (2 columns (rsID\trsID) for the
            Ancestry Informative Markers - AIMs)

            2. PAP.bed, PAP.bim, PAP.fam (genotypes of hypothetical/putative
            ancestral population)

            3. snp151Commonhg19.bed OR snp151Commonhg19.bed (dbSNP151 table,
            hg19 or hg38, rsID mappings to chr, start, end, only SNPs)

            4. template_merge.pop (template required for running ADMIXTURE
            program)
          'sbg:fileTypes': TAR
      outputs:
        - id: admixture_proportions_with_pedigree_info
          doc: Admixture proportions with pedigree info report file.
          label: Admixture proportions with pedigree info
          type: File
          outputBinding:
            glob: '*.admixture.pedigree.txt'
            outputEval: '$(inheritMetadata(self, inputs.vcf_file))'
          'sbg:fileTypes': ADMIXTURE.PEDIGREE.TXT
      label: Ancestry Admixture Pipeline
      arguments:
        - prefix: ''
          shellQuote: false
          position: 0
          valueFrom: |-
            ${
                var archive = [].concat(inputs.resources_files_tar_archive)[0].path
                return "tar -xf " + archive
            }
        - prefix: ''
          shellQuote: false
          position: 1
          valueFrom: |-
            ${
                return "&& admixture_analysis.sh"
            }
        - prefix: ''
          shellQuote: false
          position: 3
          valueFrom: |-
            ${
                var reference_dir = inputs.resources_files_tar_archive.metadata.reference_genome
                if (reference_dir == "GRCh37") {
                    var reference_name = "GRCh37"
                }
                else if (reference_dir == "GRCh38") {
                    var reference_name = "GRCh38"
                }
                return reference_name + " " + reference_dir
            }
        - prefix: ''
          shellQuote: false
          position: 4
          valueFrom: |-
            ${
                var sample_name = inputs.vcf_file.metadata.sample_id
                var reference = inputs.resources_files_tar_archive.metadata.reference_genome
                var rename = sample_name + "." + reference + ".admixture.pedigree.txt"
                return "&& mv *.pedigree.info.txt " + rename
            }
      requirements:
        - class: ShellCommandRequirement
        - class: LoadListingRequirement
        - class: InlineJavascriptRequirement
          expressionLib:
            - |-

              var setMetadata = function(file, metadata) {
                  if (!('metadata' in file)) {
                      file['metadata'] = {}
                  }
                  for (var key in metadata) {
                      file['metadata'][key] = metadata[key];
                  }
                  return file
              };
              var inheritMetadata = function(o1, o2) {
                  var commonMetadata = {};
                  if (!o2) {
                      return o1;
                  };
                  if (!Array.isArray(o2)) {
                      o2 = [o2]
                  }
                  for (var i = 0; i < o2.length; i++) {
                      var example = o2[i]['metadata'];
                      for (var key in example) {
                          if (i == 0)
                              commonMetadata[key] = example[key];
                          else {
                              if (!(commonMetadata[key] == example[key])) {
                                  delete commonMetadata[key]
                              }
                          }
                      }
                      for (var key in commonMetadata) {
                          if (!(key in example)) {
                              delete commonMetadata[key]
                          }
                      }
                  }
                  if (!Array.isArray(o1)) {
                      o1 = setMetadata(o1, commonMetadata)
                      if (o1.secondaryFiles) {
                          o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)
                      }
                  } else {
                      for (var i = 0; i < o1.length; i++) {
                          o1[i] = setMetadata(o1[i], commonMetadata)
                          if (o1[i].secondaryFiles) {
                              o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)
                          }
                      }
                  }
                  return o1;
              };
      hints:
        - class: DockerRequirement
          dockerPull: >-
            bms-images.sbgenomics.com/bristol-myers-squibb/ancestry_admixture_analysis:master
      successCodes:
        - 0
        - 7
      'sbg:projectName': Ancestry iWES integration - Dev
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': bristol-myers-squibb/ana_stankovic
          'sbg:modifiedOn': 1641985283
          'sbg:revisionNotes': >-
            Copy of
            bristol-myers-squibb/bms-rna-tools-cwl1-2-per-sample-workflow/ancestry-admixture-pipeline/12
        - 'sbg:revision': 1
          'sbg:modifiedBy': bristol-myers-squibb/ana_stankovic
          'sbg:modifiedOn': 1642078829
          'sbg:revisionNotes': 'Added labels, file types and descriptions'
        - 'sbg:revision': 2
          'sbg:modifiedBy': bristol-myers-squibb/ana_stankovic
          'sbg:modifiedOn': 1642079285
          'sbg:revisionNotes': App rename
      'sbg:image_url': null
      'sbg:appVersion':
        - v1.2
      'sbg:id': >-
        bristol-myers-squibb/ancestry-iwes-integration-dev/ancestry-admixture-pipeline/2
      'sbg:revision': 2
      'sbg:revisionNotes': App rename
      'sbg:modifiedOn': 1642079285
      'sbg:modifiedBy': bristol-myers-squibb/ana_stankovic
      'sbg:createdOn': 1641985283
      'sbg:createdBy': bristol-myers-squibb/ana_stankovic
      'sbg:project': bristol-myers-squibb/ancestry-iwes-integration-dev
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - bristol-myers-squibb/ana_stankovic
      'sbg:latestRevision': 2
      'sbg:publisher': sbg
      'sbg:content_hash': af79fed6510469f1632bac893303c6fe37084c34333ebe4c5f5dcc52d6a2ec3c7
      'sbg:workflowLanguage': CWL
    label: Ancestry Admixture Pipeline
    'sbg:x': 202.61781311035156
    'sbg:y': 134.41197204589844
    when: '$(inputs.resources_files_tar_archive? true : false)'
hints:
  - class: 'sbg:AWSInstanceType'
    value: c4.8xlarge;ebs-gp2;1200
requirements:
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
'sbg:projectName': Integrated WES-WGS Production Ready Pipelines
'sbg:revisionsInfo':
  - 'sbg:revision': 0
    'sbg:modifiedBy': bristol-myers-squibb/luka.topalovic
    'sbg:modifiedOn': 1622761292
    'sbg:revisionNotes': null
  - 'sbg:revision': 1
    'sbg:modifiedBy': bristol-myers-squibb/luka.topalovic
    'sbg:modifiedOn': 1622761292
    'sbg:revisionNotes': Initial
  - 'sbg:revision': 2
    'sbg:modifiedBy': bristol-myers-squibb/luka.topalovic
    'sbg:modifiedOn': 1622761375
    'sbg:revisionNotes': Initial
  - 'sbg:revision': 3
    'sbg:modifiedBy': bristol-myers-squibb/pavle.marinkovic
    'sbg:modifiedOn': 1625754356
    'sbg:revisionNotes': removed VC Metrics
  - 'sbg:revision': 4
    'sbg:modifiedBy': bristol-myers-squibb/luka_test_account
    'sbg:modifiedOn': 1640359453
    'sbg:revisionNotes': cwltool validated
  - 'sbg:revision': 5
    'sbg:modifiedBy': bristol-myers-squibb/pavle.marinkovic
    'sbg:modifiedOn': 1640706338
    'sbg:revisionNotes': updated
  - 'sbg:revision': 6
    'sbg:modifiedBy': bristol-myers-squibb/luka_test_account
    'sbg:modifiedOn': 1643896038
    'sbg:revisionNotes': Added Ancestry pipeline tool
'sbg:image_url': >-
  https://bms.sbgenomics.com/ns/brood/images/bristol-myers-squibb/integrated-wes-wgs-production-ready-pipelines/germline-calling/6.png
'sbg:toolAuthor': Luka Topalovic
'sbg:wrapperAuthor': Luka Topalovic
'sbg:categories':
  - Variant Calling
  - DNA
  - WES (WXS)
'sbg:appVersion':
  - v1.2
'sbg:id': >-
  bristol-myers-squibb/integrated-wes-wgs-production-ready-pipelines/germline-calling/6
'sbg:revision': 6
'sbg:revisionNotes': Added Ancestry pipeline tool
'sbg:modifiedOn': 1643896038
'sbg:modifiedBy': bristol-myers-squibb/luka_test_account
'sbg:createdOn': 1622761292
'sbg:createdBy': bristol-myers-squibb/luka.topalovic
'sbg:project': bristol-myers-squibb/integrated-wes-wgs-production-ready-pipelines
'sbg:sbgMaintained': false
'sbg:validationErrors': []
'sbg:contributors':
  - bristol-myers-squibb/luka.topalovic
  - bristol-myers-squibb/luka_test_account
  - bristol-myers-squibb/pavle.marinkovic
'sbg:latestRevision': 6
'sbg:publisher': sbg
'sbg:content_hash': a321bc37915c5041deb439acc318bc922c15d7e0a411faa0f075bb02de835f8bc
'sbg:workflowLanguage': CWL
