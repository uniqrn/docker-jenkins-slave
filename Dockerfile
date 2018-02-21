FROM alpine:latest
LABEL maintainer "unicorn research Ltd"

RUN apk update \
  && apk add --no-cache git openssh curl python docker openjdk8-jre

WORKDIR /tmp
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-185.0.0-linux-x86_64.tar.gz -o google-cloud-sdk.tar.gz \
  && tar xzf google-cloud-sdk.tar.gz
RUN CLOUDSDK_CORE_DISABLE_PROMPTS=1 /tmp/google-cloud-sdk/install.sh

COPY sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -A

# Create jenkins user in docker group.
RUN adduser -s /bin/sh -h /home/jenkins jenkins -D \
  && passwd -u jenkins \
  && addgroup jenkins docker

COPY start.sh /start.sh
WORKDIR /root
ENTRYPOINT [ "/start.sh" ]
