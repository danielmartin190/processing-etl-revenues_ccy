FROM public.ecr.aws/docker/library/python:3.10-slim-buster as base
LABEL MAINTAINER="Next Digital Hub"
LABEL VERSION=0.0.1
# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
RUN python -m pip install --upgrade pip
# Set local timezone
RUN apt-get update && apt-get install tzdata -y
ENV TZ "Europe/Madrid"

FROM base AS build-deps
# Install system dependencies for build requirements.txt
RUN apt-get install --no-install-recommends -y gcc build-essential git \
	&& echo "[global]\nextra-index-url=https://www.piwheels.org/simple" > /etc/pip.conf

FROM build-deps AS python-deps
# Install python build dependencies
ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VERSION=1.5.1
RUN pip install poetry==${POETRY_VERSION}
COPY poetry.lock pyproject.toml ./
RUN poetry install --without=dev

FROM base AS deploy
# Install aws-cli for uploading test results
RUN apt-get install -y --no-install-recommends python curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

# Copy python dependencies and executables
COPY --from=python-deps /usr/local/lib/python3.10/ /usr/local/lib/python3.10/
COPY --from=python-deps /usr/local/bin/ /usr/local/bin/

RUN useradd -ms /bin/bash dbt

WORKDIR /home/dbt/app

# Add all source code
ADD ./ /home/dbt/app
RUN chown -R dbt /home/dbt/app

USER dbt

ENTRYPOINT [""]
