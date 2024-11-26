pub fn Joinable::filter[T, E : Compare](
  scheme : Joinable[T, E],
  p : (E) -> Bool,
  t : T
) -> T {
  let view = scheme.view
  let leaf = scheme.leaf
  let join = scheme.join
  match view(t) {
    Leaf => leaf()
    Node(l, v, r) => {
      let l_ = filter(scheme, p, l)
      let pv = p(v)
      let r_ = filter(scheme, p, r)
      if pv {
        if Joinable::compare(scheme, l, l_) == 0 {
          t
        } else {
          join(l_, v, r_)
        }
      } else {
        join2(scheme, l_, r_)
      }
    }
  }
}

pub fn Joinable::partition[T, E : Compare](
  scheme : Joinable[T, E],
  p : (E) -> Bool,
  t : T
) -> (T, T) {
  let view = scheme.view
  let join = scheme.join
  let leaf = scheme.leaf
  match view(t) {
    Leaf => (leaf(), leaf())
    Node(l, v, r) => {
      let (lt, lf) = partition(scheme, p, l)
      let pv = p(v)
      let (rt, rf) = partition(scheme, p, r)
      if pv {
        (
          if Joinable::compare(scheme, lt, l) == 0 &&
            Joinable::compare(scheme, rt, r) == 0 {
            t
          } else {
            join(lt, v, rt)
          },
          join2(scheme, lf, rf),
        )
      } else {
        (
          join2(scheme, lt, rt),
          if Joinable::compare(scheme, lf, l) == 0 &&
            Joinable::compare(scheme, rf, r) == 0 {
            t
          } else {
            join(lf, v, rf)
          },
        )
      }
    }
  }
}
