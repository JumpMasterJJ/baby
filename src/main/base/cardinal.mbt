// TODO: remove
let constant_time_cardinal = false

pub fn Joinable::cardinal[T, E](scheme : Joinable[T, E], t : T) -> Int {
  // TODO: compare with impl of OCaml
  // 1. no view ?
  // 2. no scheme.cardinal ?
  let view = scheme.view
  fn aux(accu, t) {
    match view(t) {
      Leaf => accu
      Node(l, _, r) => {
        let accu = accu + 1
        let accu = aux(accu, l)
        aux(accu, r)
      }
    }
  }

  aux(0, t)
}
