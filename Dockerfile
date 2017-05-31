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

COPY sdk-tools-linux-3859397.zip /tmp/sdk-tools-linux-3859397.zip
RUN mkdir -p /usr/local/android-sdk-linux
RUN cd /tmp &&\
    unzip -d /usr/local/android-sdk-linux/ sdk-tools-linux-3859397.zip && \
    rm -rf /tmp/*

ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH $ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$PATH


COPY gradle-3.4-bin.zip /tmp/gradle-3.4-bin.zip
RUN cd /tmp && \
    unzip -d /opt/gradle gradle-3.4-bin.zip && \
    rm -rf /tmp/*

ENV PATH $PATH:/opt/gradle/gradle-3.4/bin

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS -Xms256m -Xmx512m


COPY android_sdk_components.env /tmp/android_sdk_components.env
RUN cd /tmp && sdkmanager --update && \
    yes | sdkmanager --licenses && \
    sdkmanager --package_file=android_sdk_components.env && \
    rm -rf /tmp/*

WORKDIR /root
CMD ["/bin/bash"]
