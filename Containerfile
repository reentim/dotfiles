# 1. Base image
FROM debian:latest

# 2. Install the tools you want available *inside* the container
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      bash \
      vim-nox \
      tmux \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 3. Create an unprivileged user that matches your host UID (here 1000)
RUN useradd -m -u 1000 -s /bin/bash dev

# 4. Set sane defaults for the container runtime
USER dev
WORKDIR /home/dev
CMD ["bash"]
