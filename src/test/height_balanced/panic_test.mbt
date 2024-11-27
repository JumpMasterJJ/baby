test "panic remove_min on empty set" {
  let empty : @height.Set[Int] = @height.Set::empty()
  empty.remove_min_elt!() |> ignore
}

test "panic min on empty set" {
  let empty : @height.Set[Int] = @height.Set::empty()
  empty.min_elt!() |> ignore
}

test "panic max on empty set" {
  let empty : @height.Set[Int] = @height.Set::empty()
  empty.max_elt!() |> ignore
}