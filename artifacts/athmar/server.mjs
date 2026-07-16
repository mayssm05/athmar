import http from 'node:http';
import { createReadStream, existsSync, statSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, 'app', 'build', 'web');

const port = Number(process.env.PORT);
if (!port) throw new Error('PORT environment variable is required');
let base = process.env.BASE_PATH || '/';
if (!base.endsWith('/')) base += '/';

const types = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript',
  '.mjs': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.wasm': 'application/wasm',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.otf': 'font/otf',
  '.ttf': 'font/ttf',
  '.woff2': 'font/woff2',
  '.frag': 'text/plain',
};

http
  .createServer((req, res) => {
    let urlPath = decodeURIComponent(new URL(req.url, 'http://x').pathname);
    if (urlPath.startsWith(base)) urlPath = urlPath.slice(base.length);
    else if (urlPath === base.slice(0, -1)) urlPath = '';
    urlPath = urlPath.replace(/^\/+/, '');
    let filePath = path.normalize(path.join(root, urlPath));
    if (!filePath.startsWith(root)) {
      res.writeHead(403).end();
      return;
    }
    if (!urlPath || !existsSync(filePath) || statSync(filePath).isDirectory()) {
      filePath = path.join(root, 'index.html');
    }
    res.writeHead(200, {
      'content-type': types[path.extname(filePath)] || 'application/octet-stream',
      'cache-control': 'no-store',
    });
    createReadStream(filePath).pipe(res);
  })
  .listen(port, '0.0.0.0', () => {
    console.log(`Athmar Flutter web serving ${root} at ${base} on port ${port}`);
  });
