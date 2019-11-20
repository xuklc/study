### 注意 

**在postman中，如果get在，然后在body里增加参数给导致参数失效**

### 1 数组和字符串互转

1 字符串转数组

str.split(',');--以逗号拆分字符串

2 数组转字符串

arr.join(',')--将数据拼接成字符串，以逗号隔开

### 2 代码规范

vue的代码不能有空格，否则编译不通过



### 3 当有一处有语法错误

**vue不允许有空格**

npm install -g cnpm --registry



### node

#### 查看npm的基本配置

npm config list //查看基本配置

### chrome调试小技巧

**下图打钩Preserve log之后在在请求完成后即便是页面跳转也不会清除之前的请求，而是保留**

![](D:\note\note\images\chrome调试小技巧.png)



### nginx

http://www.nginx.cn/install



### 生命周期

#### create()

在一个vue实例生成后调用create()函数

 也有一些其它的钩子，在实例生命周期的不同阶段调用，如 mounted、 updated 、destroyed  

![](D:\softpackage\note\note\images\vue\vue生命周期.png)

### watch

在vue中，使用watch来响应数据的变化。watch的用法大致有三种。下面代码是watch的一种简单的用法：

```html
<input type="text" v-model="cityName"/>
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```javascript
new Vue({
  el: '#root',
  data: {
    cityName: 'shanghai'
  },
  watch: {
    cityName(newName, oldName) {
      // ...
    }
  } 
})
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

直接写一个监听处理函数，当每次监听到 cityName 值发生改变时，执行函数。也可以在所监听的数据后面直接加字符串形式的方法名：

```
watch: {
    cityName: 'nameChange'
    }
 } 
```

### immediate和handler

这样使用watch时有一个特点，就是当值第一次绑定的时候，不会执行监听函数，只有值发生改变才会执行。如果我们需要在最初绑定值的时候也执行函数，则就需要用到immediate属性。

比如当父组件向子组件动态传值时，子组件props首次获取到父组件传来的默认值时，也需要执行函数，此时就需要将immediate设为true。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```javascript
new Vue({
  el: '#root',
  data: {
    cityName: ''
  },
  watch: {
    cityName: {
    　　handler(newName, oldName) {
      　　// ...
    　　},
    　　immediate: true
    }
  } 
})
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

监听的数据后面写成对象形式，包含handler方法和immediate，之前我们写的函数其实就是在写这个handler方法；

immediate表示在watch中首次绑定的时候，是否执行handler，值为true则表示在watch中声明的时候，就立即执行handler方法，值为false，则和一般使用watch一样，在数据发生变化的时候才执行handler。

### deep

当需要监听一个对象的改变时，普通的watch方法无法监听到对象内部属性的改变，只有data中的数据才能够监听到变化，此时就需要deep属性对对象进行深度监听。

```html
<input type="text" v-model="cityName.name"/>
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```javascript
new Vue({
  el: '#root',
  data: {
    cityName: {id: 1, name: 'shanghai'}
  },
  watch: {
    cityName: {
      handler(newName, oldName) {
      // ...
    },
    deep: true,
    immediate: true
    }
  } 
})
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

设置deep: true 则可以监听到cityName.name的变化，此时会给cityName的所有属性都加上这个监听器，当对象属性较多时，每个属性值的变化都会执行handler。如果只需要监听对象中的一个属性值，则可以做以下优化：使用字符串的形式监听对象属性：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```javascript
watch: {
    'cityName.name': {
      handler(newName, oldName) {
      // ...
      },
      deep: true,
      immediate: true
    }
  }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

这样只会给对象的某个特定的属性加监听器。

数组（一维、多维）的变化不需要通过深度监听，对象数组中对象的属性变化则需要deep深度监听

### let和const

#### let

 es6新增了let命令，用来声明变量。它的用法类似于var，但是所声明的变量，只在let命令所在的代码块内有效 

**let声明的是局部变量**

**let命令改变了语法行为，它所声明的变量一定要在声明后使用，否则报错 **

**let不允许在相同作用域内，重复声明同一个变量 **

#### const

 const声明一个只读的常量。一旦声明，常量的值就不能改变 

### javascrip变量

#### 全局变量和局部变量

一般情况下，使用var定义的变量在**function函数里**的是**局部变量**，定义在**<script>块**中，在**function函数外**的是全局变量

 **当我们使用访问一个没有声明的变量时，JS会报错；而当我们给一个没有声明的变量赋值时，JS不会报错，相反它会认为我们是要隐式声明一个全局变量，这一点一定要注意** 

