FROM ubuntu:20.10

# ENV
ENV HOME=/home/developer
ENV FLUTTER_CHANNEL=beta
ENV FLUTTER_VERSION=1.26.0-17.6.pre
ENV ANDROID_TOOLS=4333796

# PATH
ENV FLUTTER_HOME=${HOME}/flutter
ENV ANDROID_HOME=${HOME}/android
ENV TOOLS_HOME=${ANDROID_HOME}/tools
ENV PATH=${ANDROID_HOME}:${ANDROID_HOME}/emulator:${TOOLS_HOME}:${TOOLS_HOME}/bin:${ANDROID_HOME}/platform-tools:${PATH}
ENV PATH=${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}
ENV PATH=$HOME/.pub-cache/bin:$PATH

# PREREQUISITES
RUN apt update 
RUN apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget build-essential
RUN java -version

# USER
RUN useradd -ms /bin/bash developer
RUN usermod -aG sudo developer
USER developer
WORKDIR $HOME

# ANDROID
RUN mkdir -p $ANDROID_HOME
RUN mkdir -p .android
RUN touch .android/repositories.cfg
RUN wget --quiet https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_TOOLS.zip -O sdk-tools.zip
RUN unzip sdk-tools.zip -d ${ANDROID_HOME}
RUN rm sdk-tools.zip
RUN ls ${ANDROID_HOME}
RUN yes | sdkmanager --licenses
RUN sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" 


# FLUTTER
RUN wget --quiet --output-document=flutter.tar.xz https://storage.googleapis.com/flutter_infra/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz

RUN tar xf flutter.tar.xz -C $(dirname ${FLUTTER_HOME})
RUN rm flutter.tar.xz
RUN flutter doctor -v
