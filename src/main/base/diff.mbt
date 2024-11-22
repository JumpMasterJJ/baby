///|
/// This is a simple, elegant version of `diff`.
/// This version splits the tree `t1`.
/// 
/// pub fn Joinable::diff[T, E : Compare](
///   scheme : Joinable[T, E],
///   t1 : T,
///   t2 : T
/// ) -> T {
///   let view = scheme.view
///   let leaf = scheme.leaf
///   match (view(t1), view(t2)) {
///     (Leaf, _) => leaf()
///     (_, Leaf) => t1
///     (Node(_), Node(l2, k2, r2)) => {
///       let (l1, r1) = split13(scheme, k2, t1)
///       let l = diff(scheme, l1, l2)
///       let r = diff(scheme, r1, r2)
///       join2(scheme, l, r)
///     }
///   }
/// }

///|
/// This version of `diff` guarantees that if the result is
/// equal to `t1` then `t1` itself is returned.
pub fn Joinable::diff[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> T {
  let view = scheme.view
  let leaf = scheme.leaf
  let join = scheme.join
  match (view(t1), view(t2)) {
    (Leaf, _) => leaf()
    (_, Leaf) => t1
    (Node(l1, k1, r1), Node(l2, k2, r2)) =>
      if physical_equal(t1, t2) {
        // Fast path
        leaf()
      } else if scheme.is_empty(l1) && scheme.is_empty(r1) {
        // 't1' is `singleton k1`
        if mem(scheme, k1, t2) {
          leaf()
        } else {
          t1
        }
      } else if scheme.is_empty(l2) && scheme.is_empty(r2) {
        // `t2` is `singleton k2`
        remove(scheme, k2, t1)
      } else {
        let (l2, b, r2) = split(scheme, k1, t2)
        let l = diff(scheme, l1, l2)
        let r = diff(scheme, r1, r2)
        if b {
          join2(scheme, l, r)
        } else if scheme.compare(l, l1) == 0 && scheme.compare(r, r1) == 0 {
          t1
        } else {
          join(l, k1, r)
        }
      }
  }
}
