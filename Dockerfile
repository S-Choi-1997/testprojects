FROM ubuntu:22.04

# 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    unzip \
    nginx \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Node.js 설치 (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Gradle 설치
RUN wget https://services.gradle.org/distributions/gradle-8.5-bin.zip \
    && unzip gradle-8.5-bin.zip -d /opt \
    && rm gradle-8.5-bin.zip \
    && ln -s /opt/gradle-8.5/bin/gradle /usr/bin/gradle

WORKDIR /workspace

CMD ["/bin/bash"]
