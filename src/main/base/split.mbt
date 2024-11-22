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

pub fn Joinable::join2[T, E](scheme : Joinable[T, E], l : T, r : T) -> T {
  let view = scheme.view
  let join = scheme.join
  match (view(l), view(r)) {
    (Leaf, _) => r
    (_, Leaf) => l
    (_, Node(rl, rv, rr)) =>
      join(l, min_elt_1(scheme, rv, rl), remove_min_elt_1(scheme, rl, rv, rr))
  }
}
