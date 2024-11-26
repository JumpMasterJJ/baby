pub enum View[T, E] {
  Leaf
  Node(T, E, T)
}

pub enum Enum[T, E] {
  End
  More(E, T, Enum[T, E])
}

pub struct Joinable[T, E] {
  // Basic implementation
  view : (T) -> View[T, E]
  join : (T, E, T) -> T
  leaf : () -> T

  // More efficient implementation
  join_neighbors : (T, E, T) -> T
  join_weight_balanced : (T, E, T) -> T
  weight : (T) -> Int
  cardinal : (T) -> Int
  constant_time_cardinal : Bool
  singleton : (E) -> T
  doubleton : (E, E) -> T
  tripleton : (E, E, E) -> T
  seems_smaller : (T, T) -> Bool
  check : (T) -> Unit
}
