FROM java:8

MAINTAINER Ignacio Mendizabal < ops@inaka.net >

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get -y install --reinstall locales && \
    dpkg-reconfigure locales && \
    echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    localedef --list-archive && locale -a &&  \
    update-locale &&  \
    apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
RUN mkdir -p /usr/local/android-sdk-linux
RUN cd /tmp &&\
      wget "${ANDROID_SDK_URL}" && \
      unzip tools_r25.2.3-linux.zip && \
      mv /tmp/tools /usr/local/android-sdk-linux/tools && \
      rm -rf /tmp/*

ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH


RUN cd /tmp && \
  wget https://services.gradle.org/distributions/gradle-3.4-bin.zip && \
  unzip -d /opt/gradle gradle-3.4-bin.zip && \
  rm -rf /tmp/*

ENV PATH $PATH:/opt/gradle/gradle-3.4/bin

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS -Xms256m -Xmx512m



COPY android_sdk_components.env /android_sdk_components.env
RUN echo y | android update sdk --no-ui --all --filter "$(cat /android_sdk_components.env)"

WORKDIR /root
CMD ["/bin/bash"]
