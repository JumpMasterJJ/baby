// These testcases are based on MoonBit's @immut/sorted_set library.

test "new" {
  let empty : @weight.Set[Int] = @weight.empty()
  inspect!(empty, content="@weight.of_array([])")
}

test "disjoint" {
  inspect!(
    @weight.of_array([1]).disjoint(@weight.of_array([1, 2, 3])),
    content="false",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).disjoint(@weight.of_array([1, 2, 3])),
    content="false",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).disjoint(@weight.of_array([4, 5, 6])),
    content="true",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).subset(@weight.of_array([3, 4, 5])),
    content="false",
  )
}

test "subset" {
  inspect!(
    @weight.of_array([1, 2, 3]).subset(
      @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]),
    ),
    content="true",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).subset(@weight.of_array([10, 11, 12, 13, 14])),
    content="false",
  )
}

test "diff" {
  let empty = @weight.empty()
  inspect!(
    empty.diff(@weight.of_array([1, 2, 3])),
    content="@weight.of_array([])",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).diff(empty),
    content="@weight.of_array([1, 2, 3])",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).diff(@weight.of_array([4, 5, 1])),
    content="@weight.of_array([2, 3])",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).diff(@weight.of_array([1, 2, 3])),
    content="@weight.of_array([])",
  )
}

test "inter" {
  inspect!(
    @weight.of_array([3, 4, 5]).inter(@weight.of_array([4, 5, 6])),
    content="@weight.of_array([4, 5])",
  )
  inspect!(
    @weight.of_array([3, 4]).inter(@weight.of_array([5, 6])),
    content="@weight.of_array([])",
  )
}

test "union" {
  let empty = @weight.empty()
  inspect!(
    empty.union(@weight.of_array([4, 5, 6])),
    content="@weight.of_array([4, 5, 6])",
  )
  inspect!(
    @weight.of_array([4, 5, 6]).union(empty),
    content="@weight.of_array([4, 5, 6])",
  )
  inspect!(
    @weight.of_array([3]).union(@weight.of_array([4, 5, 6])),
    content="@weight.of_array([3, 4, 5, 6])",
  )
  inspect!(
    @weight.of_array([3, 4, 5]).union(@weight.of_array([6])),
    content="@weight.of_array([3, 4, 5, 6])",
  )
  inspect!(
    @weight.of_array([3, 4, 5]).union(@weight.of_array([4, 5, 6])),
    content="@weight.of_array([3, 4, 5, 6])",
  )
}

test "map" {
  inspect!(
    @weight.of_array([1, 2, 3, 4, 5]).map(fn(x) { x * 2 }),
    content="@weight.of_array([2, 4, 6, 8, 10])",
  )
}

test "all" {
  inspect!(
    @weight.of_array([2, 4, 6]).for_all(fn(v) { v % 2 == 0 }),
    content="true",
  )
  inspect!(
    @weight.of_array([1, 3, 5]).for_all(fn(v) { v % 2 == 0 }),
    content="false",
  )
}

test "any" {
  inspect!(
    @weight.of_array([1, 4, 3]).exists(fn(v) { v % 2 == 0 }),
    content="true",
  )
  inspect!(
    @weight.of_array([1, 5, 3]).exists(fn(v) { v % 2 == 0 }),
    content="false",
  )
}

test "fold" {
  inspect!(
    @weight.of_array([1, 2, 3, 4, 5]).fold(fn(acc, x) { acc + x }, 0),
    content="15",
  )
}

test "filter" {
  inspect!(
    @weight.of_array([1, 2, 3, 4, 5, 6]).filter(fn(v) { v % 2 == 0 }),
    content="@weight.of_array([2, 4, 6])",
  )
}

test "split" {
  let (left, present, right) = @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).split(
    5,
  )
  inspect!(present, content="true")
  inspect!(left, content="@weight.of_array([1, 2, 3, 4])")
  inspect!(right, content="@weight.of_array([6, 7, 8, 9])")
  let (left, present, right) = @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).split(
    0,
  )
  inspect!(present, content="false")
  inspect!(left, content="@weight.of_array([])")
  inspect!(right, content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 8, 9])")
}

test "contain" {
  inspect!(
    @weight.of_array([7, 2, 9, 4, 6, 3, 8, 1]).add(5).mem(5),
    content="true",
  )
  inspect!(@weight.of_array([7, 2, 9, 4, 6, 3, 8, 1]).mem(5), content="false")
}

test "to_array" {
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).to_array(),
    content="[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )
}

test "from_fixed_array" {
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]),
    content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 8, 9])",
  )
}

