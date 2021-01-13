FROM image-registry.openshift-image-registry.svc:5000/time-stack-4/ruby:2.4.1

ARG BUNDLER_VERSION
# ARG NODE_MAJOR

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    nodejs \
    # yarn=$YARN_VERSION-1 && \
    yarn && \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Configure bundler and PATH
# ENV LANG=C.UTF-8 \
#     GEM_HOME=/bundle \
#     BUNDLE_JOBS=4 \
#     BUNDLE_RETRY=3
# ENV BUNDLE_PATH $GEM_HOME
# ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
#     BUNDLE_BIN=$BUNDLE_PATH/bin
# ENV PATH /app/bin:$BUNDLE_BIN:$PATH

# Upgrade RubyGems and install required Bundler version 
# RUN gem update --system && \
#     gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

# Setting env up
ENV RAILS_ENV='development'
ENV NODE_ENV='development'

# Adding gems
# COPY Gemfile Gemfile
# COPY Gemfile.lock Gemfile.lock

# RUN bundle install --jobs 20 --retry 5 --without development test 

# COPY . .

# RUN yarn install && bundle exec rake assets:precompile

# RUN rm -f /app/config/master.key && rm -f /app/config/credentials.yml.enc
