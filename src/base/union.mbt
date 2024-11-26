///|
/// This is the simple, elegant version of `union` given by BFS.
/// pub fn Joinable::union[T, E : Compare](
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
///       let (l1, r1) = split13(scheme, k2, t1)
///       let l = union(scheme, l1, l2)
///       let r = union(scheme, r1, r2)
///       join(l, k2, r)
///     }
///   }
/// }

// let rec union (t1 : tree) (t2 : tree) : tree =
//   match VIEW(t1), VIEW(t2) with
//   | LEAF, _ ->
//       t2
//   | _, LEAF ->
//       t1
//   | NODE(l1, k1, r1), NODE(l2, k2, r2) ->
//       if BOTH_EMPTY(l1, r1) then add k1 t2 else
//       if BOTH_EMPTY(l2, r2) then add k2 t1 else
//       let l1, r1 = split13 k2 t1 in
//       let l = union l1 l2
//       and r = union r1 r2 in
//       if l == l2 && r == r2 then t2 else (* preserve sharing *)
//       join l k2 r
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
    (Node(l1, k1, r1), Node(l2, k2, r2)) =>
      if scheme.is_empty(l1) && scheme.is_empty(r1) {
        add(scheme, k1, t2)
      } else if scheme.is_empty(l2) && scheme.is_empty(r2) {
        add(scheme, k2, t1)
      } else {
        let (l1, r1) = split13(scheme, k2, t1)
        let l = union(scheme, l1, l2)
        let r = union(scheme, r1, r2)
        if physical_equal(l, l2) && physical_equal(r, r2) {
          t2
        } else {
          join(l, k2, r)
        }
      }
  }
}
