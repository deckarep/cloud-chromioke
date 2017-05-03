FROM ubuntu
MAINTAINER Ralph Caraveo

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y ffmpeg
RUN apt-get install -y git
RUN apt-get install -y gcc
RUN apt-get install -y unzip
RUN apt-get install -y golang

# Install Rust tools
RUN curl -sSf https://sh.rustup.rs > rustup.sh && chmod +x rustup.sh && ./rustup.sh -y --default-toolchain stable && rm rustup.sh
ENV PATH $PATH:/root/.cargo/bin
RUN rustup default stable

WORKDIR /tmpdir

RUN mkdir /qaraoke
WORKDIR /qaraoke

# Build frame_dumper
RUN cargo version
RUN git clone https://github.com/thequux/qaraoke
WORKDIR /qaraoke/qaraoke/cdg_renderer
RUN cargo build --release --example frame_dumper
RUN cp /qaraoke/qaraoke/target/release/examples/frame_dumper /usr/bin/frame_dumper
WORKDIR /tmpdir

ADD main.go .
EXPOSE 8080

# This mounted correctly
#docker run -it -v=`pwd`:/tmpdir --entrypoint='bash' cdg
#ENTRYPOINT ["./process.sh"]
ENTRYPOINT ["go", "run", "main.go"]