~~~javascript
<script>
    var str1 = "hello1";        //定义一个全局变量，实际上是一个variable
    str2 = "hello2";            //定义一个全局变量，实际上是在global下创建一个property
    window.str3 = "hello3";     //定义一个全局变量
    function func(){
        var str4 = "hello4";    //定义一个局部变量
        str5 = "hello5";   //定义一个全局变量--不是使用var生命变量，默认是全局变量，不管是全局在函数里
    }
</script>

 function func(){
    var a = b = 0;
        //. . .
 }
// a 是局部变量，b 是全局变量。原因很简单，由于操作符的优先级是从右到左的,先声明了变量b,然后再声明变量a,声明变量b并没有var关键字，按照没有var声明默认是全局变量的原则，所以变量b是全局变量

~~~

**同名变量，局部变量优先于全局变量，即就近原则**

#### 变量的内存释放

使用 **var** 创建的变量不能使用 **delete** 释放内存。

不使用 **var** 创建的变量可以使用 **delete** 释放内存

~~~javascript
<script>
    var a = 1;          //全局变量
    window.b = 2;       //全局变量
    delete a;
    delete b;
    Write(typeof a);
    Write(typeof b);
    (function func(){
        var c = 3;      //局部变量
        d = 4;          //全局变量
        delete c;
        delete d;
        Write(typeof c);
        Write(typeof d);
    })();
</script>
~~~

```
Javascript允许在函数的任意地方声明多个变量，无论在哪里声明，效果都等同于在函数顶部进行声明
```

~~~javascript
<script>
    var str = "我是妹子";
    (function func(){
        Write(str);
        var str = "我不是妹子";
        Write(str);
    })();
</script>
~~~

上面的代码等同于下面这段代码

~~~javascript
<script>
    var str = "我是妹子";
    (function func(){
        var str;    //系统自动赋值为 str = undefined
        Write(str);
        var str = "我不是妹子";
        Write(str);
    })();
</script>
~~~

### data()

 在 `Vue` 中,我们定义数据使用 `data` 

 在 `Vue` 的根节点里,它是一个对象 

```javascript
var app = new Vue({
    el: '#app',
    data: {
      msg: 'this is msg'
    })
```

 在`components` 中,它是一个函数,内部返回一个对象 

~~~javascript
export default {
  name: 'cart-buy-button',
  data () {
    return {
      testNum: 0,
      addCounter: 0,
      removeCounter: 0
    }
  }
}
~~~

 因为 vue 根节点,在整个vue单页面实例中,它有且只有一个,所以 `data` 可以设置成一个 `Object{}` 

 子组件可能会多次实例化和调用,所以为了确保子组件的数据的独立性和隔离性,需要使用 `data(){return{}}` 的方法.每次返回一个新的对象 

**Vue在实例化的时候会把 `data` 里的属性使用 `ES5` 提供的 `Object.defineProperty` 重新定义一遍,并设置其属性的 `get`和 `set**

**Vue对于表单元素的`双向绑定`和非表单元素的`单向数据流`属性** -- 双向绑定的意思是，当改变声明的变量的值时，使用该变量的同步改变，单项就是不同步改变

原因：

非`data`里声明,而是你自己定义的属性,那它就是一个普通的属性,vue不会去对待它(使用Object.defineProperty)去重新定义.所以,就无法检测到变化,不能检测到变化,就无法支持所有的数据流特性了



### router

```vue
// 字符串
router.push('home')

// 对象
router.push({ path: 'home' })

// 命名的路由
router.push({ name: 'user', params: { userId: '123' }})

// 带查询参数，变成 /register?plan=private
router.push({ path: 'register', query: { plan: 'private' }})
```

 **意：如果提供了 `path`，`params` 会被忽略，上述例子中的 `query` 并不属于这种情况。取而代之的是下面例子的做法，你需要提供路由的 `name` 或手写完整的带有参数的 `path`** 

```vue
const userId = '123'
router.push({ name: 'user', params: { userId }}) // -> /user/123
router.push({ path: `/user/${userId}` }) // -> /user/123
// 这里的 params 不生效
router.push({ path: '/user', params: { userId }}) // -> /user
```

### $options



### 导入组件

https://www.jianshu.com/p/7f3599f310a6

