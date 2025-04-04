// Copyright 2024 suiyunonghen
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
struct Node[T] {
  mut prev : Node[T]?
  mut next : Node[T]?
  value : T
}

///|
pub fn Node::value[T](self : Node[T]) -> T {
  self.value
}

///|
pub fn Node::to_string[T : Show](self : Node[T]) -> String {
  self.value.to_string()
}

///|
pub fn Node::findNode[T : Eq](self : Node[T], value : T) -> Node[T]? {
  if self.value == value {
    return Some(self)
  }
  loop self.next {
    Some(current) => {
      if current.value == value {
        break Some(current)
      }
      continue current.next
    }
    _ => None
  }
}

///|
pub fn Node::findNodeEx[T](self : Node[T], f : (T) -> Bool) -> Node[T]? {
  if f(self.value) {
    return Some(self)
  }
  loop self.next {
    Some(current) => {
      if f(current.value) {
        break Some(current)
      }
      continue current.next
    }
    _ => None
  }
}

///|
pub fn Node::rfindNode[T : Eq](self : Node[T], value : T) -> Node[T]? {
  if self.value == value {
    return Some(self)
  }
  loop self.prev {
    Some(prv) => {
      if prv.value == value {
        break Some(prv)
      }
      continue prv.prev
    }
    _ => None
  }
}

///|
pub fn Node::rfindNodeEx[T](self : Node[T], f : (T) -> Bool) -> Node[T]? {
  if f(self.value) {
    return Some(self)
  }
  loop self.prev {
    Some(prv) => {
      if f(prv.value) {
        break Some(prv)
      }
      continue prv.prev
    }
    _ => None
  }
}

///|
pub fn Node::iter[T](self : Node[T]) -> Iter[T] {
  Iter::new(
    fn(yieldfn) {
      loop self.next, yieldfn(self.value) {
        Some(current), _ =>
          match yieldfn(current.value) {
            IterContinue => continue current.next, IterContinue
            IterEnd => break IterEnd
          }
        None, _ => break IterEnd
      }
    },
  )
}

///|
pub fn Node::reverse_iter[T](self : Node[T]) -> Iter[T] {
  Iter::new(
    fn(yieldfn) {
      loop self.prev, yieldfn(self.value) {
        Some(current), _ =>
          match yieldfn(current.value) {
            IterContinue => continue current.prev, IterContinue
            IterEnd => break IterEnd
          }
        None, _ => break IterEnd
      }
    },
  )
}

///|
pub struct LinkList[T] {
  priv mut head : Node[T]?
  priv mut tail : Node[T]?
  mut length : Int
}

///|
pub fn LinkList::new[T]() -> LinkList[T] {
  { head: None, tail: None, length: 0 }
}

///|
pub fn LinkList::op_get[T](self : LinkList[T], index : Int) -> T? {
  loop self.head, 0 {
    Some(current), idx => {
      if idx == index {
        break Some(current.value)
      }
      continue current.next, idx + 1
    }
    _, _ => break None
  }
}

///|Add data to the end of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[String] = @linklist.LinkList::new()
/// ..push("test")
/// ..push("dxsoft")
/// ..push("data")
/// for str in list{
///   println(str)
/// } 
/// ```
pub fn LinkList::push[T](self : LinkList[T], value : T) -> Unit {
  let newNode : Node[T] = { prev: self.tail, next: None, value }
  match self.head {
    None => self.head = Some(newNode)
    _ => self.tail.unwrap().next = Some(newNode)
  }
  self.tail = Some(newNode)
  self.length = self.length + 1
}

///|
pub fn LinkList::add[T](self : LinkList[T], value : T) -> Unit {
  self.push(value)
}

///|
pub impl[T : Show] Show for LinkList[T] with output(xs, logger) {
  logger.write_iter(xs.iter(), prefix="", suffix="", sep="<=>")
}

///|
pub fn LinkList::to_string[T : Show](xs : LinkList[T]) -> String {
  Show::to_string(xs)
}

///| Convert array to LinkList.
///
/// # Example
///
/// ```
/// let ls = @LinkList::from_array([1, 2, 3, 4, 5])
/// println(ls) // output: 1<=>2<=>3<=>4<=>5
/// ```
pub fn LinkList::from_array[T](arr : Array[T]) -> LinkList[T] {
  for i = 0, list = LinkList::default(); i < arr.length(); {
    list.push(arr[i])
    continue i + 1, list
  } else {
    list
  }
}

