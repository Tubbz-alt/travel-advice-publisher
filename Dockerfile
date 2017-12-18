FROM ruby:2.2.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential nodejs && apt-get clean

# for capybara-webkit
RUN apt-get update -qq && apt-get install -y libqt4-webkit libqt4-dev xvfb

ENV GOVUK_APP_NAME travel-advice-publisher
ENV MONGODB_URI mongodb://mongo/travel-advice-publisher
ENV PORT 3035
ENV RAILS_ENV development
ENV REDIS_HOST redis
ENV TEST_MONGODB_URI mongodb://mongo/travel-advice-publisher-test

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ARG COMPILE_ASSETS=false
RUN if [ "$COMPILE_ASSETS" = "true" ] ; then bundle exec rails assets:precompile ; fi

HEALTHCHECK CMD curl --silent --fail localhost:$PORT || exit 1

CMD bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p $PORT -b '0.0.0.0'"
