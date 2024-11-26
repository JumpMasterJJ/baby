///|
/// This is the simple, elegant version of 'inter' given by BFS.
/// It can be improved by :
///   + fast path for the case where 'physical_equal(t1, t2)'
///   + specialized code for the case where 't2' is a singleton;
///     in that case there is no need to use 'split'
///   + the code guarantees that if the result is equal to 't2'
///     then 't2' itself is returned.
/// 
/// pub fn Joinable::inter[T, E : Compare](
///   scheme : Joinable[T, E],
///   t1 : T,
///   t2 : T
/// ) -> T {
///   let view = scheme.view
///   let join = scheme.join
///   let leaf = scheme.leaf
///   match (view(t1), view(t2)) {
///     (Leaf, _) | (_, Leaf) => leaf()
///     (Node(_), Node(l2, k2, r2)) => {
///       let (l1, b, r1) = split(scheme, k2, t1)
///       let l = inter(scheme, l1, l2)
///       let r = inter(scheme, r1, r2)
///       if b {
///         join(l, k2, r)
///       } else {
///         join2(scheme, l, r)
///       }
///     }
///   }
/// }

///|
/// 
fn Joinable::inter_aux[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> T {
  let view = scheme.view
  let join = scheme.join
  let leaf = scheme.leaf
  match (view(t1), view(t2)) {
    (Leaf, _) | (_, Leaf) => leaf()
    (Node(_), Node(l2, k2, r2)) =>
      if physical_equal(t1, t2) {
        // Fast path
        t2
      } else if scheme.is_empty(l2) && scheme.is_empty(r2) {
        // The tree `t2` is 'singleton k2'
        if mem(scheme, k2, t1) {
          t2
        } else {
          leaf()
        }
      } else {
        let (l1, b, r1) = split(scheme, k2, t1)
        let l = inter_aux(scheme, l1, l2)
        let r = inter_aux(scheme, r1, r2)
        if b {
          if physical_equal(l, l2) && physical_equal(r, r2) {
            t2
          } else {
            join(l, k2, r)
          }
        } else {
          join2(scheme, l, r)
        }
      }
  }
}

pub fn Joinable::inter[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> T {
  let seems_smaller = scheme.seems_smaller
  if physical_equal(t1, t2) {
    // Fast path
    t1
  } else if seems_smaller(t1, t2) {
    inter_aux(scheme, t2, t1)
  } else {
    inter_aux(scheme, t1, t2)
  }
}
