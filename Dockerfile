# API python client docker build script
#
# Copyright (C) 2018 Layered Insight - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential

# docker build -t api-example-python .
FROM python:2.7.14-alpine3.7
RUN mkdir -p /layint/li_utils/
COPY * /layint/
COPY li_utils/* /layint/li_utils/

# add docker and curl for li_add_local_image
RUN apk update && \
    apk add gcc musl-dev curl docker && \
    pip install -r /layint/requirements.txt && \
    pip install --index-url https://test.pypi.org/simple/ layint-api==0.10a1

### Set environment variables for your installation
ENV LI_API_KEY ApiKey:username:setanapikey
ENV LI_API_HOST http://localhost/v0.01

ENTRYPOINT /bin/sh
