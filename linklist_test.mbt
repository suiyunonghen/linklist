test "push pop" {
  let list : @linklist.LinkList[Int] = @linklist.LinkList::new()
    ..push(123)
    ..push(456)
    ..push(789)
  println(list)
  assert_eq!(list.pop(), Some(789))
  assert_eq!(list.pop(), Some(456))
  assert_eq!(list.pop(), Some(123))
  assert_eq!(list.pop(), None)
  assert_eq!(list.length, 0)
  println(list)
}

test "shift unshift" {
  let list : @linklist.LinkList[String] = @linklist.LinkList::new()
    ..unshift("test")
    ..unshift("dxsoft")
    ..unshift("data")
  for str in list {
    println(str)
  }
  let end = list.peek()
  println("尾巴数据:\{end} 准备从头取数据")
  assert_eq!(list.shift(), Some("data"))
  assert_eq!(list.shift(), Some("dxsoft"))
  for str in list {
    println(str)
  }
}

test "iter" {
  let list : @linklist.LinkList[String] = @linklist.LinkList::new()
    ..push("test")
    ..push("dxsoft")
    ..push("data")
  for str in list {
    println(str)
  }
  println("下面是反向迭代")
  let m = list.reverse_iter()
  for str in m {
    println(str)
  }
  let v = 32
  match v {
    1 | 3 => println("1,3")
    32 => println("Gasdf")
    _ => println("Gasdf")
  }
}

test "Zip" {
  let r = @linklist.zip(
    @linklist.LinkList::of([1, 2, 3, 4, 5]),
    @linklist.LinkList::of([6, 7, 8, 9, 10]),
  )
  println(r)
  let v = r.unwrap().unzip()
  println(v)
}

test "remove" {
  let list : @linklist.LinkList[String] = @linklist.LinkList::new()
    ..push("test")
    ..push("dxsoft")
    ..push("data")
  assert_eq!(list.remove("data"), true)
  assert_eq!(list.length, 2)
  for str in list {
    println(str)
  }
}

test "drop_while" {
  let list = @linklist.LinkList::of([1, 2, 3, 4, 5, 6, 7, 8, 9])
  let _ = list.drop_while(fn(value) -> Bool { value % 2 == 0 })
  println(list)
}

test "map" {
  let list : @linklist.LinkList[Int] = @linklist.LinkList::new()
    ..push(1)
    ..push(2)
    ..push(3)
    ..push(4)
  let lst = list.reverse_map(fn(v) -> Int { v * 2 })
  for ele in lst {
    println(ele)
  }
}

test "of" {
  let lst = @linklist.LinkList::from_array([1, 23, 45])
  for ele in lst {
    println(ele)
  }
}

test "[]" {
  let lst = @linklist.LinkList::of(
    [
      "春眠不觉晓", "处处闻啼鸟", "一生如牛不得闲", "得闲已与山共眠",
    ],
  )
  for i = 0; i < lst.length; i = i + 1 {
    println(lst[i])
  }
}

test "findNode" {
  let list = @linklist.LinkList::of([1, 2, 3, 4, 5, 6, 7, 8, 9])
  let node5 = list.findNode(fn(value : Int) -> Bool { value == 5 })
  match node5 {
    Some(v) => {
      // println("查到了内容\{v},下面准备从这里开始往后迭代")
      for value in v {
        println(value)
      }
      println("准备反向迭代")
      for value in v.reverse_iter() {
        println(value)
      }
    }
    None => println("悟了")
  }
}

test "sendToBack" {
  let list = @linklist.LinkList::of([1, 2, 3, 4, 5, 6, 7, 8, 9])
  println(list)
  list.sendtoback(8, findFromEnd=true)
  println(list)
}

test "bringtofront" {
  let list = @linklist.LinkList::of([1, 2, 3, 4, 5, 6, 7, 8, 9])
  list.bringtofront(4, findFromHead=false)
  println(list)
}
