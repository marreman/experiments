self.addEventListener("fetch", event => {
  if (!event.request.url.startsWith(self.location.origin)) return;

  self.caches.match(event.request).then(cachedResponse => {
    if (cachedResponse) {
      console.log(cachedResponse)
      return cachedResponse;
    } else {
      self.caches
        .open("map-test-cache")
        .then(cache => cache.add(event.request.url));

      return fetch(event.request);
    }
  });
});
