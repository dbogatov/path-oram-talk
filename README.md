# Data-X Talk presentation

## Path ORAM: An Extremely Simple Oblivious RAM Protocol

Paper by Emil Stefanov *et al.* published in "Proceedings of the 2013 ACM SIGSAC Conference on Computer Communications Security". CCS ’13. Berlin, Germany.

### Abstract

> We present Path ORAM, an extremely simple Oblivious RAM protocol with a small amount of client storage. 
> Partly due to its simplicity, Path ORAM is the most practical ORAM scheme for small client storage known to date. 
> We formally prove that Path ORAM requires log^2 N / log X bandwidth overhead for block size B = X log N. 
> For block sizes bigger than Omega(log^2 N), Path ORAM is asymptotically better than the best known ORAM scheme with small client storage. 
> Due to its practicality, Path ORAM has been adopted in the design of secure processors since its proposal.

## About this presentation

This presentation is developed by Dmytro Bogatov (dmytro@bu.edu) BU CS PhD student 23'.

Presentation is written in LaTeX using beamer package.
It is compile in CI system (Gitlab CI) which checks spelling, lints latex code, verifies `bibfile.bib` and complies source to PDF file (see [.gitlab-ci.yml](.gitlab-ci.yml)).

Main repo is [https://git.dbogatov.org/bu/PathORAM-Talk](https://git.dbogatov.org/bu/PathORAM-Talk).

### Legal

This work is licensed under **Creative Commons Attribution-NoDerivatives 4.0 International**.
See [LICENSE](LICENSE).
