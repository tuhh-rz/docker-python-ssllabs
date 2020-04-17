FROM python:latest

ARG VERSION=${VERSION}
ENV VERSION=$VERSION
RUN echo $VERSION

ARG DOWNLOAD=${DOWNLOAD}
ENV DOWNLOAD=$DOWNLOAD
RUN echo $DOWNLOAD


RUN apt-get update && apt-get -y upgrade

RUN pip install requests

RUN git clone -b v${VERSION} https://github.com/takeshixx/python-ssllabs.git /opt/python-ssllabs

WORKDIR /opt/python-ssllabs/

RUN python setup.py install

RUN groupadd -r ssllabs-cli && useradd --no-log-init -r -g ssllabs-cli ssllabs-cli

USER ssllabs-cli

ENTRYPOINT ["ssllabs-cli.py"]
