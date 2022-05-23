FROM ruby:3.0.0

COPY Gemfile* ./

RUN apt-get update && \
    apt-get install build-essential -y --no-install-recommends \
    vim \
    git \
    gnupg2 \
    curl \
    wget \
    patch \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev \
    libmariadb-dev

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_12.x  | bash - \
    && apt-get install -y nodejs \
    && apt-get update && apt-get install yarn --no-install-recommends -y

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV APP_DIR /app
RUN mkdir -p $APP_DIR

# Set working directory

WORKDIR $APP_DIR

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler -v 2.1.4
RUN bundle install --jobs 20 --retry 5

COPY package.json .
COPY yarn.lock .
RUN yarn install --check-files

EXPOSE $RAILS_PORT