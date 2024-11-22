pub fn Joinable::min_elt_1[T, E](scheme: Joinable[T, E], default: E, t: T) -> E {
  let view=  scheme.view
  match view(t) {
    Leaf => default
    Node (l, v, _) => min_elt_1(scheme, v, l)
  }
}

pub fn Joinable::min_elt[T, E](scheme: Joinable[T, E], t: T) -> E!Not_found {
  let view = scheme.view
  match view(t) {
    Leaf => raise Not_found
    Node (l, v, _) => min_elt_1(scheme, v, l)
  }
}

pub fn Joinable::min_elt_opt_1[T, E](scheme: Joinable[T, E], default: E, t: T) -> Option[E] {
  let view = scheme.view
  match view(t) {
    Leaf => Some(default)
    Node (l, v, _) => min_elt_opt_1(scheme, v, l)
  }
}

pub fn Joinable::min_elt_opt[T, E](scheme: Joinable[T, E], t: T) -> Option[E] {
  let view = scheme.view
  match view(t) {
    Leaf => None
    Node (l, v, _) => min_elt_opt_1(scheme, v, l)
  }
}

pub fn Joinable::max_elt_1[T, E](scheme: Joinable[T, E], default: E, t: T) -> E {
  let view=  scheme.view
  match view(t) {
    Leaf => default
    Node (_, v, r) => max_elt_1(scheme, v, r)
  }
}

pub fn Joinable::max_elt[T, E](scheme: Joinable[T, E], t: T) -> E!Not_found {
  let view = scheme.view
  match view(t) {
    Leaf => raise Not_found
    Node (_, v, r) => max_elt_1(scheme, v, r)
  }
}

pub fn Joinable::max_elt_opt_1[T, E](scheme: Joinable[T, E], default: E, t: T) -> Option[E] {
  let view = scheme.view
  match view(t) {
    Leaf => Some(default)
    Node (_, v, r) => max_elt_opt_1(scheme, v, r)
  }
}

pub fn Joinable::max_elt_opt[T, E](scheme: Joinable[T, E], t: T) -> Option[E] {
  let view = scheme.view
  match view(t) {
    Leaf => None
    Node (_, v, r) => max_elt_opt_1(scheme, v, r)
  }
}

pub fn Joinable::choose[T, E](scheme: Joinable[T, E], t: T) -> E!Not_found {
  min_elt!(scheme, t)
}

pub fn Joinable::choose_opt[T, E](scheme: Joinable[T, E], t: T) -> Option[E] {
  min_elt_opt(scheme, t)
}