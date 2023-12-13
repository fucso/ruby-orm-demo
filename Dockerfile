FROM ruby:3.1-slim

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --system

# コンテナの起動と共にシェルを起動し続ける
CMD ["tail", "-f", "/dev/null"]