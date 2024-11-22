pub fn Joinable::find[T, E : Compare](scheme: Joinable[T, E], x: E, t: T) -> E!Not_found {
  let view = scheme.view
  match view(t) {
    Leaf => raise Not_found
    Node (l, v, r) => {
      let c = E::compare(x, v)
      if c == 0 {
        v
      } else if c < 0 {
        find!(scheme, x, l)
      } else {
        find!(scheme, x, r)
      }
    }
  }
}


pub fn Joinable::find_opt[T, E: Compare](scheme: Joinable[T, E], x: E, t: T) -> Option[E] {
  let view =  scheme.view
  match view(t) {
    Leaf => None
    Node (l, v, r) => {
      let c = E::compare(x, v)
      if c == 0 {
        Some(v)
      } else if c < 0 {
        find_opt(scheme, x, l)
      } else {
        find_opt(scheme, x, r)
      }
    }
  }
}

pub fn Joinable::find_first[T, E](scheme: Joinable[T, E], f: (E) -> Bool, t: T) -> E!Not_found {
  let view = scheme.view
  fn aux(v0, f, t) {
    match view(t) {
      Leaf => v0
      Node (l, v, r) => {
        if f(v) { aux(v, f, l) } else { aux(v0, f, r) }
      }
    }
  }
  match view(t) {
    Leaf => raise Not_found
    Node (l, v, r) => if f(v) { aux(v, f, l) } else { find_first!(scheme, f, r) }
  }
}

pub fn Joinable::find_first_opt[T, E](scheme: Joinable[T, E], f: (E) -> Bool, t: T) -> Option[E] {
  let view = scheme.view
  fn aux(v0, f, t) {
    match view(t) {
      Leaf => Some(v0)
      Node (l, v, r) => if f(v) { aux(v, f, l) } else { aux(v0, f, r) }
    }
  }
  match view(t) {
    Leaf => None
    Node (l, v, r) => if f(v) { aux(v, f, l) } else { find_first_opt(scheme, f, r) }
  }
}

pub fn Joinable::find_last[T, E](scheme: Joinable[T, E], f: (E) -> Bool, t: T) -> E!Not_found {
  let view= scheme.view
  fn aux(v0, f, t) {
    match view(t) {
      Leaf => v0
      Node (l, v, r) => if f(v) { aux(v, f, r) } else { aux(v0, f, l) }
    }
  }
  match view(t) {
    Leaf => raise Not_found
    Node (l, v, r) => if f(v) { aux(v, f, r) } else { find_last!(scheme, f, l) }
  }
}

pub fn Joinable::find_last_opt[T, E](scheme: Joinable[T, E], f: (E) -> Bool, t: T) -> Option[E] {
  let view= scheme.view
  fn aux(v0, f, t) {
    match view(t) {
      Leaf => Some(v0)
      Node (l, v, r) => if f(v) { aux(v, f, r) } else { aux(v0, f, l) }
    }
  }
  match view(t) {
    Leaf => None
    Node (l, v, r) => if f(v) { aux(v, f, r) } else { find_last_opt(scheme, f, l) }
  }
}