test "panic remove_min on empty set" {
  let empty : @weight.Set[Int] = @weight.empty()
  empty.remove_min_elt!() |> ignore
}

test "panic min on empty set" {
  let empty : @weight.Set[Int] = @weight.empty()
  empty.min_elt!() |> ignore
}

test "panic max on empty set" {
  let empty : @weight.Set[Int] = @weight.empty()
  empty.max_elt!() |> ignore
}