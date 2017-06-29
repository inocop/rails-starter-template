FROM centos:6

MAINTAINER inocop


# yum install 
RUN yum install -y \
		wget \
		httpd \
		gcc-c++ \
		glibc-headers  \
		openssl-devel  \
		readline \
		libyaml-devel  \
		readline-devel  \
		zlib  \
		zlib-devel \
		sqlite-devel \
		mysql

# enable .htaccess
RUN sed -i -e "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf


# install git
WORKDIR /etc/yum.repos.d/
RUN wget http://wing-repo.net/wing/6/EL6.wing.repo
RUN yum install -y git


# git clone
WORKDIR /tmp
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build


# env for ruby
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

#RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
#&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
#&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc


# install ruby on rails
RUN bash -l -c 'rbenv install -v 2.3.1'
RUN bash -l -c 'rbenv rehash'
RUN bash -l -c 'rbenv global 2.3.1'
RUN bash -l -c 'gem update --system'
RUN bash -l -c 'gem install --no-ri --no-rdoc rails --version 4.2.2'
RUN bash -l -c 'gem install bundler'
RUN bash -l -c 'rbenv rehash'


CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
