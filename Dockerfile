FROM python:latest

RUN apt-get update && apt-get -y upgrade

RUN pip install requests

RUN git clone https://github.com/takeshixx/python-ssllabs.git /opt/python-ssllabs

WORKDIR /opt/python-ssllabs/

RUN python setup.py install

RUN groupadd -r ssllabs-cli && useradd --no-log-init -r -g ssllabs-cli ssllabs-cli

USER ssllabs-cli

ENTRYPOINT ["ssllabs-cli.py"]
