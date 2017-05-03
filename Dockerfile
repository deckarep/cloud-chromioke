FROM ubuntu
#FROM centos:centos7
MAINTAINER Ralph Caraveo

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y ffmpeg
RUN apt-get install -y git
RUN apt-get install -y gcc
#RUN yum -y update; yum clean all
#RUN yum -y groupinstall 'Development Tools'

# Special repos needed for ffmpeg
#RUN yum -y install epel-release
#RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
#RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
#RUN yum install ffmpeg -y


# Create user
#RUN useradd -ms /bin/bash rust
# Switch to user
#USER rust

# Install Rust tools
RUN curl -sSf https://sh.rustup.rs > rustup.sh && chmod +x rustup.sh && ./rustup.sh -y --default-toolchain stable && rm rustup.sh
ENV PATH $PATH:/root/.cargo/bin
RUN rustup default stable

WORKDIR /tmpdir

RUN mkdir /qaraoke
WORKDIR /qaraoke

RUN cargo version
RUN git clone https://github.com/thequux/qaraoke
WORKDIR /qaraoke/qaraoke/cdg_renderer
RUN cargo build --release --example frame_dumper
RUN cp /qaraoke/qaraoke/target/release/examples/frame_dumper /usr/bin/frame_dumper
WORKDIR /tmpdir

# This mounted correctly
#docker run -it -v=`pwd`:/tmpdir --entrypoint='bash' stuff11
#ENTRYPOINT ["/usr/bin/ffmpeg"]
#ENTRYPOINT ["cargo", "version"]
ENTRYPOINT "./process.sh"