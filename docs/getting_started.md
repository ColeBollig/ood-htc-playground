## Overview

This repository provides a local test environment for integrating [HTCondor](https://htcondor.org/) with [Open OnDemand](https://openondemand.org/). The environment is composed of four Docker containers:

- **ldap** — LDAP directory for user authentication across all containers
- **base** — shared base image used by the other containers
- **htcondor** — HTCondor submit and execution node (hostname: `htc.mini`)
- **ondemand** — Open OnDemand portal for browser-based cluster access

## Requirements

If you haven't already installed and tested the required packages, please refer to the [requirements page](requirements.md)

## Getting Started

Because all container images are built locally from source, you will need to clone the repository and build the images before starting for the first time. The build step compiles all four container images on your machine and may take several minutes depending on your hardware.

### Clone Repo and Build Images

```
$ git clone https://github.com/ColeBollig/ood-htc-playground.git
$ cd ood-htc-playground
$ ./hpcts build
```

The build command will produce output similar to:

```
 Building images locally

[+] Building 120.3s (42/42) FINISHED
 => [ldap] ...
 => [base] ...
 => [htcondor] ...
 => [ondemand] ...
```

### Start Containers

Once the images are built, start the environment:

```
$ ./hpcts start

 Fetching latest HPC Toolset Images..

 Starting HPC Toolset Cluster..

[+] Running 6/6
 - Network ood-htc-playground_compute    Created                                            0.1s
 - Volume "ood-htc-playground_etc_munge" Created                                            0.0s
 - Volume "ood-htc-playground_home"      Created                                            0.0s
 - Container ldap                        Started                                            3.1s
 - Container htcondor                    Started                                            5.4s
 - Container ondemand                    Started                                            7.2s

 OnDemand URL: https://localhost:3443

 Login to htc.mini: ssh -p 7222 hpcadmin@localhost
```

> **NOTE: Despite seeing this output, the services inside the containers may take a few additional minutes to fully initialize. If the OnDemand portal is not yet responding, wait a moment and try again, or check the logs as described below.**

### Docker Logs

Once the helper script finishes you can monitor the status of the containers:

```
$ docker compose logs -f
ldap         | ---> Starting slapd...
htcondor     | ---> Starting the MUNGE Authentication service (munged) ...
htcondor     | ---> Starting HTCondor...
ondemand     | ---> Starting the MUNGE Authentication service (munged) ...
ondemand     | ---> Starting ondemand httpd...
```

To follow logs for a specific container:

```
$ docker compose logs -f ondemand
$ docker compose logs -f htcondor
```

Wait until you see the `ondemand httpd` service start before attempting to access https://localhost:3443.

## Something still not right?

Please see our [troubleshooting section](docker_tips.md) for more info.

If errors are showing up in the logs or services have not started, first try destroying the environment and starting again:

```
$ ./hpcts destroy
$ docker container list
(Should show no containers)

$ docker volume list
(Should show no volumes)
```

If either of the above still show entries, remove them manually:

```
$ docker container rm [ContainerID]
$ docker volume rm [VolumeName]
```

Then start everything back up (images are already built, so this will be quick):

```
$ ./hpcts start
```

To completely start over and rebuild all images from scratch, run the cleanup command followed by build and start:

```
$ ./hpcts cleanup
$ ./hpcts build
$ ./hpcts start
```

> **NOTE: The cleanup command removes ALL local container images. You will need to rebuild before starting again.**

## Tutorial Navigation
[Next - Accessing the Applications](applications.md)  
[Docker Tips](docker_tips.md)  
[Back to Start](../README.md)
