# Rails Kanban on Cloudflare Containers

A real-time collaborative kanban board built with Rails 8 and deployed on [Cloudflare Containers](https://developers.cloudflare.com/containers/). Demonstrates how a full-featured Rails app — complete with WebSockets, background jobs, and SQLite — runs inside Cloudflare's container platform.

## Tech Stack

- **Rails 8** with Propshaft and jsbundling (esbuild)
- **Hotwire** (Turbo + Stimulus) for real-time UI updates
- **Tailwind CSS** for styling
- **SQLite** for the database
- **ViewComponents** for encapsulated view logic
- **Action Cable** with Solid Cable adapter (no Redis needed)
- **SortableJS** for drag-and-drop
- **TypeScript** for client-side JavaScript
- **Cloudflare Containers + Workers** for deployment

## Features

- **Drag-and-drop** — reorder cards and move them between columns with SortableJS
- **Real-time collaboration** — changes broadcast to all connected clients via Action Cable
- **Inline editing** — edit card titles in place
- **Presence indicators** — see who else is viewing the board
- **Auto-seeding demo data** — the board resets with sample data on every cold start

## Local Development

```sh
bundle install
npm install
bin/rails db:setup
npm run build
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000).

## Running Tests

```sh
bin/rails test
bin/rails test:system
```

## Deploy to Cloudflare Containers

### Prerequisites

- A [Cloudflare account](https://dash.cloudflare.com/sign-up)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/install-and-update/) installed
- [Docker](https://www.docker.com/) installed and running

### Set Secrets

```sh
npx wrangler secret put RAILS_MASTER_KEY
```

### Deploy

```sh
npx wrangler deploy
```

The Cloudflare Worker acts as a lightweight proxy, forwarding all incoming requests to the containerized Rails app.

## Architecture Overview

- **Worker → Container proxy** — A Cloudflare Worker (`src/worker.ts`) uses the `@cloudflare/containers` SDK to route every request to a Durable Object-backed Docker container running Rails with Thruster and Puma.
- **Ephemeral SQLite** — The container's disk resets when it sleeps, so the app re-seeds demo data on every cold start via `bin/docker-entrypoint` (`db:prepare` + `db:seed`).
- **Real-time without Redis** — Action Cable uses the Solid Cable adapter, which stores messages in SQLite. No external pub/sub service needed.
- **Full-page Turbo Stream broadcasts** — When any card changes, the entire columns container is re-rendered and broadcast to all clients for simplicity.
- **Client-side drag-and-drop** — SortableJS handles reordering on the client, then posts position changes to the server via PATCH requests.

## License

MIT
