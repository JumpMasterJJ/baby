pub fn Joinable::equal[T, E : Compare](
  scheme : Joinable[T, E],
  t1 : T,
  t2 : T
) -> Bool {
  let weight = scheme.weight
  physical_equal(t1, t2) ||
  (
    weight(t1) == weight(t2) &&
    Enum::equal(scheme, Enum::enum_(scheme, t1), Enum::enum_(scheme, t2))
  )
}
