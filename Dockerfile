FROM ruby:3.1-slim

WORKDIR /usr/src/app

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --system

# コンテナの起動と共にシェルを起動し続ける
CMD ["tail", "-f", "/dev/null"]