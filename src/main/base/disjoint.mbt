///|
/// This simple version of 'disjoint' has the same structure as 'inter'.
/// It can be improved by adding a fast path (based on physical equality),
/// by adding special cases for singletons, and by using a copy of `split`
/// that does not construct the subtrees `l` and `r` if the Boolean result
/// `b` is true
/// 
/// pub fn Joinable::disjoint[T, E : Compare](
///   scheme : Joinable[T, E],
///   t1 : T,
///   t2 : T
/// ) -> Bool {
///   let view = scheme.view
///   match (view(t1), view(t2)) {
///     (Leaf, _) | (_, Leaf) => true
///     (Node(_), Node(l2, k2, r2)) => {
///       let (l1, b, r1) = split(scheme, k2, t1)
///       not(b) &&
///       Joinable::disjoint(scheme, l1, l2) &&
///       Joinable::disjoint(scheme, r1, r2)
///     }
///   }
/// }
///

///|
pub fn Joinable::disjoint[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> Bool {
  let view = scheme.view
  match (view(t1), view(t2)) {
    (Leaf, _) | (_, Leaf) => true // fast path
    (_, _) =>
      not(physical_equal(t1, t2)) && // fast path
      Enum::disjoint(scheme, Enum::enum_(scheme, t1), Enum::enum_(scheme, t2))
  }
}
