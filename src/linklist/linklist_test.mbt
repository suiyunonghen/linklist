test "push pop" {  
  let list: @linklist.LinkList[Int] = @linklist.LinkList::new().push(123).push(456).push(789)  
  assert_eq!(list.pop(),Some(789))
  assert_eq!(list.pop(),Some(456))
  assert_eq!(list.pop(),Some(123))
  assert_eq!(list.pop(),None)
  assert_eq!(list.length,0)
}

test "shift unshift"{
  let list: @linklist.LinkList[String] = @linklist.LinkList::new().unshift("test").unshift("dxsoft").unshift("data")
  for str in list{
    println(str)
  }  
  let end = list.peek()
  println("尾巴数据:\{end} 准备从头取数据")
  assert_eq!(list.shift(),Some("data"))
  assert_eq!(list.shift(),Some("dxsoft"))
  for str in list{
    println(str)
  }
}

test "iter"{
  let list: @linklist.LinkList[String] = @linklist.LinkList::new()
  let _=list.push("test").push("dxsoft").push("data")
  for str in list{
    println(str)
  }
  println("下面是反向迭代")
  let m = list.reverse_iter()
  for str in m{
    println(str)    
  }
}

test "remove"{
  let list: @linklist.LinkList[String] = @linklist.LinkList::new()
  let _=list.push("test").push("dxsoft").push("data")
  assert_eq!(list.remove("data"),true)
  assert_eq!(list.length,2)
  for str in list{
    println(str)
  }
}

test "drop_while"{
  let list: @linklist.LinkList[Int] = @linklist.LinkList::new()
  let _=list.push(1).push(2).push(3).push(4).push(5).push(6).push(7).push(8).push(9)
  let _ =list.drop_while(fn(value)->Bool{
    value % 2 == 0
  })
  for str in list{
    println(str)
  }
}

test "map"{
  let list: @linklist.LinkList[Int] = @linklist.LinkList::new().push(1).push(2).push(3).push(4)
  let lst = list.map(fn(v)->Int{v*2})
  for ele in lst{
    println(ele)
  }
}