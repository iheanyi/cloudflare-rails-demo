import { Container, getContainer } from "@cloudflare/containers";

interface Env {
  RAILS_APP: DurableObjectNamespace<RailsApp>;
  RAILS_MASTER_KEY: string;
}

export class RailsApp extends Container<Env> {
  defaultPort = 8080;
  sleepAfter = "5m";

  enableInternet = true;

  constructor(ctx: DurableObject["ctx"], env: Env) {
    super(ctx, env);
    this.envVars = {
      RAILS_MASTER_KEY: env.RAILS_MASTER_KEY,
      SOLID_QUEUE_IN_PUMA: "true",
      RAILS_ENV: "production",
      RAILS_SERVE_STATIC_FILES: "true",
      RAILS_LOG_TO_STDOUT: "true",
      HTTP_PORT: "8080",
      FORWARD_HEADERS: "true",
    };
  }

  override onStart(): void {
    console.log("Rails container started");
  }

  override onError(error: unknown): void {
    console.error("Rails container error:", error);
  }
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    try {
      const container = getContainer(env.RAILS_APP);
      const response = await container.fetch(request);
      console.log(`Container response: ${response.status} ${response.statusText}, content-length: ${response.headers.get("content-length")}`);
      return response;
    } catch (error) {
      console.error("Worker fetch error:", error);
      return new Response(
        `Worker error: ${error instanceof Error ? error.message : String(error)}`,
        { status: 500 }
      );
    }
  },
};