///|Pop up data from the end of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new()
/// ..push(123)
/// ..push(456)
/// ..push(789)
/// assert_eq!(list.pop(),Some(789))
/// assert_eq!(list.pop(),Some(456))
/// assert_eq!(list.pop(),Some(123))
/// assert_eq!(list.pop(),None)
/// assert_eq!(list.length,0)
/// ```
pub fn LinkList::pop[T](self : LinkList[T]) -> T? {
  match self.head {
    None => None
    _ => {
      let current = self.tail.unwrap()
      self.tail = current.prev
      match self.tail {
        None => self.head = None
        Some(tailNode) => tailNode.next = None
      }
      current.prev = None
      self.length = self.length - 1
      Some(current.value)
    }
  }
}

///|Detecting tail data of linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new()
/// ..push(123)
/// ..push(456)
/// ..push(789)
/// assert_eq!(list.peek(),Some(789))
/// assert_eq!(list.peek(),Some(789))
/// assert_eq!(list.length,3)
/// ```
pub fn LinkList::peek[T](self : LinkList[T]) -> T? {
  match self.head {
    None => None
    _ => Some(self.tail.unwrap().value)
  }
}

///|Pop up data from the head of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new()
/// ..push(123)
/// ..push(456)
/// ..push(789)
/// assert_eq!(list.shift(),Some(123))
/// assert_eq!(list.shift(),Some(456))
/// assert_eq!(list.shift(),Some(789))
/// assert_eq!(list.shift(),None)
/// assert_eq!(list.length,0)
/// ```
pub fn LinkList::shift[T](self : LinkList[T]) -> T? {
  match self.head {
    None => None
    Some(current) => {
      self.head = current.next
      match self.head {
        None => self.tail = None
        Some(head) => head.prev = None
      }
      self.length = self.length - 1
      current.next = None
      Some(current.value)
    }
  }
}

///|Insert data to the head of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[String] = @linklist.LinkList::new()
/// ..unshift("test")
/// ..unshift("dxsoft")
/// ..unshift("data")
/// for str in list{
///   println(str)
/// } 
/// ```
pub fn LinkList::unshift[T](self : LinkList[T], value : T) -> Unit {
  let newNode : Node[T] = { prev: None, next: self.head, value }
  match self.head {
    None => self.tail = Some(newNode)
    _ => self.head.unwrap().prev = Some(newNode)
  }
  self.head = Some(newNode)
  self.length = self.length + 1
}

///| for ele in LinkList
pub fn LinkList::iter[T](self : LinkList[T]) -> Iter[T] {
  Iter::new(
    fn(yieldfn) {
      loop self.head {
        Some(current) =>
          match yieldfn(current.value) {
            IterContinue => continue current.next
            IterEnd => break IterEnd
          }
        None => break IterEnd
      }
    },
  )
}

///| reverse iterator
/// # Example
///
/// ```
/// let list: @linklist.LinkList[String] = @linklist.LinkList::new()
/// ..push("反向")
/// ..push("迭代器")
/// let m = list.reverse_iter()
/// for str in m{
///   println(str) 
/// ```
/// }
pub fn LinkList::reverse_iter[T](self : LinkList[T]) -> Iter[T] {
  Iter::new(
    fn(yieldfn) {
      loop self.tail {
        Some(current) =>
          match yieldfn(current.value) {
            IterContinue => continue current.prev
            IterEnd => break IterEnd
          }
        None => break IterEnd
      }
    },
  )
}

///|
pub fn LinkList::clear[T](self : LinkList[T]) -> Unit {
  // loop self.head{
  //   Some(current)=>{
  //     current.prev = None
  //     let next = current.next
  //     current.next = None            
  //     continue next      
  //   }
  //   None=>break
  // }
  self.head = None
  self.tail = None
  self.length = 0
}

///| Maps the list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new()
/// ..push(1)
/// ..push(2)
/// ..push(3)
/// ..push(4)
/// let lst = list.map(fn(v)->Int{v*2})
/// // lst=[2,4,6,8]
/// ```
pub fn LinkList::map[A, B](self : LinkList[A], f : (A) -> B) -> LinkList[B] {
  let result : LinkList[B] = LinkList::new()
  loop self.head {
    Some(current) => {
      result.push(f(current.value))
      continue current.next
    }
    _ => break
  }
  result
}

