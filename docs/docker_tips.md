## Docker Tips

This section includes useful tips for running the HTCondor & Open OnDemand integration environment from [ood-htc-playground](https://github.com/ColeBollig/ood-htc-playground).

### Starting/Stopping the Environment

If you have not already done so, clone this repo:

```
$ git clone https://github.com/ColeBollig/ood-htc-playground.git
$ cd ood-htc-playground
```

If you have previously cloned the repo, pull the latest changes:

```
$ git pull
```

Build the container images locally (required before first run, or after making local changes):

```
$ ./hpcts build
```

Pull down and start the containers:

```
$ ./hpcts start
```

Once started, the following services are available:

- **Open OnDemand:** https://localhost:3443
- **HTCondor node (SSH):** `ssh -p 7222 hpcadmin@localhost`

Stop the running containers without removing them:

```
$ ./hpcts stop
```

### If something goes wrong...

First thing to try is destroying the containers and volumes, then starting fresh:

```
$ ./hpcts destroy
$ ./hpcts start
```

If you need to completely remove all local container images and start over (you will need to rebuild):

```
$ ./hpcts cleanup
$ ./hpcts build
$ ./hpcts start
```

### Docker Documentation

- [Docker](https://docs.docker.com)
- [Install & Start Docker](https://docs.docker.com/engine/install/)
- [Linux & Windows Subsystem for Linux](https://docs.docker.com/engine/install/linux-postinstall/)
- [MacOS Docker Desktop](https://docs.docker.com/docker-for-mac/troubleshoot/)

### Helpful Docker commands

```
# Start all containers manually
$ docker compose up -d

# Display logs for all containers
$ docker compose logs -f

# Display logs for a specific container
$ docker compose logs -f ondemand
$ docker compose logs -f htcondor
$ docker compose logs -f ldap
$ docker compose logs -f base

# Stop containers
$ docker compose stop

# Stop containers and remove them
$ docker compose down

# Stop containers, remove them and all volumes
$ docker compose down -v

# Display Docker processes
$ docker ps -a

# Display Docker containers
$ docker container list

# Display Docker images
$ docker image list

# Display Docker volumes
$ docker volume list

# Find the IP address of a container
$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ondemand
$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' htcondor
```

### Troubleshooting

General troubleshooting tips to try:

#### Error when starting up containers

If you get this error when starting:

```
ERROR: Couldn't connect to Docker daemon at http+docker://localhost - is it running?
```

Try stopping and starting Docker (restart doesn't usually fix the problem). Commands for this differ depending on operating system.

If the error persists, try:

```
export DOCKER_HOST=127.0.0.1
```

> NOTE: this is only necessary on some systems, so don't use it if the previous command works.

**Sometimes restarting your operating system is the only solution.**

#### Open OnDemand not loading after startup

The services inside the containers (especially `ondemand`) may take a few minutes to fully initialize after `./hpcts start` reports success. Check the logs to monitor progress:

```
$ docker compose logs -f ondemand
```

Wait until you see the httpd service start before attempting to access https://localhost:3443.

#### HTCondor jobs not submitting

If jobs submitted through Open OnDemand are not running, check that the HTCondor container is healthy:

```
$ docker compose logs -f htcondor
```

You can also SSH into the HTCondor node directly to inspect the schedd state:

```
$ ssh -p 7222 hpcadmin@localhost
$ condor_status
$ condor_q
```

#### Deleting Docker containers/images/volumes manually

If you want to manually clean up images:

```
$ docker image list
$ docker image rm XX    # XX = image id
$ docker container list
$ docker container rm XX    # XX = container id
$ docker volume list
$ docker volume rm XX    # XX = volume id
```

If you're getting an error about volumes in use but nothing is running, stop Docker, manually delete the
files, and start Docker again. Commands differ by operating system — consult your favorite search
provider for OS-specific instructions.

[Back to Start](../README.md)
