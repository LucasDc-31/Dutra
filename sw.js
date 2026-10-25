// ============================================================
// sw.js — service worker mínimo
// ------------------------------------------------------------
// O app depende do Supabase e não funciona offline, então este
// service worker NÃO guarda nada em cache: toda requisição vai
// direto para a rede. Ele existe para o navegador reconhecer o
// site como app instalável (PWA) e para apagar caches de
// versões antigas.
// ============================================================
self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    const nomes = await caches.keys();
    await Promise.all(nomes.map(n => caches.delete(n)));
    await self.clients.claim();
  })());
});

// Handler de fetch exigido para a instalação como app: repassa tudo para a rede.
self.addEventListener('fetch', event => {
  event.respondWith(fetch(event.request));
});
