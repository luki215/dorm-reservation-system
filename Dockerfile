# Pick the ruby version for your rails app. This one is a rails 4 app and using ruby 2.2.3. Consider using 2.5.0 at least.
FROM ruby:2.5.1
# Installing some needed things here. Including ghostscript because this rails app works with pdfs. You may consider making adjustments. 
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev && apt-get install -y ghostscript git vim
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs
# Make the directory for the app
RUN mkdir /app
# Set the working directory of everything to the directory we just made.
WORKDIR /app
# Copy the gemfile and gemfile.lock so we can run bundle on it
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
# Install and run bundle to get the app ready
RUN gem install bundler
RUN bundle install
# Copy the Rails application into place
COPY app .
# Expose port 3000 on the container
EXPOSE 3000