test "from_array" {
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]),
    content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 8, 9])",
  )
}

test "remove_min" {
  inspect!(
    @weight.of_array([3, 4, 5]).remove_min_elt!(),
    content="@weight.of_array([4, 5])",
  )
}

test "add" {
  inspect!(
    @weight.of_array([7, 2, 9, 4, 6, 3, 8, 1]).add(5),
    content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 8, 9])",
  )
  inspect!(@weight.of_array([2]).add(1), content="@weight.of_array([1, 2])")
  inspect!(@weight.of_array([2]).add(3), content="@weight.of_array([2, 3])")
  inspect!(
    @weight.of_array([2]).add(1).add(3),
    content="@weight.of_array([1, 2, 3])",
  )
  inspect!(@weight.of_array([1, 2]).add(1), content="@weight.of_array([1, 2])")
  inspect!(@weight.of_array([2, 3]).add(3), content="@weight.of_array([2, 3])")
  inspect!(
    @weight.of_array([1, 2, 3]).add(1),
    content="@weight.of_array([1, 2, 3])",
  )
  inspect!(
    @weight.of_array([1, 2, 3]).add(3),
    content="@weight.of_array([1, 2, 3])",
  )
  inspect!(
    @weight.of_array([1]).add(2).add(2),
    content="@weight.of_array([1, 2])",
  )
}

test "remove" {
  let empty = @weight.empty()
  inspect!(empty.remove(1), content="@weight.of_array([])")
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).remove(1),
    content="@weight.of_array([2, 3, 4, 5, 6, 7, 8, 9])",
  )
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).remove(9),
    content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 8])",
  )
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).remove(8),
    content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 9])",
  )
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).remove(0),
    content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 8, 9])",
  )
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).remove(10),
    content="@weight.of_array([1, 2, 3, 4, 5, 6, 7, 8, 9])",
  )
}

test "min" {
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).min_elt!(),
    content="1",
  )
}

test "min_option" {
  let empty : @weight.Set[Int] = @weight.empty()
  inspect!(empty.min_elt_opt(), content="None")
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).min_elt_opt(),
    content="Some(1)",
  )
}

test "max" {
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).max_elt!(),
    content="9",
  )
}

test "max_option" {
  let empty : @weight.Set[Int] = @weight.empty()
  inspect!(empty.max_elt_opt(), content="None")
  inspect!(
    @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).max_elt_opt(),
    content="Some(9)",
  )
}

test "is_empty" {
  inspect!((@weight.of_array([]) : @weight.Set[Int]).is_empty(), content="true")
  inspect!(@weight.of_array([1]).is_empty(), content="false")
}

test "to_string" {
  inspect!(
    @weight.of_array([1, 2, 3, 4, 5]),
    content="@weight.of_array([1, 2, 3, 4, 5])",
  )
  inspect!(
    (@weight.of_array([]) : @weight.Set[Int]),
    content="@weight.of_array([])",
  )
}

// TODO:
// test "op_equal" {
//   let xss : Array[@weight.Set[Int]] = @quickcheck.samples(5)
//   for xs in xss {
//     for ys in xss {
//       if xs.to_array() == ys.to_array() {
//         assert_eq!(xs, ys)
//       } else {
//         assert_not_eq!(xs, ys)
//       }
//     }
//   }
// }

// test "to_json" {
//   @json.inspect!(@weight.of_array([5, 2, 4, 3, 1]), content=[1, 2, 3, 4, 5])
//   @json.inspect!((@weight.of_array([]) : @weight.T[Int]), content=[])
// }

// test "from_json" {
//   for xs in (@quickcheck.samples(20) : Array[@weight.T[Int]]) {
//     assert_eq!(xs, @json.from_json!(xs.to_json()))
//   }
// }

test "iter" {
  let mut s = ""
  @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1]).iter_(
    fn(x) { s += x.to_string() },
  )
  inspect!(s, content="123456789")
  let empty : @weight.Set[Int] = @weight.of_array([])
  s = ""
  empty.iter_(fn(x) { s += x.to_string() })
  inspect!(s, content="")
}

