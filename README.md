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
# TODO, update pypi layint-api: 
#   pip install layint-api # for crs-public-python-client
release=9a6fcf88
wget https://art-hq.intranet.qualys.com/artifactory/third-party/crs-private-python-client.${release}.zip
unzip crs-private-python-client.${release}.zip
cd python-client
pip install -e .
cd ..
pip install -r requirements.txt
```

### Set environment variables for your installation
Please replace the apigateway domain in the example below with your appropriate customer FQDN for apigateway.

Production Pods:
```
export LI_API_KEY="Bearer:`./GetAuthTokenRequest | curl -s -X POST https://apigateway.pXX.eng.sjc01.qualys.com/auth -d@-`
export LI_API_HOST=https://apigateway.pXX.eng.sjc01.qualys.com/crs/v1.2/api
```
Engineering Pods:
```
# Test pods only, use `curl -k ...` and set
export LI_VERIFY_SSL=false
export LI_API_KEY="Bearer:`./GetAuthTokenRequest | curl --insecure -s -X POST https://apigateway.p24.eng.sjc01.qualys.com/auth -d@-`
# FIXME: export LI_API_HOST=https://apigateway.p24.eng.sjc01.qualys.com/crs/v1.2/api
export LI_API_HOST=https://kubelb.p24.eng.sjc01.qualys.com/crs/v1.2/api
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
