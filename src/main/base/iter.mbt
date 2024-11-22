pub fn Joinable::iter[T, E](scheme: Joinable[T, E], f: (E) -> Unit, t: T) -> Unit {
  let view = scheme.view
  match view(t) {
    Leaf => ()
    Node (l, v, r) => {
      iter(scheme, f, l)
      f(v)
      iter(scheme, f, r)
    }
  }
}

pub fn Joinable::fold[T, E, A](scheme: Joinable[T, E], f: (E, A) -> A, t: T, accu: A) -> A {
  let view = scheme.view
  match view(t) {
    Leaf => accu
    Node (l, v, r) => fold(scheme, f, r, f(v, fold(scheme, f, l, accu)))
  }
}

pub fn Joinable::for_all[T, E](scheme: Joinable[T, E], p: (E) -> Bool, t: T) -> Bool {
  let view = scheme.view
  match view(t) {
    Leaf => true
    Node (l, v, r) => p(v) && for_all(scheme, p, l) && for_all(scheme, p, r)
  }
}

pub fn Joinable::exists[T, E](scheme: Joinable[T, E], p: (E) -> Bool, t: T) -> Bool {
  let view = scheme.view
  match view(t) {
    Leaf => false
    Node (l, v, r) => p(v) || exists(scheme, p, l) || exists(scheme, p, r)
  }
}