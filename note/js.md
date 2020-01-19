### MDN

https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/assign

**在js中，函数也可以作为形参**

### ES6

#### 函数参数

   函数参数的定义直接写参数名称

#### 解构

   解析json数据和json对象时使用解构可以不用一个一个属性解析

#### 参数默认值

```javascript
function sayHello(name){
	//传统的指定默认参数的方式
	var name=name||'dude';
	console.log('Hello '+name);
}
//运用ES6的默认参数
function sayHello2(name='dude'){
	console.log(`Hello ${name}`);
}
sayHello();//输出：Hello dude
sayHello('Wayou');//输出：Hello Wayou
sayHello2();//输出：Hello dude
sayHello2('Wayou');//输出：Hello Wayou
```

#### 不定参数

```javascript
function add(...x){
    
}
```

#### let和const

可以把let看成var,只是它定义的变量被限定在特定范围之内被使用，离开这个范围则无效，const则很直观，const是定义常量

#### for of

我们都知道for in 循环用于遍历数组、类数组或对象，ES6新引入for of，for of  每次循环提供的不是序号而是值

```javascript
var someArray={'a','b','c'};
for (value of someArray){
    console.log(value);
}
```

#### == vs ===

 ===首先要求比较双方类型相同, 还要求比较双方值相等。 如果比较的双方是都是对象类型(即Object)，只有指向同一个对象，才能严格相等。关于javascript的数据类型 

 ==在进行比较时，如果比较的双方数据类型不同，通常会先转换成相同的类型再进行比较。如果比较的双方类型相同，这时与[===](http://ks-test.hz.netease.com/blog?id=849#strictEqual)相同：如果比较的双方是对象类型，只有指向同一个对象，才能相等;如果是其他类型，比较值是否相等 

 null和undefined在比较的时候不会转换成其他类型。null只和undefined相等 

#### Map,Set,WeakMap和WeakSet

```javascript
var sets = new Set();
sets.add("hello").add("goodbye");
sets.size()===2;
s.has("hello")===true;
var map = new Map();
map.set("1","hello");
map.set("2","googbye");
map.get("1")==="hello";
```

有时候我们会把对象作为一个对象的键用来存放属性值，**普通集合类型比如简单对象会阻止垃圾回收器对这些作为属性键存在的对象的回收，有造成内存泄漏的危险**。而WeakMap,WeakSet则更加安全些，这些作为属性键的对象如果没有别的变量在引用它们，则会被回收释放掉，具体还看下面的例子

```javascript
// Weak Maps
var wm = new WeakMap();
wm.set(s, { extra: 42 });
wm.size === undefined

// Weak Sets
var ws = new WeakSet();
ws.add({ data: 42 });//因为添加到ws的这个临时对象没有其他变量引用它，所以ws不会保存它的值，也就是说这次添加其实没有意思
```

#### promise



### 同源策略

**两个页面地址中的协议、域名和端口号一致，则表示同源**

例如该地址 [https://www.google.com](https://www.google.com/) 和以下地址对比

|              地址               | 同源 | 原因                   |
| :-----------------------------: | :--: | ---------------------- |
|      http://www.google.com      |  否  | 协议不一样             |
|       https://google.com        |  否  | 域名不一样             |
|    https://www.google.com:81    |  否  | 端口不一样             |
| https://www.google.com/a/s.html |  是  | 协议，端口和域名都一样 |

#### 同源策略的限制：

1. 存储在浏览器中的数据，如localStroage、Cooke和IndexedDB不能通过脚本跨域访问
2. 不能通过脚本操作不同域下的DOM
3. **不能通过ajax请求不同域的数据**

#### 原因

设置同源限制主要是为了安全，如果没有同源限制存在浏览器中的cookie等其他数据可以任意读取，不同域下DOM任意操作，Ajax任意请求的话如果浏览了恶意网站那么就会泄漏这些隐私数据

#### ajax解决办法

##### 1jsonp

虽然跨域限制了Ajax请求，但是却并不影响跨域引用脚本

**jsonp只支持GET请求**

##### 2 CROS

后台程序的响应头加上如下字段

Access-Control-Allow-Origin: http://example.com

后台响应接口请求的时候要在响应头上加上该字段，值是允许发送跨域请求的域名，可以设置多个用逗号分隔。如果全都允许可以设置成 * （**并不建议这么做**）

##### 3 websocket

WebSocket 是一种网络通信协议,HTTP 协议有一个缺陷：**通信只能由客户端发起**

它的最大特点就是，服务器可以主动向客户端推送信息，客户端也可以主动向服务器发送信息，是真正的双向平等对话，属于服务器推送技术的一种。WebSocket 允许服务器端与客户端进行全双工（full-duplex）的通信

其他特点:

**1默认端口也是80和443**

2 握手阶段采用 HTTP 协议

3 可以发送文本，也可以发送二进制数据

4 没有同源限制，客户端可以与任意服务器通信，完全可以取代 Ajax

5 协议标识符是`ws`（如果加密，则为`wss`，对应 HTTPS 协议），服务器网址就是 URL

```html
ws://example.com:80/some/path
```

### Object.assign()

https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/assign

### return/break/continue

break/continue和java一样

 return语句就是用于指定函数返回的值。return语句只能出现在函数体内，出现在代码中的其他任何地方都会造成语法错误！

**return的用法和java很类似，javascript不需要在函数声明返回的类型，可以直接return ,reutrn ;和java的一样**

### 数据类型

 javascript包含六个基本的数据类型：String, Number, Boolean, Undefined, Null, Object 

#### Undefined

Undefined类型只有一个值undefined，表示没有值。除显式的赋值为undefined外，下面情况下会产生undefined:

1. 变量声明但没有赋值
2. 获取对象不存在的属性
3. 函数没有返回
4. 函数的参数没有传入
5. `void(expression)`

#### Null

 Null类型也只有一个值null 

#### Object

 对象是一组属性的集合。Javascript可以通过对象字面量创建对象，也可以使用构造函数创建对象 

###  charAt() 

 str.charAt(str.length-1) 

###  substr()

str.substr(str.length-1,1) 

### 字符转数字

parseInt()

### 反射

~~~javascript
Object.keys(obj).forEach((item)=>{ console.log(`key===${item}, value===${obj[item]}`);})
for(var i in obj){ console.log(i); }
~~~

![](D:\softpackage\note\note\images\js\反射和遍历.png)

例子2

**当attributeObj是对象时，attribuex是对象的key,this.attributes[attribuex]是对象的value**

**当attributeObj是数组时，attribuex是数组的下表**

****

~~~javascript
Object.keys(attributeObj).forEach((attribuex)=>{
        this.attributes[attribuex]=true;
       
      });
// 两种方式都可以
for(let attribuex in attributeObj ){
          this.attributes[attribuex]=false;
      }
~~~

### 数组

**注意:js的数组直接赋值和java的引用传递是一样的，即有一个改变则另外一个也会对应改变，解决办法是使用循环来赋值，即数组之间通过“=”赋值是浅拷贝**

~~~javascript
var A=[12,78,78,78,89]
console.log(A)

//第二种
var B=new Array();
B[0]=12
B[1]=34
B[2]=56
console.log(B)


//第三种
var C=new Array(3);
C[0]=12
C[1]=34
C[2]=56
console.log(C)


//第四种

var D=new Array(45,78,89,45);
console.log(D)
~~~

### typeof

判断数据类型

~~~javascript
var a="";
var b =null;
typeof a
typeof(b)
~~~

### ECMAScript

#### 数据类型

 符串（String）、数字(Number)、布尔(Boolean)、对空（Null）、未定义（Undefined）、Symbol 

**注：Symbol 是 ES6 引入了一种新的原始数据类型，表示独一无二的值**

##### 引用数据类型：

对象(Object)、数组(Array)、函数(Function)

**特点：存储的是该对象在栈中引用，真实数据存放在堆内存中**

**引用数据类型在栈中存储了指针，该指针指向堆中该实体的起始地址。当解释器寻找引用值时，会首先检索其在栈中的地址，取得地址后从堆中获得实体**

### Object.assign()

Object.assign() 方法用于将所有可枚举属性的值从一个或多个源对象复制到目标对象。它将返回目标对象 

~~~javascript
const target = { a: 1, b: 2 };
const source = { b: 4, c: 5 };

const returnedTarget = Object.assign(target, source);

console.log(target);
// expected output: Object { a: 1, b: 4, c: 5 }

console.log(returnedTarget);
// expected output: Object { a: 1, b: 4, c: 5 }
~~~

如果目标对象中的属性具有相同的键，则属性将被源对象中的属性覆盖。后面的源对象的属性将类似地覆盖前面的源对象的属性。

`Object.assign` 方法只会拷贝源对象自身的并且可枚举的属性到目标对象。该方法使用源对象的`[[Get]]`和目标对象的`[[Set]]`，所以它会调用相关 getter 和 setter。因此，它分配属性，而不仅仅是复制或定义新的属性。如果合并源包含getter，这可能使其不适合将新属性合并到原型中。为了将属性定义（包括其可枚举性）复制到原型，应使用[`Object.getOwnPropertyDescriptor()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptor)和[`Object.defineProperty()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty) 。

[`String`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/String)类型和 [`Symbol`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Symbol) 类型的属性都会被拷贝。

在出现错误的情况下，例如，如果属性不可写，会引发[`TypeError`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/TypeError)，如果在引发错误之前添加了任何属性，则可以更改`target`对象。

注意，`Object.assign` 不会在那些`source`对象值为 [`null`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/null) 或 [`undefined`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/undefined) 的时候抛出错误

### 字符判空

~~~javascript
attributeList == null ||attributeList == undefined ||Object.keys(attributeList).length == 0
~~~

### find



### 闭包

https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Closures

Closures--闭包

1 背景:处于种种原因，有时候我们需要得到函数内部的局部变量，正常情况下是做不到的，解决办法是**在函数内部再定义一个函数，在内部函数返回需要访问的变量**

闭包是一种保护私有变量的机制，在函数执行时形成私有的作用域，保护里面的私有变量不受外界干扰。

直观的说就是形成一个不销毁的栈环境

#### 链式作用域

子对象会一级一级的向上寻找**所有父对象**的变量，父对象的所有变量对子对象都是可见的，反之不成立

~~~javascript
function f1(){
	var n=999;
	function f2(){
		alter(n);
	}
	return f2;
}
var result=f1();
result();//999
~~~

**闭包就是能够读取其他函数内部变量的函数**

用法

1 访问局部变量，例如上面的例子

2 让变量始终保持在内存中

~~~javascript
function f1(){
	var n=999;
    nAdd = function() {n+=1;}//匿名函数
	function f2(){
		alter(n);
	}
	return f2;
}
var result=f1();
result();//999
nAdd();//
result();//1000
~~~

在这段代码中，result实际上就是闭包f2函数。它一共运行了两次，第一次的值是999，第二次的值是1000。这证明了，函数f1中的局部变量n一直保存在内存中，并没有在f1调用后被自动清除。

为什么会这样呢？原因就在于f1是f2的父函数，而f2被赋给了一个全局变量，这导致f2始终在内存中，而f2的存在依赖于f1，因此f1也始终在内存中，不会在调用结束后，被垃圾回收机制（garbage collection）回收

 这段代码中另一个值得注意的地方，就是"nAdd=function(){n+=1}"这一行，首先在nAdd前面没有使用var关键字，因此nAdd是一个全局变量，而不是局部变量。其次，nAdd的值是一个**匿名函数（anonymous function）**，而这个匿名函数本身也是一个闭包，所以nAdd相当于是一个setter，可以在函数外部对函数内部的局部变量进行操作 

 利用闭包可以读取函数内部的变量，变量在函数外部不能直接读取到，从而达到保护变量安全的作用。因为私有方法在函数内部都能被访问到，从而实现了私有属性和方法的共享 

### 函数的定义

1 funciton name(){}

2 使用var

~~~javascript
var vname={
    name1:function(){
        
    }
}
~~~

3 var functionOne=  function(){}

4 匿名函数

### window对象

所有浏览器都支持 window 对象。它表示浏览器窗口。

所有 JavaScript 全局对象、函数以及变量均自动成为 window 对象的成员。

全局变量是 window 对象的属性。

全局函数是 window 对象的方法。

甚至 HTML DOM 的 document 也是 window 对象的属性之一

### prototype

所有的 JavaScript 对象都会从一个 prototype（原型对象）中继承属性和方法：

- `Date` 对象从 `Date.prototype` 继承。
- `Array` 对象从 `Array.prototype` 继承。
- `Person` 对象从 `Person.prototype` 继承

对象的构造函数中添加属性或方法。

使用 prototype 属性就可以给对象的构造函数添加新的属性

~~~javascript
function Person(first, last, age, eyecolor) {
  this.firstName = first;
  this.lastName = last;
  this.age = age;
  this.eyeColor = eyecolor;
}
 
Person.prototype.nationality = "English"
~~~

 prototype 属性就可以给对象的构造函数添加新的方法 

~~~javascript
function Person(first, last, age, eyecolor) {
  this.firstName = first;
  this.lastName = last;
  this.age = age;
  this.eyeColor = eyecolor;
}
 
Person.prototype.name = function() {
  return this.firstName + " " + this.lastName;
};
~~~

### 字符串判空

~~~javascript
if(str==null||str==='undefined'||str===''){
   
   }
~~~

### join

join() 方法用于把数组中的所有元素放入一个字符串

```javascript
arrayObject.join(separator) //指定要使用的分隔符。如果省略该参数，则使用逗号作为分隔符
// 例子
let strJoin=["1234","87654"];
let  str=strJoin.join();// str等于"1234,87654"等同于java中的String.join(数组,",")
```

### findIndex



### require

**从理解上，require是赋值过程，import是解构过程，当然，require也可以将结果解构赋值给一组变量，但是import在遇到default时，和require则完全不同**



### splice()

```javascript
arrayObject.splice(index,howmany,item1,.....,itemX)
```

| 参数              | 描述                                                         |
| :---------------- | :----------------------------------------------------------- |
| index             | 必需。整数，规定添加/删除项目的位置，使用负数可从数组结尾处规定位置。 |
| howmany           | 必需。要删除的项目数量。如果设置为 0，则不会删除项目。       |
| item1, ..., itemX | 可选。向数组添加的新项目。                                   |

### event

event对象代表事件的状态，比如事件在其中发生的元素、键盘按键的状态，鼠标的位置， 鼠标按钮的状态

#### 事件流

例如用户单击了一个元素，该元素拥有click事件，那么同样的事件也会被它的祖先触发，这个事件从该元素一直冒泡到DOM树的最上层，这一过程称为冒泡事件

![](js.assets/%E5%86%92%E6%B3%A1.png)

冒泡的属性

![](js.assets/%E5%86%92%E6%B3%A12.png)

#### 捕获

事件捕获和事件冒泡是相反的，当用户触发一个事件的时候，这个事件是从DOM树的最上层开始触发一直到捕获事件源

#### 事件流的写法和实现方式

element.addEventListener(eventType,fn,false)--dom对象.addEventLinstener(事件类型，回调函数和事件机制)，这里的事件类型表示你要使用哪种类型比如click，回调函数里面写触发此事件你要做什么，事件机制分为冒泡和捕获，false--事件冒泡，true--事件捕获

IE写法:

dom对象.attachEvent(eventType,fn)第一个参数表示事件类型，第二个是回调，IE没有事件捕获

event对象属性

| 属性          | 描述                                         |
| ------------- | -------------------------------------------- |
| altKey        | 返回当事件被触发时，”ALT” 是否被按下。       |
| button        | 返回当事件被触发时，哪个鼠标按钮被点击。     |
| clientX       | 返回当事件被触发时，鼠标指针的水平坐标。     |
| clientY       | 返回当事件被触发时，鼠标指针的垂直坐标。     |
| ctrlKey       | 返回当事件被触发时，”CTRL” 键是否被按下。    |
| metaKey       | 返回当事件被触发时，”meta” 键是否被按下。    |
| relatedTarget | 返回与事件的目标节点相关的节点。             |
| screenX       | 返回当某个事件被触发时，鼠标指针的水平坐标。 |
| screenY       | 返回当某个事件被触发时，鼠标指针的垂直坐标。 |
| shiftKey      | 返回当事件被触发时，”SHIFT” 键是否被按下。   |

IE对象的属性

| `cancelBubble`  | 如果事件句柄想阻止事件传播到包容对象，必须把该属性设为 true。 |
| --------------- | ------------------------------------------------------------ |
| fromElement     | 对于 mouseover 和 mouseout 事件，fromElement 引用移出鼠标的元素。 |
| keyCode         | 对于 keypress 事件，该属性声明了被敲击的键生成的 Unicode 字符码。对于 keydown 和 keyup |
| offsetX,offsetY | 发生事件的地点在事件源元素的坐标系统中的 x 坐标和 y 坐标。   |
| `returnValue`   | 如果设置了该属性，它的值比事件句柄的返回值优先级高。把这个属性设置为 |
| `srcElement`    | 对于生成事件的 Window 对象、Document 对象或 Element 对象的引用。 |
| toElement       | 对于 mouseover 和 mouseout 事件，该属性引用移入鼠标的元素。  |
| x,y             | 事件发生的位置的 x 坐标和 y 坐标，它们相对于用CSS动态定位的最内层包容元素。 |

标准 Event 属性 下面列出了 2 级 DOM 事件标准定义的属性

| **属性和方法**         | **描述**                                           |
| ---------------------- | -------------------------------------------------- |
| **bubbles**            | **返回布尔值，指示事件是否是起泡事件类型。**       |
| **`cancelable`**       | **返回布尔值，指示事件是否可拥可取消的默认动作。** |
| **`currentTarget`**    | **返回其事件监听器触发该事件的元素。**             |
| **eventPhase**         | **返回事件传播的当前阶段。**                       |
| **`target`**           | **返回触发此事件的元素（事件的目标节点）。**       |
| **timeStamp**          | **返回事件生成的日期和时间。**                     |
| **`type`**             | **返回当前 Event 对象表示的事件的名称。**          |
| **initEvent()**        | **初始化新创建的 Event 对象的属性。**              |
| **`preventDefault()`** | **通知浏览器不要执行与事件关联的默认动作。**       |
| `stopPropagation()`    | 不再派发事件。                                     |

#### Event对象的一些兼容写法

~~~javascript
获得event对象兼容性写法 
event || (event = window.event);
获得target兼容型写法 
event.target||event.srcElement
阻止浏览器默认行为兼容性写法 
event.preventDefault ? event.preventDefault() : (event.returnValue = false);
阻止冒泡写法 
event.stopPropagation ? event.stopPropagation() : (event.cancelBubble = true);
~~~

事件绑定和取消事件绑定方法的形式

~~~javascript
//事件绑定
function on(dom, eventType, fn) {
    if(dom.addEventListener) {
        dom.addEventListener(eventType, fn);
    } else {
        if(dom.attachEvent) {
            dom.attachEvent('on' + eventType, fn);
        }
}
//取消事件绑定
function un(dom, eventType, fn) {
     if(dom.removeEventListener) {
         dom.removeEventListener(eventType, fn, false);
     } else {
         if(dom.detachEvent) {
             dom.detachEvent("on" + eventType, fn)
         }
     }
 
 }
~~~

### Promise

在JavaScript的世界中，所有代码都是单线程执行的

JavaScript的所有网络操作，浏览器事件，都必须是异步执行

**在js中，函数也可以作为形参**

promise的状态

1、pending[待定]初始状态
2、fulfilled[实现]操作成功
3、rejected[被否决]操作失败

Promise对象的状态改变，只有两种可能：
从pending变为fulfilled
从pending变为rejected

#### resovle/reject

resolve作用是，将Promise对象的状态从“未完成”变为“成功”（即从 pending 变为 resolved），在异步操作成功时调用，并将异步操作的结果，作为参数传递出去；
 reject作用是，将Promise对象的状态从“未完成”变为“失败”（即从 pending 变为 rejected），在异步操作失败时调用，并将异步操作报出的错误，作为参数传递出去