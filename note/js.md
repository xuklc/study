MDN

https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/assign

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

####let和const

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

####同源策略的限制：

1. 存储在浏览器中的数据，如localStroage、Cooke和IndexedDB不能通过脚本跨域访问
2. 不能通过脚本操作不同域下的DOM
3. **不能通过ajax请求不同域的数据**

####原因

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



### return/break/continue

break/continue和java一样

 return语句就是用于指定函数返回的值。return语句只能出现在函数体内，出现在代码中的其他任何地方都会造成语法错误！ 

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

