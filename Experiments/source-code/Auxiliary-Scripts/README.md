# Orchestration Scripts

Scripts for running the benchmarks for the evolution-aware SPL static analyses.

* The 'entrypoint.sh' file must be executed to run the experiments. In this files, there are several environment variables that must be configured to point to the right directories;
* If you want to also generate the CFG files in the benchmarks (the reproducibility package already comes with them), you must also clone our forked version of the TypeChef, TypeChef-BusyBoxAnalysis and KBuildMiner projecs and build them.
  * https://github.com/BrunoMWorm/Typechef-BusyboxAnalysis
  * https://github.com/BrunoMWorm/TypeChef ('full-cfg' and 'stable-ids' branches)
  * https://github.com/BrunoMWorm/KBuildMiner/tree/fixed-paths
