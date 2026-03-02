import { Container, getContainer } from "@cloudflare/containers";

interface Env {
  RAILS_APP: DurableObjectNamespace<Container>;
  RAILS_MASTER_KEY: string;
  SOLID_QUEUE_IN_PUMA: string;
}

export { Container as RailsApp };

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
