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

1对于String ,number等基础类型

  ①不同类型比较，==将转化为同一类型比较值是否相等，===如果类型不同，则结果不等

   ②同类型比较，两个结果一样

2 对应Array和Object等高级类型，没有区别，都是比较指针地址

3 基础类型和高级类型

  ① ==将高级类型转为基础类型，进行值笔记

  ② 类型不同，则===结果为false



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

#####2 CROS

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