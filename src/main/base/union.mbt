// TODO: Simple version, to be disabled
pub fn Joinable::union[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> T {
  let view = scheme.view
  let join = scheme.join
  match (view(t1), view(t2)) {
    (Leaf, _) => t2
    (_, Leaf) => t1
    (Node(_), Node(l2, k2, r2)) => {
      let (l1, r1) = split13(scheme, k2, t1)
      let l = union(scheme, l1, l2)
      let r = union(scheme, r1, r2)
      join(l, k2, r)
    }
  }
}
