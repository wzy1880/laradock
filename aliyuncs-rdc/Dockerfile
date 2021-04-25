FROM registry.cn-beijing.aliyuncs.com/rdc-builds/base:1.0

LABEL maintainer="young <446813218@qq.com>"

ENV DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

COPY ./sources.sh /tmp/sources.sh
COPY ./init.sh /tmp/init.sh

RUN chmod 777 /tmp/init.sh
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list; \
        sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list; \
        sed -i 's/security-cdn.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list; \
        chmod +x /tmp/sources.sh; \
        /bin/sh -c /tmp/sources.sh; \
        rm -rf /tmp/sources.sh

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5

RUN set -eux \
    # Add the "PHP 8" ppa
    && apt-get update  \
    && apt-get upgrade -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    #
    #--------------------------------------------------------------------------
    # Software's Installation
    #--------------------------------------------------------------------------
    #
    && echo 'DPkg::options { "--force-confdef"; };' >> /etc/apt/apt.conf \
    # Install "PHP Extentions", "libraries", "Software's"
    && apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        php8.0-cli \
        php8.0-common \
        php8.0-curl \
        php8.0-intl \
        php8.0-xml \
        php8.0-mbstring \
        php8.0-mysql \
        php8.0-pgsql \
        php8.0-sqlite \
        php8.0-sqlite3 \
        php8.0-zip \
        php8.0-bcmath \
        php8.0-memcached \
        php8.0-gd \
        php8.0-dev \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        rsync \
        sqlite3 \
        git \
        curl \
        vim \
        nano \
        tree \
        postgresql-client \
    && apt-get clean \
    ####################################
     #Composer:
    ####################################
     #Install composer and add its bin to the PATH.
    && curl -s https://install.phpcomposer.com/installer | php \
    && echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc \
    && mv composer.phar /usr/local/bin/composer

RUN groupadd -r mysql && useradd -r -g mysql mysql \
    && apt-get install --allow-unauthenticated -y mysql-server
#RUN mysqld --user=root& \
    #sleep 2s
RUN rm -rf /var/lib/mysql && mkdir /var/lib/mysql \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 1777 /var/run/mysqld /var/lib/mysql \
    && echo 'user=mysql' >> /etc/mysql/mysql.conf.d/mysqld.cnf \
    && mysqld --initialize-insecure

RUN /bin/sh -c /tmp/init.sh

