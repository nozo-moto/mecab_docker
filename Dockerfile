FROM alpine:3.9.4 AS build-env
RUN apk add --update --no-cache build-base
ENV mecab https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
ENV ipa https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM
RUN apk add --update --no-cache curl git bash file sudo openssh openssl perl \
  # Install mecab
  && curl -SL -o mecab-0.996.tar.gz ${mecab} \
  && tar zxf mecab-0.996.tar.gz \
  && cd mecab-0.996 \
  && ./configure \
  && make \
  && make install \
  # Install mecab-ipa
  && curl -SL -o mecab-ipadic-2.7.0-20070801.tar.gz ${ipa} \
  && tar zxf mecab-ipadic-2.7.0-20070801.tar.gz \
  && cd mecab-ipadic-2.7.0-20070801 \
  && ./configure \
  && make \
  && make install \
  # Insatll mecab ipadic neologd
  && git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
  && cd mecab-ipadic-neologd \
  && ./bin/install-mecab-ipadic-neologd -n -y 

CMD ["/usr/local/bin/mecab", "-d", "/usr/local/lib/mecab/dic/mecab-ipadic-neologd"]
