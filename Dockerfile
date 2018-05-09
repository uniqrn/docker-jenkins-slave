FROM alpine:latest
LABEL maintainer "unicorn research Ltd"

ARG googlesdk="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-185.0.0-linux-x86_64.tar.gz"

RUN apk update \
  && apk add --no-cache git openssh curl python docker openjdk8-jre make bash

WORKDIR /tmp
RUN curl ${googlesdk} -o google-cloud-sdk.tar.gz

# Create jenkins user in docker group.
RUN adduser -s /bin/sh -h /home/jenkins jenkins -D \
  && passwd -u jenkins \
  && addgroup jenkins docker

COPY profile /home/jenkins/.profile
RUN chown jenkins.jenkins /home/jenkins/.profile

USER jenkins
WORKDIR /home/jenkins
RUN tar xzf /tmp/google-cloud-sdk.tar.gz \
  && CLOUDSDK_CORE_DISABLE_PROMPTS=1 ./google-cloud-sdk/install.sh \
  && CLOUDSDK_CORE_DISABLE_PROMPTS=1 /home/jenkins/google-cloud-sdk/bin/gcloud components install kubectl \
  && CLOUDSDK_CORE_DISABLE_PROMPTS=1 /home/jenkins/google-cloud-sdk/bin/gcloud components update

USER root
COPY start.sh /start.sh
COPY sshd_config /etc/ssh/sshd_config

ENTRYPOINT [ "/start.sh" ]
