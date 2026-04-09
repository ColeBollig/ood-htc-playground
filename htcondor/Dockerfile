ARG HPCTS_VERSION=2025.02

FROM --platform=linux/amd64 hpcts-local-base:latest as stage-amd64
FROM --platform=linux/arm64 hpcts-local-base:latest as stage-arm64

ARG TARGETARCH
FROM stage-${TARGETARCH} as final

RUN dnf update -y

RUN curl -o /etc/yum.repos.d/turbovnc.repo https://raw.githubusercontent.com/TurboVNC/repo/main/TurboVNC.repo
RUN dnf -y install dnf-plugins-core

RUN dnf config-manager --set-enabled powertools

RUN dnf install -y \
    @Development \
    git \
    git-core \
    jq \
    less \
    nano \
    openssh-clients \
    openssh-server \
    procps-ng \
    python3 \
    python3-pip \
    sudo \
    supervisor \
    turbovnc \
    which

RUN python3 -m pip install --upgrade pip
RUN pip3 install jupyterlab jupyter-console qtconsole ipywidgets plotly pandas scikit-learn numpy

RUN dnf install -y epel-release
RUN dnf groupinstall -y 'Xfce'

RUN pip3 install websockify

RUN curl -fsSL https://get.htcondor.org | sudo /bin/bash -s -- --no-dry-run

RUN dnf clean all
RUN rm -rf /var/cache/dnf

RUN install -m 0700 -o root -g root -d /etc/condor/passwords.d
RUN install -m 0700 -o root -g root -d /etc/condor/tokens.d

COPY config/* /etc/condor/config.d/
COPY supervisord.conf /etc/supervisord.conf

COPY start.sh /
RUN chmod +x /start.sh

CMD [ "/start.sh" ]

