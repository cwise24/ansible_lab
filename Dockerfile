#set base
FROM python:alpine3.15

MAINTAINER Chad Wise <cwise24@gmail.com>

COPY requirements.txt .
RUN apk upgrade 
RUN apk --update add --no-cache --virtual .pynacl_deps build-base g++ gcc libffi-dev libressl-dev musl-dev libxml2-dev libxslt-dev jpeg-dev zlib-dev
RUN apk --update add openssl-dev python3 python3-dev py3-pip openssh git bash bash-completion vim jq curl wget && \
    echo "Installing Ansible and tools" && \
    pip3 install -r requirements.txt 

RUN adduser --disabled-password ansible
RUN apk del libressl-dev musl-dev libffi-dev .pynacl_deps

USER ansible
WORKDIR /home/ansible

RUN mkdir -p /home/ansible/.ssh && \
    touch /home/ansible/.ssh/known_hosts && \
    touch /home/ansible/.bashrc && \
    mkdir -p /home/ansible/ansible_lab && \
    touch /home/ansible/.ansible.cfg

COPY --chown=ansible error.yml /home/ansible/ansible_lab/.
COPY --chown=ansible noerror.yml /home/ansible/ansible_lab/.
COPY --chown=ansible switch_conf.yml /home/ansible/ansible_lab/.
