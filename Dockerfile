FROM ruby:2.4.9 AS BASE-GEMS

# Add the repository where we can find nodejs, postgresql-client, yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

COPY . /app
WORKDIR /app

ENV RACK_ENV=test

RUN bundle install


FROM ruby:2.4.9
COPY --from=BASE-GEMS /usr/local/bundle /usr/local/bundle
COPY . /app
WORKDIR /app