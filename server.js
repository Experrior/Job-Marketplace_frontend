// server.js
import { Server } from './.svelte-kit/output/server/index.js';
import { createServer } from 'http';

const server = new Server({
  env: process.env,
});

const httpServer = createServer((req, res) => {
  server.respond(req, { platform: {} }).then((response) => {
    res.writeHead(response.status, Object.fromEntries(response.headers));
    response.body?.pipe(res);
  });
});

const port = process.env.PORT || 3000;
httpServer.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
