## Accessing the Applications

Now that your containers have been created and applications launched, you can login to
them using your browser and via SSH. We recommend you keep this page open as a reference
for URLs, container names, and user credentials.

This environment provides two primary services: an **HTCondor** workload manager node
and an **Open OnDemand** portal for browser-based access to the cluster.

### User Accounts

By default, all containers authenticate to LDAP and you can login to them via ssh,
and for the ColdFront, OnDemand, and XDMoD containers, also through your browser.
Details for each software package are listed below.

Default password for all accounts (except cgray): `ilovelinux`

- hpcadmin
- cgray (password: test123)
- sfoster
- csimmons
- astewart

### Single-sign on: Portal login/logout
Because these applications are configured for single-sign on (SSO), if you login using
Dex/OpenID Connect and want to switch between users you will either need to clear the
browser cookies or restart the browser.  You may wish to launch multiple 'incognito'
windows for each user account used in the tutorial and switch between them as you go.

### Open OnDemand

Open OnDemand is used for accessing HPC resources, submitting jobs to a cluster, user file access, etc.

SSH container name: ondemand (must login to front end first)
URL: https://localhost:3443
*Portal Logins include:*
Any of the LDAP accounts listed above.
Once logged in, click on "Clusters" and then "HPC Cluster Shell Access" and you will be logged in to the cluster frontend container.

If running this example on a remote server a couple of SSH tunnels need to be setup
in order to access the OnDemand service via a local web browser. For convenience
scripts are provided in the **remote** directory. To automatically setup all necessary
tunnels do the following on your local host:
```
cd remote
./setup <hostname>
```

To see the tunnels execute the following in the **remote** directory:
```
./list_tunnels
```

Once done you can manually remove these tunnels by executing the following in
the **remote** directory:
```
./kill_tunnels
```

### HTCondor Node

The HTCondor container (`htc.mini`) acts as both the submit node and the execution point for this environment.

Login via SSH with user `hpcadmin`, password `ilovelinux`:
```
ssh -p 7222 hpcadmin@localhost
```

Once logged in, you can interact with HTCondor directly:
```
condor_status       # View available execution slots
condor_q            # View the job queue
condor_submit <job> # Submit a job
```

You can also SSH into the HTCondor container from inside Open OnDemand by clicking **Clusters → HTCondor Shell Access** in the top navigation bar.

## Tutorial Navigation
[Previous Step - Getting Started](getting_started.md)
[Docker Tips](docker_tips.md)
[Back to Start](../README.md)
