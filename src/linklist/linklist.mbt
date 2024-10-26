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

priv struct Node[T]{
  mut prev: Option[Node[T]]
  mut next: Option[Node[T]]
  value: T  
}

pub (readonly) struct LinkList[T]{
  priv mut head: Option[Node[T]]
  priv mut tail: Option[Node[T]]
  mut length: Int
}

pub fn LinkList::new[T]()->LinkList[T]{
  {
    head: None,
    tail: None,
    length: 0,
  }
}

///Add data to the end of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[String] = @linklist.LinkList::new()
/// let _=list.push("test").push("dxsoft").push("data")
/// for str in list{
///   println(str)
/// } 
/// ```
pub fn push[T](self: LinkList[T],value: T)->LinkList[T]{  
  let newNode: Node[T]={
    prev: self.tail,
    next: None,
    value,
  }
  match self.head{
   None=>self.head = Some(newNode)
   _=>self.tail.unwrap().next=Some(newNode)
  }
  self.tail = Some(newNode)
  self.length = self.length + 1
  self
}

///Pop up data from the end of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new().push(123).push(456).push(789)
/// assert_eq!(list.pop(),Some(789))
/// assert_eq!(list.pop(),Some(456))
/// assert_eq!(list.pop(),Some(123))
/// assert_eq!(list.pop(),None)
/// assert_eq!(list.length,0)
/// ```
pub fn pop[T](self: LinkList[T])->Option[T]{
  match self.head{
    None=>None
    _=>{
      let current = self.tail.unwrap()
      self.tail = current.prev
      match self.tail{
        None=>self.head = None
        Some(tailNode)=>tailNode.next = None
      }
      current.prev = None
      self.length = self.length - 1
      Some(current.value)
    }
  }
}

///Detecting tail data of linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new().push(123).push(456).push(789)
/// assert_eq!(list.peek(),Some(789))
/// assert_eq!(list.peek(),Some(789))
/// assert_eq!(list.length,3)
/// ```
pub fn peek[T](self: LinkList[T])->Option[T]{
  match self.head{
    None=>None
    _=>Some(self.tail.unwrap().value)
  }
}

///Pop up data from the head of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new().push(123).push(456).push(789)
/// assert_eq!(list.shift(),Some(123))
/// assert_eq!(list.shift(),Some(456))
/// assert_eq!(list.shift(),Some(789))
/// assert_eq!(list.shift(),None)
/// assert_eq!(list.length,0)
/// ```
pub fn shift[T](self: LinkList[T])->Option[T]{
  match self.head{
    None=>None
    Some(current)=>{
      self.head = current.next
      match self.head{
        None=>self.tail = None
        Some(head)=>head.prev = None
      }
      self.length = self.length - 1
      current.next = None
      Some(current.value)
    }
  }
}

///Insert data to the head of the linked list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[String] = @linklist.LinkList::new().unshift("test").unshift("dxsoft").unshift("data")
/// for str in list{
///   println(str)
/// } 
/// ```
pub fn unshift[T](self: LinkList[T],value: T)->LinkList[T]{
  let newNode: Node[T]={
    prev: None,
    next: self.head,
    value,
  }
  match self.head{
    None=>self.tail = Some(newNode)
    _=>self.head.unwrap().prev = Some(newNode)
  }
  self.head = Some(newNode)
  self.length = self.length+1
  self
}

pub fn iter[T](self : LinkList[T]) -> Iter[T] {
  Iter::new(
    fn(yield){
      loop self.head{
        Some(current)=>{
          match yield(current.value){
            IterContinue=>continue current.next
            IterEnd=>break IterEnd
          }          
        }
        None=>break IterEnd
      }
    }
  )
}

/// reverse iterator
/// let list: @linklist.LinkList[String] = @linklist.LinkList::new().push("反向").push("迭代器")
/// let m = list.reverse_iter()
/// for str in m{
///   println(str) 
/// }
pub fn reverse_iter[T](self: LinkList[T])->Iter[T]{
  Iter::new(
    fn(yield){
      loop self.tail{
        Some(current)=>{
          match yield(current.value){
            IterContinue=>continue current.prev
            IterEnd=>break IterEnd
          }          
        }
        None=>break IterEnd
      }
    }
  )
}

