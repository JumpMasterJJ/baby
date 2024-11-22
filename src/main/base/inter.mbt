// TODO: simple version
pub fn Joinable::inter[T, E: Compare](scheme: Joinable[T, E], t1: T, t2: T) -> T {
  let view = scheme.view
  let join = scheme.join
  let leaf = scheme.leaf
  match (view(t1), view(t2)) {
    (Leaf, _) | (_, Leaf) => leaf()
    (Node (_), Node (l2, k2, r2)) => {
      let (l1, b, r1) = split(scheme, k2, t1)
      let l = inter(scheme, l1, l2)
      let r = inter(scheme, r1, r2)
      if b { join(l, k2, r) } else { join2(scheme, l, r) }
    }
  }
}