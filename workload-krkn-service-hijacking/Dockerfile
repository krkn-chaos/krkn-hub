# syntax=docker/dockerfile:1

FROM registry.fedoraproject.org/f33/python3@sha256:eecc7743dab907acd2aa02544f445e970deab17ac3cdd2d4763fbf0b1517c341

LABEL krknctl.is_a_scenario="false"
LABEL krknctl.privileged="true"
LABEL krknctl.title="Krkn Service Hijacking Workload"
LABEL krknctl.description="Mock web service used by the Krkn service hijacking scenario."

WORKDIR /python-docker
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

USER root
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN pip3 install poetry
RUN poetry install

COPY . .

CMD [ "flask", "run", "--host=0.0.0.0"]