///| Reverse maps the list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new()
/// ..push(1)
/// ..push(2)
/// ..push(3)
/// ..push(4)
/// let lst = list.reverse_map(fn(v)->Int{v*2})
/// // lst=8<=>6<=>4<=>2
/// ```
pub fn LinkList::reverse_map[A, B](self : LinkList[A], f : (A) -> B) -> LinkList[B] {
  let result : LinkList[B] = LinkList::new()
  loop self.tail {
    Some(current) => {
      result.push(f(current.value))
      continue current.prev
    }
    _ => break
  }
  result
}

///| Filter the list.
///
/// # Example
///
/// ```
/// println(of([1, 2, 3, 4, 5]).filter(fn(x){ x % 2 == 0}))
/// // output: from_array([2, 4])
/// ```
pub fn LinkList::filter[T](self : LinkList[T], f : (T) -> Bool) -> LinkList[T] {
  let result : LinkList[T] = LinkList::new()
  loop self.head {
    Some(current) => {
      if f(current.value) {
        result.push(current.value)
      }
      continue current.next
    }
    _ => break
  }
  result
}

///| Zip two LinkList.
/// If the lists have different lengths, it will return None.
///
/// # Example
///
/// ```
/// let r = zip(of[1, 2, 3, 4, 5]), of([6, 7, 8, 9, 10]))
/// println(r) // output: Some((1, 6)<=>(2, 7)<=>(3, 8)<=>(4, 9)<=>(5, 10))
/// ```
pub fn LinkList::zip[A, B](self : LinkList[A], other : LinkList[B]) -> LinkList[(A, B)]? {
  if self.length != other.length {
    None
  } else {
    let result : LinkList[(A, B)] = LinkList::new()
    loop self.head, other.head {
      Some(c1), Some(c2) => {
        result.push((c1.value, c2.value))
        continue c1.next, c2.next
      }
      _, _ => break
    }
    Some(result)
  }
}

///| Unzip two linkLists.
///
/// # Example
///
/// ```
/// let (a,b) = unzip(from_array([(1,2),(3,4),(5,6)]))
/// println(a) // output: from_array([1, 3, 5])
/// println(b) // output: from_array([2, 4, 6])
/// ```
pub fn LinkList::unzip[A, B](self : LinkList[(A, B)]) -> (LinkList[A], LinkList[B]) {
  let (resulta, resultb) = (LinkList::new(), LinkList::new())
  loop self.head {
    Some(node) => {
      resulta.push(node.value.0)
      resultb.push(node.value.1)
      continue node.next
    }
    _ => break
  }
  (resulta, resultb)
}

///| Check if the linkList contains the value.
pub fn LinkList::contains[T : Eq](self : LinkList[T], value : T) -> Bool {
  loop self.head {
    Some(current) => {
      if current.value == value {
        break true
      }
      continue current.next
    }
    None => break false
  }
}

///| remove value from linkList
pub fn LinkList::remove[T : Eq](self : LinkList[T], value : T) -> Bool {
  loop self.head {
    Some(current) => {
      if current.value == value {
        let next = current.next
        match next {
          Some(nextNode) => {
            nextNode.prev = current.prev
            match nextNode.prev {
              Some(prvNode) => prvNode.next = next
              None => self.head = next
            }
          }
          None =>
            match current.prev {
              Some(prv) => {
                prv.next = None
                self.tail = current.prev
              }
              _ => {
                self.head = None
                self.tail = None
              }
            }
        }
        self.length = self.length - 1
        break true
      }
      continue current.next
    }
    None => break false
  }
}

///| Drop the longest prefix of a LinkList of elements that satisfies a given predicate.
///
/// # Example
///
/// ```
/// from_array([1, 2, 3, 4]).drop_while(fn(x) { x < 3 })
/// ```
pub fn LinkList::drop_while[T](self : LinkList[T], f : (T) -> Bool) -> LinkList[T] {
  loop self.head {
    Some(current) => {
      let next = current.next
      if f(current.value) {
        match next {
          Some(nextNode) => {
            nextNode.prev = current.prev
            match nextNode.prev {
              Some(prvNode) => prvNode.next = next
              None => self.head = next
            }
          }
          None =>
            match current.prev {
              Some(prv) => {
                prv.next = None
                self.tail = current.prev
              }
              _ => {
                self.head = None
                self.tail = None
              }
            }
        }
        self.length = self.length - 1
      }
      continue next
    }
    None => break self
  }
}

