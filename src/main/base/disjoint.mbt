// TODO: simple version
pub fn Joinable::disjoint[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> Bool {
  let view = scheme.view
  match (view(t1), view(t2)) {
    (Leaf, _) | (_, Leaf) => true
    (Node(_), Node(l2, k2, r2)) => {
      let (l1, b, r1) = split(scheme, k2, t1)
      not(b) &&
      Joinable::disjoint(scheme, l1, l2) &&
      Joinable::disjoint(scheme, r1, r2)
    }
  }
}
