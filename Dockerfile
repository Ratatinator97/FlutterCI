FROM ubuntu:18.04
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer
RUN mkdir -p Android/Sdk/cmdline-tools
ENV ANDROID_SDK_ROOT /home/developer/Android/Sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv cmdline-tools Android/Sdk/cmdline-tools/tools
RUN cd Android/Sdk/cmdline-tools/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/Sdk/cmdline-tools/tools/bin && ./sdkmanager "build-tools;30.0.3" "platform-tools" "platforms;android-30" "sources;android-30"
RUN git clone https://github.com/flutter/flutter.git
RUN cd flutter && git checkout beta
ENV PATH "$PATH:/home/developer/flutter/bin"
RUN flutter doctor -v