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

async function appShellResponse() {
  const cache = await caches.open(CACHE_NAME);
  const appShellUrl = new URL('index.html', self.registration.scope).href;
  const cachedResponse =
    (await cache.match(appShellUrl)) ||
    (await cache.match('index.html')) ||
    (await cache.match('./index.html'));

  // respondWith() must always resolve to a Response. This fallback is used
  // only before the application shell has finished being cached.
  return cachedResponse ||
    new Response('Application shell is not available yet.', {
      status: 503,
      headers: { 'Content-Type': 'text/plain; charset=utf-8' },
    });
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

  // Never return undefined: Chrome rejects it as an invalid fetch response.
  return (await caches.match(event.request)) ||
    new Response('', { status: 504, statusText: 'Network request failed' });
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
    // Flutter routes such as /login do not exist as physical GitHub Pages
    // files. Serve the cached SPA shell instead of fetching those URLs.
    event.respondWith(appShellResponse());
    return;
  }

  const normalizedPath = normalizePathname(requestUrl.pathname);
  if (NETWORK_FIRST_ASSETS.has(normalizedPath)) {
    event.respondWith(networkFirst(event.request));
    return;
  }

  event.respondWith(staleWhileRevalidate(event));
});

self.addEventListener('push', (event) => {
  event.waitUntil((async () => {
    let payload = {};
    try {
      payload = event.data?.json() || {};
    } catch (_) {
      payload = {
        title: '飼料桶監控通知',
        body: event.data?.text?.() || '',
      };
    }

    const baseUrl = new URL('./', self.registration.scope);
    await self.registration.showNotification(
      payload.title || '飼料桶監控通知',
      {
        body: payload.body || '',
        tag: payload.tag || 'hub8735-notification',
        icon: new URL('icons/hao-icon-192.png', baseUrl).toString(),
        badge: new URL('icons/hao-icon-192.png', baseUrl).toString(),
        data: {
          url: payload.url || baseUrl.toString(),
          eventId: payload.eventId || null,
          alertType: payload.alertType || 'general',
          monitorId: payload.monitorId || null,
        },
      },
    );
  })());
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil((async () => {
    const targetUrl = event.notification.data?.url ||
      new URL('./', self.registration.scope).toString();
    const windows = await self.clients.matchAll({
      type: 'window',
      includeUncontrolled: true,
    });
    for (const client of windows) {
      if ('focus' in client) {
        await client.focus();
        if ('navigate' in client) await client.navigate(targetUrl);
        return;
      }
    }
    await self.clients.openWindow(targetUrl);
  })());
});
