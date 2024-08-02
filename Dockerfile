# Build the release
# -----------------

FROM hexpm/elixir:1.17.2-erlang-27.0.1-debian-bullseye-20240722 as build
ENV MIX_ENV=prod

WORKDIR /source
RUN mix local.hex --force && mix local.rebar --force

# Cache dependencies
COPY mix.exs mix.lock config ./
RUN mix do deps.get, deps.compile

# Compile and build the app
COPY . .
RUN mix do compile, release


# Run the app
# -----------

FROM hexpm/elixir:1.17.2-erlang-27.0.1-debian-bullseye-20240722 as build
ENV MIX_ENV=prod
EXPOSE 3000

WORKDIR /app
COPY --from=build /source/_build/${MIX_ENV}/rel/g_g .

CMD ["bin/g_g", "start"]
