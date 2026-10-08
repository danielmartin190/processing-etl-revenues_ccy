# Revenues CCY

>Calculate Revenues CCY for financial area

## Setup

### Requirements

* Pyenv
* Poetry

### Get ready

#### Install the required python version

[pyenv](https://github.com/pyenv/pyenv) is recommended for handling Python versions:

```bash
$ pyenv install
$ pyenv local
```

**NOTE**: The python version will be chosen from the `.python-version` file.

#### Install poetry

```bash
$ pip install poetry
```

- Install required `poetry-dotenv-plugin` python package to enable export .env into the shell. Note that this package must be installed outside the virtual environment.

```bash
$ pip install poetry-dotenv-plugin
```

## Usage

Using `make help` or `make` you will be able to see useful commands.

### Configure development enviroment

#### Install dependencies

```bash
$ make install
```

#### Set environment variables

1. Copy the file `.example.env` to a file named `.env` in the root of the repository.
2. Fill in with your secrets.
3. Export environment variables.
    - If you have `poetry-dotenv-plugin` installed variables will be exported automatically when you activate the virtual environment.
    - If the environment was already activated or `poetry-dotenv-plugin` is not working you can export them running:
        ```bash
        set -a; source .env; set +a
        ```
#### Set up dbt project

1. Activate de virtual environment using `make shell`.
2. Install dbt packages by running `dbt deps`
2. Run `dbt debug` to check everything is correctly configured.

Now you can use DBT 🎉

### Configure GitLab repository env variables

Depending on the CICD pipeline chosen, it may be necessary to configure some environment variables in the repository itself _(Repository Settings > CI/CD > Variables)_, or in the parent groups of the repository:

[Config variables in your project](https://gitlab.com/iberia-data/data-engineering/etls/ci-cd-pipelines-conf/-/tree/main/dbt?ref_type=heads#prerequisites)

## Keeping the project up to date with the template

Copier supports evolving a template and bringing projects up to date with the changes made to the template.

In order to do this, execute the following command from your project:

```bash
copier update -r vx.x.x --trust
```

## Resources:

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
# processing-etl-revenues_ccy
