FROM php:7.4-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libgd-dev \
    libxslt1-dev \
    libzip-dev \
    libonig-dev \
    libmagickwand-dev \
    libtool \
    build-essential \
    unzip \
    memcached \
    libmemcached-dev \
    zlib1g-dev \
    libzstd-dev \
    && apt-get clean


# Install PHP extentions
RUN docker-php-ext-install \
    mysqli \
    curl \
    json \
    xsl \
    gd \
    xml \
    zip \
    soap \
    bcmath \
    mbstring \
    gettext \
    && docker-php-ext-enable mysqli

# Install Imagick through PECL, delete previous versions
RUN apt-get update && apt-get install -y libmagickwand-dev \
    && pecl uninstall imagick \
    && pecl install -f imagick \
    && docker-php-ext-enable imagick

## Install Memcached with custom support
RUN if ! php -m | grep -q 'memcached'; then \
        pecl install memcached && \
        docker-php-ext-enable memcached; \
    else \
        echo "Memcached already installed."; \
    fi

# Clean up unnecessary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN chown -R www-data:www-data /var/www/*

WORKDIR /var/www