pub fn Joinable::split[T, E : Compare](
  scheme : Joinable[T, E],
  k : E,
  t : T
) -> (T, Bool, T) {
  let view = scheme.view
  let leaf = scheme.leaf
  let join = scheme.join
  match view(t) {
    Leaf => (leaf(), false, leaf())
    Node(l, m, r) => {
      let c = E::compare(k, m)
      if c == 0 {
        (l, true, r)
      } else if c < 0 {
        let (ll, b, lr) = split(scheme, k, l)
        (
          ll,
          b,
          if Joinable::compare(scheme, lr, l) == 0 {
            t
          } else {
            join(lr, m, r)
          },
        )
      } else {
        let (rl, b, rr) = split(scheme, k, r)
        (
          if Joinable::compare(scheme, rl, r) == 0 {
            t
          } else {
            join(l, m, rl)
          },
          b,
          rr,
        )
      }
    }
  }
}

pub fn Joinable::split13[T, E : Compare](
  scheme : Joinable[T, E],
  k : E,
  t : T
) -> (T, T) {
  let view = scheme.view
  let join = scheme.join
  let leaf = scheme.leaf
  match view(t) {
    Leaf => (leaf(), leaf())
    Node(l, m, r) => {
      let c = E::compare(k, m)
      if c == 0 {
        (l, r)
      } else if c < 0 {
        let (ll, lr) = split13(scheme, k, l)
        (
          ll,
          if Joinable::compare(scheme, lr, l) == 0 {
            t
          } else {
            join(lr, m, r)
          },
        )
      } else {
        let (rl, rr) = split13(scheme, k, r)
        (
          if Joinable::compare(scheme, rl, r) == 0 {
            t
          } else {
            join(l, m, rl)
          },
          rr,
        )
      }
    }
  }
}

// TODO: compare with OCaml
pub fn Joinable::split_last[T, E](
  scheme : Joinable[T, E],
  l : T,
  k : E,
  r : T
) -> (T, E) {
  let view = scheme.view
  let join = scheme.join
  match view(r) {
    Leaf => (l, k)
    Node(l_, k_, r_) => {
      let (r, m) = split_last(scheme, l_, k_, r_)
      (join(l, k, r), m)
    }
  }
}

// TODO: compare with OCaml
pub fn Joinable::join2[T, E](scheme : Joinable[T, E], l : T, r : T) -> T {
  let view = scheme.view
  let join = scheme.join
  match view(l) {
    Leaf => r
    Node(ll, m, lr) => {
      let (l_, k) = split_last(scheme, ll, m, lr)
      join(l_, k, r)
    }
  }
}
