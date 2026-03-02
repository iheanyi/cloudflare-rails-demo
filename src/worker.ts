import { Container, getContainer } from "@cloudflare/containers";

interface Env {
  RAILS_APP: DurableObjectNamespace<RailsApp>;
  RAILS_MASTER_KEY: string;
}

export class RailsApp extends Container<Env> {
  defaultPort = 3000;
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
    const container = getContainer(env.RAILS_APP);
    return container.fetch(request);
  },
};
