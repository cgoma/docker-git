FROM ubuntu:16.04

# Update image
SHELL ["/bin/bash", "-c"]


# ssh
ENV SSH_PASSWD "root:Docker!"

RUN apt-get update && apt-get install -y --no-install-recommends libcurl4-openssl-dev python3-pip python3 libboost-python-dev python3-dev dialog openssh-server

RUN echo "$SSH_PASSWD" | chpasswd

RUN mkdir /code
WORKDIR /code

RUN pip3 install --upgrade pip
RUN pip install azure-iothub-service-client
RUN pip install bottle

COPY sshd_config /etc/ssh/
COPY init.sh /usr/local/bin/

RUN chmod u+x /usr/local/bin/init.sh

# Copy code (this assumes the ./src folder contains the code using the SDK and that the entrypoint is app.py)
COPY azure_cloud_api.py /code

EXPOSE 8000 2222
CMD ["python3", "-u", "/code/azure_cloud_api.py"]