// test "of_sorted_array" {
//   inspect(
//     of_sorted_array([1, 2, 3, 4, 5, 6, 7, 8, 9]),
//     content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8, 9]",
//   )?
// }
//
// // Convert a sorted array into a balanced binary search tree to facilitate subsequent search, insertion, and deletion operations.
// fn of_sorted_array[T : Compare](array : Array[T]) -> ImmutableSet[T] {
//   // Recursively process the input array and build a balanced binary search tree based on the length n of the array.
//   fn sub(n : Int, xs : ArrayView[T]) -> (ImmutableSet[T], ArrayView[T]) {
//     match (n, xs) {
//       (0, xs) => (Empty, xs)
//       (1, [ value, .. asremain ]) =>
//         (Node(left=Empty, ~value, right=Empty, height=1), remain)
//       (2, [ value, value1, .. asremain ]) =>
//         (
//           Node(
//             left=Node(left=Empty, ~value, right=Empty, height=1),
//             value=value1,
//             right=Empty,
//             height=2,
//           ),
//           remain,
//         )
//       (3, [ value, value1, value2, .. asremain ]) =>
//         (
//           Node(
//             left=Node(left=Empty, ~value, right=Empty, height=1),
//             value=value1,
//             right=Node(left=Empty, value=value2, right=Empty, height=1),
//             height=2,
//           ),
//           remain,
//         )

//       // For n > 3, the function first calculates the size of the left subtree,
//       // and then recursively constructs the left subtree.
//       _ => {
//         let left_length = n / 2
//         let (left, xs) = sub(left_length, xs)
//         match xs {
//           [  ] => abort("of_sorted_array: cannot constructs the left")
//           [ mid, .. asxs ] => {
//             let (right, xs) = sub(n - left_length - 1, xs)
//             (create(left, mid, right), xs)
//           }
//         }
//       }
//     }
//   }

//   sub(array.length(), array[:]).0
// }

test "split with value not in set" {
  let set = @weight.of_array([1, 2, 3, 4, 5])
  let (left, present, right) = set.split(6)
  inspect!(present, content="false")
  inspect!(left, content="@weight.of_array([1, 2, 3, 4, 5])")
  inspect!(right, content="@weight.of_array([])")
}

test "remove_min on non-empty set" {
  let set = @weight.of_array([3, 4, 5])
  let new_set = set.remove_min_elt!()
  inspect!(new_set, content="@weight.of_array([4, 5])")
}

test "min on non-empty set" {
  let set = @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1])
  let min_value = set.min_elt!()
  inspect!(min_value, content="1")
}

test "max on non-empty set" {
  let set = @weight.of_array([7, 2, 9, 4, 5, 6, 3, 8, 1])
  let max_value = set.max_elt!()
  inspect!(max_value, content="9")
}

test "union with different heights" {
  let set1 = @weight.of_array([3, 4, 5])
  let set2 = @weight.of_array([4, 5, 6])
  let union_set = set1.union(set2)
  inspect!(union_set, content="@weight.of_array([3, 4, 5, 6])")
}

test "disjoint with different sets" {
  let set1 = @weight.of_array([1, 2, 3])
  let set2 = @weight.of_array([4, 5, 6])
  let disjoint = set1.disjoint(set2)
  inspect!(disjoint, content="true")
}

test "union with different heights" {
  let set1 = @weight.of_array([3, 4, 5])
  let set2 = @weight.of_array([4, 5, 6])
  let union_set = set1.union(set2)
  inspect!(union_set, content="@weight.of_array([3, 4, 5, 6])")
}

test "disjoint with different sets" {
  let set1 = @weight.of_array([1, 2, 3])
  let set2 = @weight.of_array([4, 5, 6])
  let disjoint = set1.disjoint(set2)
  inspect!(disjoint, content="true")
}

test "union with different heights" {
  let set1 = @weight.of_array([3, 4, 5])
  let set2 = @weight.of_array([4, 5, 6])
  let union_set = set1.union(set2)
  inspect!(union_set, content="@weight.of_array([3, 4, 5, 6])")
}

test "disjoint with different sets" {
  let set1 = @weight.of_array([1, 2, 3])
  let set2 = @weight.of_array([4, 5, 6])
  let disjoint = set1.disjoint(set2)
  inspect!(disjoint, content="true")
}

// TODO:
// test "from_iter multiple elements iter" {
//   inspect!(
//     @weight.Set::from_iter([1, 2, 3].iter()),
//     content="@weight.of_array([1, 2, 3])",
//   )
// }

// test "from_iter single element iter" {
//   inspect!(
//     @weight.Set::from_iter([1].iter()),
//     content="@weight.of_array([1])",
//   )
// }

// test "from_iter empty iter" {
//   let pq : @weight.Set[Int] = @weight.Set::from_iter(Iter::empty())
//   inspect!(pq, content="@weight.of_array([])")
// }

// test "iter" {
//   let buf = StringBuilder::new(size_hint=20)
//   let set = [2, 7, 1, 2, 3, 4, 5] |> @weight.of_array
//   for x in set {
//     buf.write_object(x)
//   }
//   inspect!(buf, content="123457")
// }
