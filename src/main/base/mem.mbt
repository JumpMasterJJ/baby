pub fn Joinable::mem[T, E: Compare](scheme: Joinable[T, E], x: E, t: T) -> Bool {
  let view= scheme.view
  match view(t) {
    Leaf => false
    Node (l, v, r) => {
      let c= E::compare(x, v)
      c == 0 || mem(scheme, x, if c < 0 { l } else { r })
    }
  }
}