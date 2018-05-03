# WallEx
[![Build Status](https://travis-ci.org/juhalehtonen/wall_ex.svg?branch=master)](https://travis-ci.org/juhalehtonen/wall_ex)

A simple multi-user drawing canvas built with Elixir & Phoenix.

Uses WebSockets through Phoenix Channels to synchronize drawing in soft real-time amongst users, and stores drawings in ETS to serve existing drawings to new users when they open the canvas in their browser.

## Deployment

Deployment is done with Heroku (see `Procfile` and `app.json` for configuration). Currently you'll also need to configure the URL in `config/prod.exs`.

## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## License

Licensed under GNU Affero General Public License v3.0. See [LICENSE.md](LICENSE.md) for details.
