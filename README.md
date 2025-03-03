# Num Genius

Num Genius is a demo app that shows how to use Python package management with Poetry and AWS CodeArtifact. It uses the `numoperations` and `numviews` packages from a python-private-repository. To run the app, just execute:

```shell
cd numgenius
python3 main.py

 ··· Welcome to Num Genius! ···
   ························    

Here are the options:
    [1] Add numbers
    [2] Subtract numbers
    [3] Multiply numbers
    [4] Divide numbers
    [5] Exit

What would you like to do? Enter the number > 
```

## Building and Utilizing Packages with Poetry in AWS CodeArtifact

1. Make sure you have Poetry installed on the system. If not, you can install it by running the following command:

    ```shell
    pip install poetry
    ```

2. Initialize Poetry by running the following command:

    ```shell
    poetry init
    ```

    This will create a `pyproject.toml` file where the project dependencies and settings are defined.

3. Build the package by running the following command:

    ```shell
    poetry build
    ```

    This will create a distributable package (e.g., a `.tar.gz` or `.whl` file) in the `dist` directory.

4. Add your project dependencies to the `pyproject.toml` file. For example, if you have a dependency called `numoperations`, you can add it like this:

    ```toml
    [tool.poetry.dependencies]
    python = "^3.10"
    numoperations = "1.0.0"
    ```

    Replace `numoperations` with the actual name of your dependency and specify the desired version.

5. Because `numoperations` comes from a private repository, add its source to Poetry so you can fetch it. (See the Makefile)

    ```shell
    poetry source add --priority=supplemental ${SOURCE} https://${REPO_DOMAIN}-${REPO_OWNER}.d.codeartifact.${REPO_REGION}.amazonaws.com/pypi/${REPO_NAME}/simple
    ```

6. Install the project dependencies by running the following command:

    ```shell
    poetry install
    ```

    This will create a virtual environment and install the dependencies specified in the `pyproject.toml` file.

7. To publish to AWS CodeArtifact with Poetry, first configure the repository. (See the Makefile)

    ```shell
    # Configure pip in the repository for use with Poetry
    aws codeartifact login --tool pip --domain ${REPO_DOMAIN} --domain-owner ${REPO_OWNER} --repository ${REPO_NAME}

    # Add the repository to Poetry
    poetry source add --priority=supplemental ${SOURCE} https://${REPO_DOMAIN}-${REPO_OWNER}.d.codeartifact.${REPO_REGION}.amazonaws.com/pypi/${REPO_NAME}/

    # Set up the repository in Poetry
    poetry config repositories.${SOURCE} https://${REPO_DOMAIN}-${REPO_OWNER}.d.codeartifact.${REPO_REGION}.amazonaws.com/pypi/${REPO_NAME}/

    # Set up the credentials in Poetry
    poetry config http-basic.${SOURCE} ${POETRY_HTTP_BASIC_USERNAME} ${POETRY_HTTP_BASIC_PASSWORD}
    ```

    Make sure you have the necessary credentials and permissions to access CodeArtifacts.

8. Publish the package.

    ```shell
    poetry publish --repository aws
    ```

Once the package is uploaded to CodeArtifacts, it can be used in the AWS projects by specifying the package name and version in your project's dependencies.
