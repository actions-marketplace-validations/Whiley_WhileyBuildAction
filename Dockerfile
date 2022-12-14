# =======================================
# For interactive shel:
# 
# > docker run -i -t $IMAGE wybuild /bin/sh
# =======================================
FROM ubuntu:focal
# Makesure not interactive!
ENV DEBIAN_FRONTEND noninteractive
# Update image and install git
RUN apt-get update && apt-get install -y \
   openjdk-11-jdk \
   curl \
   wget \
   apt-transport-https \
   zip \
   build-essential \
   pkg-config \
   libssl-dev
#   
WORKDIR /root
# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
# Install Z3
COPY install_z3.sh /install_z3.sh
RUN /install_z3.sh
# Install Boogie
COPY install_boogie.sh /install_boogie.sh
RUN /install_boogie.sh
# Configure PATH
ENV PATH="/root/.cargo/bin:/root/z3/bin:/root/.dotnet/tools:${PATH}"
# Install Whiley
RUN cargo install whiley
# Set the default command
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
