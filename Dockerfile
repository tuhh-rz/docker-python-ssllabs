FROM python:3

RUN apt-get update
RUN apt-get -y upgrade

RUN pip install requests

RUN git clone https://github.com/takeshixx/python-ssllabs.git /opt/python-ssllabs

WORKDIR /opt/python-ssllabs/

RUN python setup.py install

ENTRYPOINT ["ssllabs-cli.py"]
