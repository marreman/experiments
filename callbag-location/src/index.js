import { merge, fromEvent, pipe, forEach, map, filter } from "callbag-basics";

const popState$ = (start, sink) => {
  if (start !== 0) return;

  sink(0, t => {
    if (t === 2) {
      window.onpopstate = null;
    }
  });

  window.onpopstate = event => {
    sink(1, event);
  };
};

const pushState$ = pipe(
  fromEvent(document.body, "click"),
  filter(event => event.target.tagName === "A"),
  map(event => {
    event.preventDefault();
    history.pushState(null, null, event.target.href)

    return event
  })
);

const location$ = pipe(
  merge(popState$, pushState$),
  map(() => window.location),
  forEach(a => console.log(a))
)
