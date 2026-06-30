'use strict';

const APP_VERSION = '__APP_VERSION__';
const CACHE_NAME = `feed-bucket-pwa-${APP_VERSION}`;
const APP_SHELL = [
  './',
  'index.html',
  'manifest.json',
  'favicon-hao.png',
  'icons/apple-touch-icon-hao.png',
  'icons/hao-icon-192.png',
  'icons/hao-icon-512.png',
  'icons/hao-icon-maskable-192.png',
  'icons/hao-icon-maskable-512.png',
];
const NETWORK_FIRST_ASSETS = new Set([
  '',
  './',
  'index.html',
  'manifest.json',
  'flutter_bootstrap.js',
  'main.dart.js',
  'version.json',
  'assets/AssetManifest.json',
  'assets/FontManifest.json',
  'assets/NOTICES',
]);

function normalizePathname(pathname) {
  const scopePath = new URL(self.registration.scope).pathname;
  const normalizedScope = scopePath.endsWith('/') ? scopePath : `${scopePath}/`;

  if (pathname.startsWith(normalizedScope)) {
    return pathname.substring(normalizedScope.length);
  }

  return pathname.replace(/^\//, '');
}

async function storeResponse(request, response) {
  if (!response || response.status !== 200 || response.type === 'opaque') {
    return response;
  }

  const cache = await caches.open(CACHE_NAME);
  await cache.put(request, response.clone());
  return response;
}

async function networkFirst(request, fallbackKey) {
  try {
    const networkResponse = await fetch(request);
    return await storeResponse(request, networkResponse);
  } catch (error) {
    const cachedResponse =
      (await caches.match(request)) ||
      (fallbackKey ? await caches.match(fallbackKey) : null);

    if (cachedResponse) {
      return cachedResponse;
    }

    throw error;
  }
}

async function staleWhileRevalidate(event) {
  const cache = await caches.open(CACHE_NAME);
  const cachedResponse = await cache.match(event.request);
  const networkFetch = fetch(event.request)
    .then((response) => storeResponse(event.request, response))
    .catch(() => null);

  if (cachedResponse) {
    event.waitUntil(networkFetch);
    return cachedResponse;
  }

  const networkResponse = await networkFetch;
  if (networkResponse) {
    return networkResponse;
  }

  return caches.match(event.request);
}

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL)),
  );
});

self.addEventListener('message', (event) => {
  if (event.data?.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const cacheNames = await caches.keys();
      await Promise.all(
        cacheNames
            .filter((cacheName) => cacheName !== CACHE_NAME)
            .map((cacheName) => caches.delete(cacheName)),
      );
      await self.clients.claim();
    })(),
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') {
    return;
  }

  const requestUrl = new URL(event.request.url);
  if (requestUrl.origin !== self.location.origin) {
    return;
  }

  if (event.request.mode === 'navigate') {
    event.respondWith(networkFirst(event.request, 'index.html'));
    return;
  }

  const normalizedPath = normalizePathname(requestUrl.pathname);
  if (NETWORK_FIRST_ASSETS.has(normalizedPath)) {
    event.respondWith(networkFirst(event.request));
    return;
  }

  event.respondWith(staleWhileRevalidate(event));
});
