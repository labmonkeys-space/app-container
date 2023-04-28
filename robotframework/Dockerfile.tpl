###
# Do not edit the generated Dockerfile
###

# hadolint ignore=DL3006
FROM "${BASE_IMAGE}"

RUN adduser -S robot && \
    apk add --no-cache chromium-chromedriver \
                       chromium \
                       firefox \
                       tzdata \
                       xvfb && \
    pip install --upgrade pip

WORKDIR /home/robot

USER robot

ADD requirements.txt .

RUN pip install -r requirements.txt

ENV PATH="$PATH:/home/robot/.local/bin"

LABEL org.opencontainers.image.source="${VCS_SOURCE}" \
      org.opencontainers.image.revision="${VCS_REVISION}" \
      org.opencontainers.image.vendor="Labmonkeys Space" \
      org.opencontainers.image.authors="ronny@no42.org" \
      org.opencontainers.image.licenses="MIT"
