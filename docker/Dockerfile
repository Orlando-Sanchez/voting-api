FROM ruby:3.0.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /voting-app
COPY Gemfile /voting-app/Gemfile
COPY Gemfile.lock /voting-app/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN useradd -m myuser
USER myuser
# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]