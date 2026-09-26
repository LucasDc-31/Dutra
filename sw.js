// ============================================================
// sw.js — Dutra Odonto (PWA)
// ============================================================
// Depois de aberto uma vez, o app continua funcionando mesmo sem
// internet ou com o servidor fora do ar: a interface fica salva no
// próprio celular. Como os dados ficam em localStorage, o app é
// totalmente utilizável offline.
//
// Estratégia:
//   - HTML: "network-first" — com internet busca a versão mais nova
//     (atualizações chegam sozinhas); sem internet usa o cache.
//   - Demais arquivos (manifest, ícones): "cache-first".
// ============================================================

const CACHE_NAME = 'dutra-odonto-v3';

const APP_SHELL = [
  './',
  './index.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(APP_SHELL))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(nomes =>
      Promise.all(nomes.filter(n => n !== CACHE_NAME).map(n => caches.delete(n)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const req = event.request;
  const url = new URL(req.url);

  if (url.origin !== self.location.origin) return;
  if (req.method !== 'GET') return;

  const ehHTML = req.mode === 'navigate' || req.destination === 'document';

  if (ehHTML) {
    event.respondWith(
      fetch(req)
        .then(resp => {
          const clone = resp.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(req, clone));
          return resp;
        })
        .catch(() => caches.match(req).then(r => r || caches.match('./index.html')))
    );
    return;
  }

  event.respondWith(
    caches.match(req).then(cached => {
      if (cached) return cached;
      return fetch(req).then(resp => {
        const clone = resp.clone();
        caches.open(CACHE_NAME).then(cache => cache.put(req, clone));
        return resp;
      }).catch(() => cached);
    })
  );
});
