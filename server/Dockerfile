# syntax=docker/dockerfile:1

FROM python:3.8-slim-bullseye

WORKDIR /server

ENV FLASK_APP=server.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=80
ENV FLASK_DEBUG=True

COPY server.py server.py
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

CMD ["flask", "run"]
