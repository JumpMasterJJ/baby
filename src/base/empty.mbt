pub fn Joinable::empty[T, E](scheme : Joinable[T, E]) -> T {
  let leaf = scheme.leaf
  leaf()
}

pub fn Joinable::is_empty[T, E](scheme : Joinable[T, E], t : T) -> Bool {
  let view = scheme.view
  match view(t) {
    Leaf => true
    Node(_) => false
  }
}
