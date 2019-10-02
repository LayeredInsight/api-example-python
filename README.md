[![Docker Pulls](https://img.shields.io/docker/pulls/layeredinsight/runtime-python-client.svg?style=plastic)](https://hub.docker.com/r/layeredinsight/runtime-python-client/)

# CS Runtime client API scripts
This is a collection of python scripts leveraging our Swagger library
to interact with the CS Runtime API services. They're intended
to be an example of what's possible, and a starting point...

## Usage
### We recommend using virtualenv with Python
We're fans of not polluting our systems to install python libraries. [Virtualenv](https://virtualenv.pypa.io/en/stable/) helps with this:
```
pip install virtualenv
```
`cd` to this source directory, or wherever you want to store a virtual environment and initialize a new virtual Python environment with...

```
virtualenv venv
. venv/bin/activate
```
Now any libraries you install with pip will be local to this environment, accessible only after sourcing `venv/bin/activate`

### Install the Runtime Python API library and dependencies
From this source directory, run

```
pip install layint-api
pip install -r requirements.txt
```

### Set environment variables for your installation
Please replace the apigateway domain in the example below with your appropriate customer FQDN for apigateway.
```
export LI_API_KEY=Bearer:`./GetAuthTokenRequest | curl -s -X POST https://apigateway.p24.eng.sjc01.qualys.com/auth -d@-`
export LI_API_HOST=https://apigateway.p24.eng.sjc01.qualys.com/crs/v1.2/api
# Test pods only, use `curl -k ...` and set
# export LI_VERIFY_SSL=false
```

## Finally, run the scripts
```
li_list_containers
```
## Script conventions
* Exit code 2 on argument (input) error
* Exit code 1 on service error



## Examples
[Script and CI pipeline examples](examples/README.md)
