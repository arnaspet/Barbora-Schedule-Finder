FROM elixir:1.9 as builder

ENV MIX_ENV=prod

RUN apt-get update -yqq
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -yqq nodejs build-essential
RUN mix local.hex --force
RUN mix local.rebar --force

COPY . .
RUN mkdir -p /opt/release \
    && mix deps.get \
    && mix release \
    && mv _build/${MIX_ENV}/rel/barbora /opt/release


FROM erlang:22 as runtime

WORKDIR /usr/local/barbora
COPY --from=builder /opt/release/barbora .
CMD [ "bin/barbora", "start" ]
