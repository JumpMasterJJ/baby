///|
/// This simple version of `subset` has canonical structure.
/// pub fn Joinable::subset[T, E : Compare](
///   scheme : Joinable[T, E],
///   t1 : T,
///   t2 : T
/// ) -> Bool {
///   let view = scheme.view
///   match (view(t1), view(t2)) {
///     (Leaf, _) => true
///     (_, Leaf) => false
///     (Node(_), Node(l2, k2, r2)) => {
///       let (l1, r1) = split13(scheme, k2, t1)
///       subset(scheme, l1, l2) && subset(scheme, r1, r2)
///     }
///   }
/// }

pub fn Joinable::subset[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> Bool {
  let view = scheme.view
  let weight = scheme.weight
  match (view(t1), view(t2)) {
    (Leaf, _) => true
    (_, Leaf) => false
    (Node(l1, k1, r1), Node(l2, k2, r2)) =>
      if physical_equal(t1, t2) {
        true
      } else if scheme.is_empty(l1) && scheme.is_empty(r1) {
        mem(scheme, k1, t2)
      } else if not(weight(t1) <= weight(t2)) {
        false
      } else {
        let (l1, r1) = split13(scheme, k2, t1)
        subset(scheme, l1, l2) && subset(scheme, r1, r2)
      }
  }
}
