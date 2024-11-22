// TODO: Simple version, to be disabled
pub fn Joinable::xor[T, E: Compare](scheme: Joinable[T, E], t1: T, t2: T) -> T {
  let view = scheme.view
  let join = scheme.join
  match (view(t1), view(t2)) {
    (Leaf, _) => t2
    (_, Leaf) => t1
    (Node (_), Node (l2, k2, r2)) => {
      let (l1, b, r1) = split(scheme, k2, t1)
      let l = xor(scheme, l1, l2)
      let r=  xor(scheme, r1, r2)
      if b { join2(scheme, l, r) } else { join(l, k2, r) }
    }
  }
}