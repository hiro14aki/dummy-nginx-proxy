FROM openresty/openresty:1.13.6.1-alpine

ARG RESTY_COOKIE_BRANCH=v0.1.0
ARG RESTY_IPUTILS_BRANCH=v0.3.0
ARG RESTY_HTTP_BRANCH=v0.12

RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    rm -rf /var/cache/apk/*


RUN mkdir -p /usr/local/src &&\
      apk add --no-cache --virtual .build-deps git make &&\
      git clone -b ${RESTY_COOKIE_BRANCH} https://github.com/cloudflare/lua-resty-cookie.git /usr/local/src/lua-resty-cookie &&\
      cd /usr/local/src/lua-resty-cookie && make -e PREFIX=usr/local/openresty install &&\
      git clone -b ${RESTY_IPUTILS_BRANCH} https://github.com/hamishforbes/lua-resty-iputils.git /usr/local/src/lua-resty-iputils &&\
      cd /usr/local/src/lua-resty-iputils && make -e PREFIX=usr/local/openresty install &&\
      git clone -b ${RESTY_HTTP_BRANCH} https://github.com/pintsized/lua-resty-http.git /usr/local/src/lua-resty-http &&\
      cd /usr/local/src/lua-resty-http && make -e PREFIX=usr/local/openresty install &&\
      apk del .build-deps &&\
      rm -rf /usr/local/src &&\
      mkdir -p /var/cache/nginx/proxy_cache &&\
      mkdir -p /var/cache/nginx/tmp

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
