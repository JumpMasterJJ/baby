// TODO: simple version
pub fn Joinable::compare[T, E: Compare](scheme: Joinable[T, E], t1: T, t2: T) -> Int {
  if physical_equal(t1, t2) { 0 } else {
    Enum::compare(scheme, enum_(scheme, t1), enum_(scheme, t2))
  }
}