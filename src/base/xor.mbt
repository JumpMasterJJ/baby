///|
/// This is a simple, elegant version of `xor`.
/// pub fn Joinable::xor[T, E : Compare](
///   scheme : Joinable[T, E],
///   t1 : T,
///   t2 : T
/// ) -> T {
///   let view = scheme.view
///   let join = scheme.join
///   match (view(t1), view(t2)) {
///     (Leaf, _) => t2
///     (_, Leaf) => t1
///     (Node(_), Node(l2, k2, r2)) => {
///       let (l1, b, r1) = split(scheme, k2, t1)
///       let l = xor(scheme, l1, l2)
///       let r = xor(scheme, r1, r2)
///       if b {
///         join2(scheme, l, r)
///       } else {
///         join(l, k2, r)
///       }
///     }
///   }
/// }

pub fn Joinable::xor[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> T {
  let view = scheme.view
  let join = scheme.join
  let leaf = scheme.leaf
  match (view(t1), view(t2)) {
    (Leaf, _) => t2
    (_, Leaf) => t1
    (Node(_), Node(l2, k2, r2)) =>
      if physical_equal(t1, t2) {
        // Fast path
        leaf()
      } else if scheme.is_empty(l2) && scheme.is_empty(r2) {
        // `t2` is `singleton k2`
        if mem(scheme, k2, t1) {
          remove(scheme, k2, t1)
        } else {
          add(scheme, k2, t1)
        }
      } else {
        let (l1, b, r1) = split(scheme, k2, t1)
        let l = xor(scheme, l1, l2)
        let r = xor(scheme, r1, r2)
        if b {
          join2(scheme, l, r)
        } else {
          join(l, k2, r)
        }
      }
  }
}