///| Looks up a key in an association LinkList.
///
/// # Example
///
/// ```
/// let ls = from_array([(1, "a"), (2, "b"), (3, "c")])
/// ls.lookup(3) // output: Some("c")
/// ```
pub fn LinkList::lookup[A : Eq, B](self : LinkList[(A, B)], value : A) -> B? {
  loop self.head {
    Some(current) => {
      if current.value.0 == value {
        break Some(current.value.1)
      }
      continue current.next
    }
    None => None
  }
}

///| Find the first element in the LinkList that satisfies f.
///
/// # Example
///
/// ```
/// println(of([1, 3, 5, 8]).find(fn(element) -> Bool { element % 2 == 0}))
/// // output: Some(8)
/// ```
pub fn LinkList::find[T](self : LinkList[T], f : (T) -> Bool) -> T? {
  loop self.head {
    Some(current) => {
      if f(current.value) {
        break Some(current.value)
      }
      continue current.next
    }
    _ => None
  }
}

///| Find the first elementNode in the LinkList that satisfies f.
///
/// # Example
///
/// ```
/// let node5 = list.findNode(fn(value:Int)->Bool{
///     value==5
///   })
///   match node5{
///    Some(v)=>{
///      println("查到了内容\{v},下面准备从这里开始往后迭代")
///      for value in v{
///        println(value)
///      }
///      println("准备反向迭代")
///      for value in v.reverse_iter(){
///        println(value)
///      }
///    }
///    None=>println("悟了")
///  }
/// // output: Some(8)
/// ```
pub fn LinkList::findNode[T](self : LinkList[T], f : (T) -> Bool) -> Node[T]? {
  match self.head {
    Some(head) => head.findNodeEx(f)
    _ => None
  }
}

///| Move the first element found to the end of the linked list
/// 
/// # Example
///
/// ```
/// let list = @linklist.LinkList::of([1,2,3,4,5,6,7,8,9])
/// list.sendtoback(8,findFromEnd=true)
/// // 1<=>2<=>3<=>4<=>5<=>6<=>7<=>9<=>8
/// ```
pub fn LinkList::sendtoback[T : Eq](
  self : LinkList[T],
  value : T,
  findFromEnd~ : Bool = true
) -> Unit {
  match self.tail {
    Some(tail) => {
      if tail.value == value {
        return
      }
      let findNode = if findFromEnd {
        tail.rfindNode(value)
      } else {
        self.head.unwrap().findNode(value)
      }
      match findNode {
        Some(node) => {
          let next = node.next
          next.unwrap().prev = node.prev
          match node.prev {
            Some(prvNode) => prvNode.next = next
            None => self.head = next
          }
          self.tail.unwrap().next = Some(node)
          node.prev = self.tail
          node.next = None
          self.tail = Some(node)
          return
        }
        None => ()
      }
    }
    _ => ()
  }
  self.push(value)
}

///| Move the first element found to the beginning of the linked list
/// 
/// # Example
///
/// ```
/// let list = @linklist.LinkList::of([1,2,3,4,5,6,7,8,9])
/// list.bringtofront(4,findFromHead=false)
/// // 4<=>1<=>2<=>3<=>5<=>6<=>7<=>8<=>9
/// ```
pub fn LinkList::bringtofront[T : Eq](
  self : LinkList[T],
  value : T,
  findFromHead~ : Bool = true
) -> Unit {
  match self.head {
    Some(head) => {
      if head.value == value {
        return
      }
      let findNode = if findFromHead {
        head.findNode(value)
      } else {
        self.tail.unwrap().rfindNode(value)
      }
      match findNode {
        Some(node) => {
          let prvNode = node.prev
          prvNode.unwrap().next = node.next
          match node.next {
            Some(nextNode) => nextNode.prev = prvNode
            None => self.tail = prvNode
          }
          self.head.unwrap().prev = Some(node)
          node.next = self.head
          node.prev = None
          self.head = Some(node)
          return
        }
        _ => ()
      }
    }
    _ => ()
  }
  self.unshift(value)
}

///|
pub fn LinkList::default[T]() -> LinkList[T] {
  { head: None, tail: None, length: 0 }
}

///|
pub fn LinkList::from_iter[T](iter : Iter[T]) -> LinkList[T] {
  iter.fold(
    init=LinkList::default(),
    fn(list, e) {
      list.push(e)
      list
    },
  )
}

///|
pub fn LinkList::of[T](arr : FixedArray[T]) -> LinkList[T] {
  let result : LinkList[T] = LinkList::new()
  for ele in arr {
    result.push(ele)
  }
  result
}
