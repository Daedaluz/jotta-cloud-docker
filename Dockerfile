FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    unzip curl apt-transport-https ca-certificates tmux htop && \
    curl -fsSL https://repo.jotta.cloud/public.gpg -o /usr/share/keyrings/jotta.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/jotta.gpg] https://repo.jotta.cloud/debian debian main" > /etc/apt/sources.list.d/jotta.list && \
    apt update && apt install -y jotta-cli
ENV DATA_DIR=/data
VOLUME /data
CMD ["sh", "-c", "jottad stdoutlog datadir $DATA_DIR"]