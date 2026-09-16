ARG HPCTS_VERSION=2025.02

FROM --platform=linux/amd64 hpcts-local-base:latest as stage-amd64

RUN dnf -y config-manager --set-enabled powertools
RUN dnf install -y epel-release
RUN dnf -y module enable nodejs:20 ruby:3.3
RUN dnf install -y https://yum.osc.edu/ondemand/4.0/ondemand-release-web-4.0-1.el8.noarch.rpm

RUN dnf install -y \
    less \
    libyaml-devel \
    munge \
    munge-devel \
    nano \
    netcat \
    ondemand \
    ondemand-dex \
    python3 \
    python3-pip \
    sudo \
    which

RUN gem install rdoc -v 6.3.3

FROM --platform=linux/arm64 hpcts-local-base:latest as stage-arm64

RUN dnf install -y file lsof sudo gcc gcc-c++ git \
        patch lua-posix rsync ruby ruby-devel python2 python3 \
        nodejs sqlite sqlite-devel nmap-ncat httpd httpd-devel mod_ssl \
        libcurl-devel autoconf openssl-devel jansson-devel libxml2-devel \
        libxslt-devel gd-devel libaio-devel libyaml-devel \

RUN gem install rake dotenv bcrypt && gem install rdoc -v 6.3.3

COPY . /build
RUN /build/install-dex-arm64.sh
RUN /build/install-passenger-arm64.sh
RUN /build/install-ood-arm64.sh
RUN rm -rf /build

ARG TARGETARCH

FROM stage-${TARGETARCH} as final

COPY . /build
RUN /build/install.sh && rm -rf /build
COPY cluster_config/* /etc/ood/config/clusters.d/
COPY bc_desktop /etc/ood/config/apps/bc_desktop
COPY jupyter /var/www/ood/apps/sys/jupyter
COPY python_job_template /etc/ood/config/apps/myjobs/templates/python
COPY motd /etc/motd
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY notebook_data /data/notebook_data
COPY initializers /etc/ood/config/apps/dashboard/initializers
COPY themes/hpc-coop /usr/share/ondemand-dex/web/themes/hpc-coop
COPY config/dashboard/env /etc/ood/config/apps/dashboard/env
COPY config/ondemand.yml /etc/ood/config/ondemand.d/ondemand.yml
COPY config/dashboard/widgets /etc/ood/config/apps/dashboard/views/widgets

COPY htcondor_adapter_patch.rb /tmp/htcondor_adapter_patch.rb
RUN targets=$(find / -xdev -path "*/gems/ood_core-*/lib/ood_core/job/adapters/htcondor.rb" 2>/dev/null) && \
    if [ -z "$targets" ]; then echo "ERROR: could not locate ood_core's htcondor.rb to patch" >&2; exit 1; fi && \
    echo "$targets" | while read -r target; do cp /tmp/htcondor_adapter_patch.rb "$target"; done && \
    rm /tmp/htcondor_adapter_patch.rb

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
