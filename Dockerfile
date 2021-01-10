FROM centos/s2i-base-centos7

# This image provides a Ruby 2.4 environment you can use to run your Ruby
# applications.

EXPOSE 8080

ENV RUBY_VERSION 2.4

ENV SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
    DESCRIPTION="Ruby $RUBY_VERSION available as container is a base platform for \
building and running various Ruby $RUBY_VERSION applications and frameworks. \
Ruby is the interpreted scripting language for quick and easy object-oriented programming. \
It has many features to process text files and to do system management tasks (as in Perl). \
It is simple, straight-forward, and extensible."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Ruby 2.4" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby24,rh-ruby24" \
      com.redhat.component="rh-ruby24-container" \
      name="centos/ruby-24-centos7" \
      version="2.4" \
      usage="s2i build https://github.com/sclorg/s2i-ruby-container.git --context-dir=2.4/test/puma-test-app/ centos/ruby-24-centos7 ruby-sample-app" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# To use subscription inside container yum command has to be run first (before yum-config-manager)
# https://access.redhat.com/solutions/1443553
    # INSTALL_PKGS="rh-ruby24 rh-ruby24-ruby-devel rh-ruby24-rubygem-rake rh-ruby24-rubygem-bundler" && \
    # yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    ## C9 update to install ruby 2.4.1 with installing nodejs to use yarn
RUN gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &&\
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
    yum -y clean all --enablerepo='*' && \
    # echo "source /etc/profile.d/rvm.sh" >> /etc/profile

# copy entrypoint-prod.sh
COPY ./bash.sh /etc

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 ${APP_ROOT} && chmod -R ug+rwx ${APP_ROOT} && \
    rpm-file-permissions

# RUN source /etc/profile.d/rvm.sh
# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
ENTRYPOINT [ " /etc/bash.sh " ]
