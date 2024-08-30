FROM ubuntu:22.04

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget

# Flutterのインストール
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# 環境変数の設定
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Flutterの事前ダウンロードと設定
RUN flutter precache
RUN flutter doctor

# Android SDKのインストール
ENV ANDROID_SDK_ROOT /usr/local/android-sdk
ENV ANDROID_HOME /usr/local/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O android-sdk.zip \
    && unzip -q android-sdk.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm android-sdk.zip
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Android SDKのコンポーネントインストール
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

# 作業ディレクトリの設定
WORKDIR /app

CMD ["/bin/bash"]
