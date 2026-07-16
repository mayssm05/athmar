// Strip Flutter's service worker (it wedges updates behind stale caches in the proxied preview).
import { readFileSync, writeFileSync } from 'node:fs';
const p = 'app/build/web/flutter_bootstrap.js';
let s = readFileSync(p, 'utf8');
s = s.replace(/serviceWorkerSettings:\s*\{[^}]*\},?/s, '');
writeFileSync(p, s);
// Kill-switch worker: unregisters itself and clears caches for clients that already installed one.
writeFileSync('app/build/web/flutter_service_worker.js', `
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (e) => {
  e.waitUntil((async () => {
    for (const k of await caches.keys()) await caches.delete(k);
    await self.registration.unregister();
    for (const c of await self.clients.matchAll()) c.navigate(c.url);
  })());
});
`);
console.log('patched flutter_bootstrap.js + kill-switch service worker');
