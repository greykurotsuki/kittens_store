FROM ruby:2.4.9

# Add the repository where we can find nodejs, postgresql-client, yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install NodeJS, Postgresql-clien and yarn
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn


WORKDIR /app

# Copy our repo to the /app directory that we've create in the previous step
COPY . .

ENV RACK_ENV=test

# Install Dependencies 
RUN bundle install

EXPOSE 1234
CMD [ "bundle", "exec", "rackup", "--port", "1234", "--host", "0.0.0.0" ]
