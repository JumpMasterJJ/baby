// TODO: compare with OCaml
pub fn Joinable::diff[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> T {
  let view = scheme.view
  let leaf = scheme.leaf
  match (view(t1), view(t2)) {
    (Leaf, _) => leaf()
    (_, Leaf) => t1
    (Node(_), Node(l2, k2, r2)) => {
      let (l1, r1) = split13(scheme, k2, t1)
      let l = diff(scheme, l1, l2)
      let r = diff(scheme, r1, r2)
      join2(scheme, l, r)
    }
  }
}
