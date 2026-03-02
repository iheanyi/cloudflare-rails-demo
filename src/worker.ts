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

const LOADING_PAGE = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Starting up...</title>
  <meta http-equiv="refresh" content="5">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: #0f172a;
      color: #e2e8f0;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
    }
    .container { text-align: center; }
    h1 { font-size: 1.5rem; font-weight: 600; margin-bottom: 0.5rem; }
    p { color: #94a3b8; font-size: 0.9rem; margin-bottom: 2rem; }
    .spinner {
      width: 40px; height: 40px; margin: 0 auto;
      border: 3px solid #334155;
      border-top-color: #3b82f6;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }
    @keyframes spin { to { transform: rotate(360deg); } }
    .badge {
      display: inline-block;
      margin-top: 2rem;
      padding: 0.25rem 0.75rem;
      background: #1e293b;
      border: 1px solid #334155;
      border-radius: 9999px;
      font-size: 0.75rem;
      color: #64748b;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="spinner"></div>
    <h1 style="margin-top: 1.5rem;">Waking up the container...</h1>
    <p>This page will refresh automatically in a few seconds.</p>
    <span class="badge">Rails 8 on Cloudflare Containers</span>
  </div>
</body>
</html>`;

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const container = getContainer(env.RAILS_APP);
    const maxRetries = 3;

    for (let attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        const response = await container.fetch(request);
        return response;
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        console.error(`Worker fetch attempt ${attempt}/${maxRetries}:`, message);

        if (attempt < maxRetries && (message.includes("not running") || message.includes("starting") || message.includes("port"))) {
          await new Promise(resolve => setTimeout(resolve, 3000));
          continue;
        }

        // On final attempt or non-retryable error, show loading page
        return new Response(LOADING_PAGE, {
          status: 503,
          headers: {
            "Content-Type": "text/html;charset=UTF-8",
            "Retry-After": "10",
          },
        });
      }
    }

    return new Response(LOADING_PAGE, {
      status: 503,
      headers: {
        "Content-Type": "text/html;charset=UTF-8",
        "Retry-After": "10",
      },
    });
  },
};
