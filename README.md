<font size=20>__SPAdes 3.13.0 Manual__</font>

# About SPAdes

SPAdes – St. Petersburg genome assembler – is an assembly toolkit containing various assembly pipelines. This manual will help you to install and run SPAdes. SPAdes version 3.13.0 was released under GPLv2 on October 11, 2018 and can be downloaded from <http://cab.spbu.ru/software/spades/>. []()

# Goal

SPAdes outputs contigs and genome assembly graph (FASTG/GFA), but do not have the ability to accept such graphs as input. Projects goal: implement support for third-party assembly graphs.


# Downloading SPAdes

## Downloading SPAdes Linux binaries

To download [SPAdes Linux binaries](http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Linux.tar.gz) and extract them, go to the directory in which you wish SPAdes to be installed and run:

``` bash

wget http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Linux.tar.gz
tar -xzf SPAdes-3.13.0-Linux.tar.gz
cd SPAdes-3.13.0-Linux/bin/
```

In this case you do not need to run any installation scripts – SPAdes is ready to use. We also suggest adding SPAdes installation directory to the `PATH` variable. []()


## Downloading SPAdes binaries for Mac

To obtain [SPAdes binaries for Mac](http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Darwin.tar.gz), go to the directory in which you wish SPAdes to be installed and run:

``` bash

curl http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Darwin.tar.gz -o SPAdes-3.13.0-Darwin.tar.gz
tar -zxf SPAdes-3.13.0-Darwin.tar.gz
cd SPAdes-3.13.0-Darwin/bin/
```

Just as in Linux, SPAdes is ready to use and no further installation steps are required. We also suggest adding SPAdes installation directory to the `PATH` variable. []()


## Downloading and compiling SPAdes source code

If you wish to compile SPAdes by yourself you will need the following libraries to be pre-installed:

-   g++ (version 5.3.1 or higher)
-   cmake (version 2.8.12 or higher)
-   zlib
-   libbz2

If you meet these requirements, you can download the [SPAdes source code](http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0.tar.gz):

``` bash

wget http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0.tar.gz
tar -xzf SPAdes-3.13.0.tar.gz
cd SPAdes-3.13.0
```

and build it with the following script:

``` bash

./spades_compile.sh
```

SPAdes will be built in the directory `./bin`. If you wish to install SPAdes into another directory, you can specify full path of destination folder by running the following command in `bash` or `sh`:

``` bash

PREFIX=<destination_dir> ./spades_compile.sh
```

for example:

``` bash

PREFIX=/usr/local ./spades_compile.sh
```

which will install SPAdes into `/usr/local/bin`.

After installation you will get the same files (listed above) in `./bin` directory (or `<destination_dir>/bin` if you specified PREFIX). We also suggest adding SPAdes installation directory to the `PATH` variable. []()


## Verifying your installation

For testing purposes, SPAdes comes with a toy data set (reads that align to first 1000 bp of *E. coli*). To try SPAdes on this data set, run:

``` bash

<spades installation dir>/spades.py --test
```

If you added SPAdes installation directory to the `PATH` variable, you can run:

``` bash

spades.py --test
```

For the simplicity we further assume that SPAdes installation directory is added to the `PATH` variable.

If the installation is successful, you will find the following information at the end of the log:

``` plain

===== Assembling finished. Used k-mer sizes: 21, 33, 55

* Corrected reads are in spades_test/corrected/
* Assembled contigs are in spades_test/contigs.fasta
* Assembled scaffolds are in spades_test/scaffolds.fasta
* Assembly graph is in spades_test/assembly_graph.fastg
* Assembly graph in GFA format is in spades_test/assembly_graph.gfa
* Paths in the assembly graph corresponding to the contigs are in spades_test/contigs.paths
* Paths in the assembly graph corresponding to the scaffolds are in spades_test/scaffolds.paths

======= SPAdes pipeline finished.

========= TEST PASSED CORRECTLY.

SPAdes log can be found here: spades_test/spades.log

Thank you for using SPAdes!
```

# Changelog

- Added new stage `load_graph` replacing stages `construction` and `simplification` in `SPAdes/assembler/congigs/debruijn/config.info`

- Created class `LoadGraph` in  `SPAdes/assembler/src/projects/spades`

- Created binaries  `SPAdes/assembler/src/projects/load_graph` through this file the completed part of project can be run (necessary using target `load` )

# Run script

After downloading SPAdes, as mentioned above, necessary  build it with the following script:

``` bash

./spades_compile.sh
```

Run SPAdes for test data:

``` bash

./spades.py --checkpoints all -o spades_output -1 ./test_dataset/ecoli_1K_1.fq.gz -2 ./test_dataset/ecoli_1K_2.fq.gz

```

Important information for us:

``` bash

0:00:00.618    36M / 37M   INFO    General                 (sequence_mapper_notifier.h:  98)   Total 2054 reads processed
0:00:00.664    36M / 37M   INFO    General                 (pair_info_count.cpp       : 209)   Edge pairs: 67108864 (rough upper limit)
0:00:00.664    36M / 37M   INFO    General                 (pair_info_count.cpp       : 213)   1636 paired reads (79.6495% of all) aligned to long edges
0:00:00.666     4M / 5M    INFO    General                 (pair_info_count.cpp       : 354)     Insert size = 214.696, deviation = 10.4821, left quantile = 201, right quantile = 228, read length = 100
```

Now the path to the graph is hard-coded and has the following value:

``` bash

./spades_output//K55/assembly_graph_with_scaffolds.gfa

```

Run the following script:

``` bash

./build_spades/bin/load ./spades_output/K55/configs/config.info

```

The result:

``` bash

0:00:00.226    37M / 37M   INFO    General                 (sequence_mapper_notifier.h:  98)   Total 2054 reads processed
0:00:00.274    37M / 37M   INFO    General                 (pair_info_count.cpp       : 209)   Edge pairs: 67108864 (rough upper limit)
0:00:00.274    37M / 37M   INFO    General                 (pair_info_count.cpp       : 213)   1636 paired reads (79.6495% of all) aligned to long edges
0:00:00.276     5M / 5M    INFO    General                 (pair_info_count.cpp       : 354)     Insert size = 214.696, deviation = 10.4821, left quantile = 201, right quantile = 228, read length = 100

```

 