# Container with project environment

FROM python:3.6.5-slim

COPY requirements.txt /tmp/

RUN set -x \
    && buildDeps=' \
		gcc g++ make \
	' \
    && apt-get update && apt-get install -y --no-install-recommends \
		git \
        libffi-dev \
        libmysqlclient-dev \
		openssh-server \
		sudo \
        $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
    && apt-get purge -y --auto-remove $buildDeps

# SSH is installed for development environment only. Don't run it in production.
RUN mkdir /var/run/sshd && \
    echo 'root:dev' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/Port 22/Port 8222/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV PYTHONDONTWRITEBYTECODE 1

EXPOSE 8211
EXPOSE 8222


Add CommentCollapse 

