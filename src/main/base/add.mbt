pub fn Joinable::add[T, E : Compare](
  scheme : Joinable[T, E],
  x : E,
  t : T
) -> T {
  let view = scheme.view
  let singleton = scheme.singleton
  let join_neighbors = scheme.join_neighbors
  match view(t) {
    Leaf => singleton(x)
    Node(l, v, r) => {
      let c = E::compare(x, v)
      if c == 0 {
        t
      } else if c < 0 {
        let l_ = add(scheme, x, l)
        if physical_equal(l, l_) {
          t
        } else {
          join_neighbors(l_, v, r)
        }
      } else {
        let r_ = add(scheme, x, r)
        if physical_equal(r, r_) {
          t
        } else {
          join_neighbors(l, v, r_)
        }
      }
    }
  }
}
