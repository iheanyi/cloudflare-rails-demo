import { Container, getContainer } from "@cloudflare/containers";

interface Env {
  RAILS_APP: DurableObjectNamespace<RailsApp>;
  RAILS_MASTER_KEY: string;
  SOLID_QUEUE_IN_PUMA: string;
}

export class RailsApp extends Container {
  defaultPort = 80;

  override onStart(): void {
    // Container sleeps after idle and re-seeds SQLite on wake
  }
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const container = getContainer(env.RAILS_APP);

    return container.fetch(request, {
      headers: {
        "X-Forwarded-Proto": "https",
      },
    });
  },
};
