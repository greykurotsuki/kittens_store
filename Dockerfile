FROM ruby:2.4.9

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

WORKDIR /app

COPY . .

# Install Dependencies 
RUN bundle install

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0" , "--port", "1234"]