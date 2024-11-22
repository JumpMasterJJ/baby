// TODO: Simple version, to be disabled
pub fn Joinable::subset[T, E: Compare](scheme: Joinable[T, E], t1: T, t2: T) -> Bool {
  let view = scheme.view
  match (view(t1), view(t2)) {
    (Leaf, _) => true
    (_, Leaf) => false
    (Node (_), Node (l2, k2, r2)) => {
      let (l1, r1) = split13(scheme, k2, t1)
      subset(scheme, l1, l2) && subset(scheme, r1, r2)
    }
  }
}