pub fn clear[T](self: LinkList[T])->Unit{
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

/// Maps the list.
///
/// # Example
///
/// ```
/// let list: @linklist.LinkList[Int] = @linklist.LinkList::new().push(1).push(2).push(3).push(4)
/// let lst = list.map(fn(v)->Int{v*2})
/// // lst=[2,4,6,8]
/// ```
pub fn map[A,B](self: LinkList[A],f: (A)->B)->LinkList[B]{
  let result: LinkList[B] = LinkList::new()
  loop self.head{
    Some(current)=>{
      let _ = result.push(f(current.value))
      continue current.next
    }
    _=>break
  }
  result
}

pub fn reverse_map[A,B](self: LinkList[A],f: (A)->B)->LinkList[B]{
  let result: LinkList[B] = LinkList::new()
  loop self.tail{
    Some(current)=>{
      let _=result.push(f(current.value))
      continue current.next
    }
    _=>break
  }
  result
}

pub fn filter[T](self: LinkList[T],f:(T)->Bool)->LinkList[T]{
  let result: LinkList[T] = LinkList::new()
  loop self.head{
    Some(current)=>{
      if f(current.value){
        let _ = result.push(current.value)
      }
      continue current.next
    }
    _=>break
  }
  result
}

pub fn zip[A,B](self: LinkList[A],other: LinkList[B])->LinkList[(A,B)]?{
  if self.length != other.length{
    None
  }else{
    let result: LinkList[(A,B)] = LinkList::new()
    loop self.head,other.head{
      Some(c1),Some(c2)=>{
        let _=result.push((c1.value,c2.value))
        continue c1.next,c2.next
      }
      _,_=>break
    }
    Some(result)
  }
}

pub fn unzip[A,B](self: LinkList[(A,B)])->(LinkList[A],LinkList[B]){
  let (resulta,resultb)=(LinkList::new(),LinkList::new())
  loop self.head{
    Some(node)=>{
      let _=resulta.push(node.value.0)
      let _=resultb.push(node.value.1)
      continue node.next
    }
    _=>break
  }
  (resulta,resultb)
}

pub fn contains[T: Eq](self: LinkList[T],value: T)->Bool{
  loop self.head{
    Some(current)=>{
      if current.value == value{
        break true
      }
      continue current.next
    }
    None=>break false
  }
}

pub fn remove[T:Eq](self: LinkList[T],value: T)->Bool{
  loop self.head{
    Some(current)=>{      
      if current.value == value{
        let next=current.next
        match next{
          Some(nextNode)=>{            
            nextNode.prev = current.prev
            match nextNode.prev{
              Some(prvNode)=>prvNode.next = next
              None=>self.head = next
            }
          }
          None=>{
            match current.prev{
              Some(prv)=>{
                prv.next = None
                self.tail = current.prev
              }
              _=>{
                self.head = None
                self.tail = None
              }
            }
            
          }
        }        
        self.length = self.length-1
        break true
      }
      continue current.next
    }
    None=>break false
  }
}

pub fn drop_while[T](self: LinkList[T],f:(T)->Bool)->LinkList[T]{
  loop self.head{
    Some(current)=>{
      let next=current.next
      if f(current.value){        
        match next{
          Some(nextNode)=>{            
            nextNode.prev = current.prev
            match nextNode.prev{
              Some(prvNode)=>prvNode.next = next
              None=>self.head = next
            }
          }
          None=>{
            match current.prev{
              Some(prv)=>{
                prv.next = None
                self.tail = current.prev
              }
              _=>{
                self.head = None
                self.tail = None
              }
            }
            
          }
        }        
        self.length = self.length-1
      }
      continue next
    }
    None=>break self
  }
}

pub fn lookup[A: Eq,B](self: LinkList[(A,B)],value: A)->B?{
  loop self.head{
    Some(current)=>{
      if current.value.0 == value{
        break Some(current.value.1)
      }      
      continue current.next
    }
    None=>None    
  }
}

pub fn find[T](self: LinkList[T],f: (T)->Bool)->T?{
  loop self.head{
    Some(current)=>{
      if f(current.value){
        break Some(current.value)
      }
      continue current.next
    }
    _=>None
  }
}

pub fn LinkList::default[T]()->LinkList[T]{
  {
    head: None,
    tail: None,
    length: 0
  }
}

pub fn LinkList::from_iter[T](iter: Iter[T])->LinkList[T]{
  iter.fold(init=LinkList::default(),fn(list,e){list.push(e)})
}