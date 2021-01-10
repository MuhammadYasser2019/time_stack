#!/bin/bash
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &&\
curl -sSL https://get.rvm.io/ | bash -s stable && \
usermod -a -G rvm root && \
source /etc/profile.d/rvm.sh && \
export PATH=/usr/local/rvm/bin:$PATH && \
rvm requirements && \
rvm install  ruby-2.4.1 && \
ruby -v && \
yum install -y ImageMagick-devel && \
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg && \
curl --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
yum install -y nodejs yarn && \
yum -y clean all --enablerepo='*'

echo "Ruby version is $(ruby -v)"