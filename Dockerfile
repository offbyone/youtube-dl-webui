# For ubuntu, the latest tag points to the LTS version, since that is
# recommended for general use.
FROM python:3.6-slim
MAINTAINER Chris Rose <offline@offby1.net>

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -x \
	&& buildDeps=' \
		unzip \
		ca-certificates \
		dirmngr \
		wget \
		xz-utils \
		gpg \
		gosu \
		ffmpeg \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps \
	&& gosu nobody true

ADD . /usr/src/youtube_dl_webui
WORKDIR /usr/src/youtube_dl_webui

RUN : \
	&& pip install --no-cache-dir . 

COPY docker-entrypoint.sh /usr/local/bin
COPY default_config.json /config.json
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["python", "-m", "youtube_dl_webui"]
