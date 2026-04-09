# HTCondor & Open OnDemand Integration

## Overview

This repository provides a test environment for integrating [HTCondor](https://htcondor.org/)
with [Open OnDemand](https://openondemand.org/). It is forked and modified from the
[hpc-toolset-tutorial](https://github.com/ubccr/hpc-toolset-tutorial) project by the
University at Buffalo Center for Computational Research (UBCCR).

## Attribution

This project is based on [hpc-toolset-tutorial](https://github.com/ubccr/hpc-toolset-tutorial),
developed and maintained by [UBCCR](https://github.com/ubccr). The original repository provides
a multi-cluster demo environment using Docker containers and serves as a tutorial for HPC toolset
components including Open OnDemand, ColdFront, and Slurm.

Modifications in this fork are focused on adapting the environment to support **HTCondor** as the
underlying workload manager in place of Slurm, enabling testing of HTCondor and Ope OnDemand integration.

## Tutorial Steps

[Requirements](docs/requirements.md)
[Getting Started](docs/getting_started.md)
[Accessing the Applications](docs/applications.md)
[Open OnDemand](/ondemand/README.md)

[Acknowledgments](docs/acknowledgments.md)


## Disclaimer

**DO NOT run this project on production systems.** This project is for educational
purposes only. The container images we publish for the tutorial are configured
with hard coded insecure passwords and should be run locally in development for
testing and learning only. 

## License

This tutorial is released under the GPLv3 license. See the LICENSE file.
