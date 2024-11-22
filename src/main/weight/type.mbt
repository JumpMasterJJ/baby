enum Tree[E] {
  TLeaf
  TNode (~l: Tree[E], ~v: E, ~r: Tree[E], ~w: Int)
}