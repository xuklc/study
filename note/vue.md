

### vue官网

https://cn.vuejs.org/v2/guide/components-props.html#传入一个对象的所有属性

https://cn.vuejs.org/v2/guide/components-registration.html

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

https://cn.vuejs.org/v2/api/#选项-生命周期钩子

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

 **类型**：`Object | Function` 

 **限制**：组件的定义只接受 `function` 

 Vue 实例的数据对象。Vue 将会递归将 data 的属性转换为 getter/setter，从而让 data 的属性能够响应数据变化。**对象必须是纯粹的对象 (含有零个或多个的 key/value 对)**：浏览器 API 创建的原生对象，原型上的属性会被忽略。大概来说，data 应该只能是数据 - 不推荐观察拥有状态行为的对象 



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

路由配置

1 npm install vue-router --save-dev

2 配置

1. 在src里新建router/index.js
2. 在src下面新建main.js 和 App.vue
3. 在router/index.js 配置路由路径和对应的组件

3 写路由

~~~vue
import Vue from 'vue';
import VueRouter from 'vue-router';

// 使用插件, 用use
Vue.use(VueRouter); // 调用一个这个方法

// 路由的数组
const routes = [
    {
        // 访问路径
        path: '/film',
        component: () => import('@/views/film'),
    },
    {
        // 访问路径
        path: '/cinema',
        component: () => import('@/views/cinema'),
    },
    {
        // 访问路径
        path: '/pintuan',
        component: () => import('@/views/pintuan'),
    },
    {
        // 访问路径
        path: '/my',
        component: () => import('@/views/my'),
		children:[
			...
			name:'queryName'
			...
		]
    },
];

const router = new VueRouter({
    routes
});
export default router;
~~~

**注意:this.$router.push({name:'queryName',query:{paraId:1,para2:'1234456'}}),这个里的name属性指children里的name属性，例如上面的queryName**

个人例子:

~~~vue
this.$router.push({
        name: "router33",
        query: {
          flag: "router",
          flagId: 23
        }
      });

...
{
    path: "/router1",
    name: "router1",
    component: Layout,
    children: [
      {
        path: "router2",
        component: () => import("@/app/views/router/routerTest"),
        name: "router2",
        meta: { title: "router2", icon: "dashboard", noCache: true },
        children:[
          {
            path: "router3",
            component:()=> import ("@/app/views/router/routerTest"),
            name:"router33"
          }
        ]
      }
}
...
~~~



由于动态路由也是传递params的，所以在 this.$router.push() 方法中**path不能和params一起使用**，否则params将无效。**需要用name来指定页面**

```vue
// 字符串
this.$router.push('home')

// 对象
this.$router.push({ path: 'home' })

// 命名的路由
this.$router.push({ name: 'user', params: { userId: '123' }})

// 带查询参数，变成 /register?plan=private
this.$router.push({ path: 'register', query: { plan: 'private' }})
this.$router.push();
```

 **意：如果提供了 `path`，`params` 会被忽略，上述例子中的 `query` 并不属于这种情况。取而代之的是下面例子的做法，你需要提供路由的 `name` 或手写完整的带有参数的 `path`** 

```vue
const userId = '123'
router.push({ name: 'user', params: { userId }}) // -> /user/123
router.push({ path: `/user/${userId}` }) // -> /user/123
// 这里的 params 不生效
router.push({ path: '/user', params: { userId }}) // -> /user
```

#### 目标页面接收参数

1 在目标页面通过this.$route.params获取参数

```vue
<p>提示：{{this.$route.params.alert}}</p>
```

2 在目标页面通过this.$route.query 获取参数

```vue
//传值
this.$router.push({path:"/menLink",query:{alert:"页面跳转成功"}})

//用query获取值
<p>提示：{{this.$route.query.alert}}</p>
```

**两种方式的区别是query传参的参数会带在url后边展示在地址栏，params传参的参数不会展示到地址栏。需要注意的是接收参数的时候是route而不是router。两种方式一一对应，名字不能混用**

### $options

- **类型**：`Object`

用于当前 Vue 实例的初始化选项。需要在选项中包含自定义属性时会有用处

### 导入组件

https://www.jianshu.com/p/7f3599f310a6

https://cn.vuejs.org/v2/guide/components-registration.html

### this

~~~html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
    <script src="https://unpkg.com/vue@2.5.9/dist/vue.js"></script>
</head>
<div id="app" style="width: 100%;height: auto;font-size:20px;">
    <p id="id1"></p>
    <p id="id2"></p>
</div>
<script type="text/javascript">
    var message = "Hello!";
    var app = new Vue({
        el:"#app",
        data:{
            message: "你好！"
        },
        created: function() {
          this.showMessage1();    //this 1
          this.showMessage2();   //this 2
        },
        methods:{
            showMessage1:function(){
                setTimeout(function() {
                   document.getElementById("id1").innerText = this.message;  //this 3
                }, 10)
            },
            showMessage2:function() {
                setTimeout(() => {
                   document.getElementById("id2").innerText = this.message;  //this 4
                }, 10)
            }
        }
    });
</script>
</html>
~~~

第一个输出英文"Hello!”，第二个输出中文“你好！”。这说明了showMessage1()里的this指的是window，而showMessage2()里的this指的是vue实例。
 ※  对于普通函数（包括匿名函数），this指的是直接的调用者，在非严格模式下，如果没有直接调用者，this指的是window。showMessage1()里setTimeout使用了匿名函数，this指向
 window。
 ※  箭头函数是没有自己的this，在它内部使用的this是由它定义的宿主对象决定。showMessage2()里定义的箭头函数宿主对象为vue实例，所以它里面使用的this指向vue实例。
 注：
 【普通函数的this】
 普通函数的this是由动态作用域决定，它总指向于它的直接调用者。具体可以分为以下四项：
 this总是指向它的直接调用者， 例如 obj.func() ,那么func()里的this指的是obj。
 在默认情况(**非严格模式**,未使用 '**use strict**')，如果函数没有直接调用者，this为window
 在严格模式下,如果函数没有直接调者，this为undefined
 使用call,apply,bind绑定的，this指的是绑定的对象
 绑定vue实例到this的方法
 为了避免this指向出现歧义，有两种方法绑定this。
 使用bind

~~~vue
//showMessage1()可以改为：
showMessage1:function(){
    setTimeout(function() {
       document.getElementById("id1").innerText = this.message;  //this 3
    }.bind(this), 10)
}
~~~

对setTimeout()里的匿名函数使用bind()绑定到vue实例的this。这样在匿名函数内的this也为vue实例。
 把vue实例的this赋值给另一个变量再使用
 showMessage1()也可以改为

~~~vue
showMessage1:function(){
    var self = this;
    setTimeout(function() {
       document.getElementById("id1").innerText = self.message;  //改为self
    }.bind(this), 10
}
~~~

### $refs

 **类型**：`Object` 

 一个对象，持有注册过 [`ref` 特性](https://cn.vuejs.org/v2/api/#ref) 的所有 DOM 元素和组件实例  

ref 被用来给DOM元素或子组件注册引用信息。引用信息会根据父组件的 $refs 对象进行注册。如果在普通的DOM元素上使用，引用信息就是元素; 如果用在子组件上，引用信息就是组件实例

**注意：只要想要在Vue中直接操作DOM元素，就必须用ref属性进行注册**

### dom操作

https://cloud.tencent.com/developer/article/1492991

https://www.jb51.net/article/136596.htm

## [vue里操作DOM](https://www.cnblogs.com/ssszjh/p/9716398.html)

一般来说你要在vue里操作DOM，要先在标签里加上ref=“”，如下：

```vue
<h2 ref="s" @click="sss">Essential Links</h2>
```

然后在点击的事件sss写下你想要的效果代码：（注意的是上面的ref的s，要写在下面this.$refs，不要忘了）

```vue
methods: {
        sss() {
            this.$refs.s.style.color = "blue";
			// 第二种写法
			this.$refs["form"].validate(valid => {
				
			});
        }

    }
```

如果你想要弄更多的效果，特效就要引入Jquery

1.npm install jquery --save

2.在项目根目录下的build目录下找到webpack.base.conf.js文件，在开头使用以下代码引入webpack，因为该文件默认没有引用,如下：

```vue
var webpack = require('webpack')
```

3.还是该文件,在module.exports模块里写下这一段

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```vue
plugins: [
        new webpack.ProvidePlugin({
            $: "jquery",
            jQuery: "jquery",
            jquery: "jquery",
            "window.jQuery": "jquery"
        })
    ],
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

4.main.js里导入jQuery

```vue
import 'jquery'
```

5.若有.eslintrc.js文件，则在module.exports中，为env添加一个键值对 `jquery: true` 就可以了

若无这个文件，则不用管

这个时候我们可以来测试了

在created的生命周期里写下：console.log($('选择器'));

浏览器显示：

![img](https://img2018.cnblogs.com/blog/1472459/201809/1472459-20180927234935323-1820797913.jpg)

就成功了

不过值得注意的是：

你要使用jQuery，要在vue渲染完成后，才使用

就是在mounted周期里用，如：

```vue
 mounted() {
        $(".hello").css("color", "red");
        $(".aaa").css("color", "red");
    },
```



### 父子组件

**组件需要注册才能使用**

父子组件的区别是**被引入的就是子组件**，**子组件需要用到父组件的数据，不需要引入父组件，直接按照语法传参即可**

父组件需要用到子组件的数据，需要使用import引入子组件，并注册在compoment下(即向父组件注册子组件)，例子

#### 父组件

~~~vue
<template>
...
</template>
import Child1 from "@/portal/components/Child1";
import { Child2 } from "@/portal/utils/Child2";
import { Child3 } from "@/portal/components/Child3";
import Child4 from "./edit/Child4";
import Child5 from "./edit/Child5";
export default {
  name: "parent", //多语言的名称前缀为name的值
  components: {//子组件
    Child1,
    Child2,
    Child3,
    Child4,
	Child5
  },
...
}
~~~

#### 子组件

~~~vue
<template>
...
</template>
export default {
  name: "Child4",
  components: {},
  props: {
    addFlag: {
      type: Boolean,
      default: false
    },
    params: {
      type: Object,
      default: null
    }
...
}
~~~

#### 父子组件传参

https://www.jianshu.com/p/09a5b0843926

https://blog.csdn.net/weixin_44849078/article/details/89227848

#### 子传父

##### 例子1

子组件

~~~vue
<template>
	<button v-on:click="updateParentValue">点击传值</button>
</template>

<script>
export default {
  data () {
    return {
    	
    },
    methods: {
    	updateParentValue () {
    		this.$emit('updateParentValue', 'abcde');
    	}
    }
  }
}
</script>

~~~

父组件

~~~vue
<template>
	<div></div>
</template>

<script>
export default {
  data () {
    return {
    	
    },
    methods: {
    	updateParentValue (childrenValue) {
    		console.log(childrenValue); // 'abcde'
    	}
    }
  }
}
</script>
~~~

##### 例子2

子组件

在子组件通过点击事件触发子组件向父组件传参

~~~vue
...
<script>
    // 元素的点击事件
    method(){
        ...
        eleClilkFunction(){
            let childData ={
                childDataList=this.childData,
                opType:"del"
            }
            this.$emit('childData', childData);
    	}
        ...
	}

</script>

...
~~~

父组件

~~~vue
<template>
...
// 引入子组件并注册,parentData同时可以向子组件传值
<child-component :parentData="parentData" @childData="childData"></child-component>
...
</template>
<script>
	...
    method(){
        // params就是子组件传给父组件的值,childData()函数在子组件触发事件触发子组件向父组件传值到
        // 这个函数由子组件的事件触发
        childData(params){
            
            if("del"===params.opType){
               let childDataList=params.childDataList;
                ... 业务逻辑
               }
        }
    }
    ...
    
</script>
~~~



### if

参数类型可以不是boolean

debugger

### 调试

https://cn.vuejs.org/v2/cookbook/debugging-in-vscode.html#在浏览器中展示源代码

### json

1、将对象转换为JSON格式字符串

```vue
JSON.stringify(object)
```

2、将JSON字符串转换为对象

```vue
JSON.parse(jsonString);
```



### export default

https://www.cnblogs.com/win-and-coffee/p/10186649.html

###  observer 

https://segmentfault.com/a/1190000008377887?utm_source=tag-newest

### 自定义组件

:tableHeader="tableHeader"

:xxx表示属性或者函数

### 国际化

https://blog.csdn.net/Dream_xun/article/details/82743762

https://q.cnblogs.com/q/108194

###  <el-select

~~~vue
<el-form ref="form" :model="form" style="width:300px;margin:0 auto;">
      <el-form-item label="名字">
        <el-select @change="selectGet" v-model="form.region" placeholder="请选择名字">
          <el-option 
            v-for="item in selectList" 
            :key="item.id"
            :label="item.name"
            :value="item.id"
          ></el-option>
        </el-select>
      </el-form-item>
    </el-form>
~~~

~~~vue
 data() {
    return {
      selectList:[
          {id:0,name:'张三'},
          {id:1,name:'里三'},
          {id:2,name:'李四'}
        ],
      form: {
        region: ""
      }
    };
  }
~~~

~~~vue
selectGet(vId){
      let obj = {};
      obj = this.selectList.find((item)=>{//这里的selectList就是上面遍历的数据源
          return item.id === vId;//筛选出匹配数据
      });
      console.log(obj.name);//我这边的name就是对应label的
      console.log(obj.id);
    }
~~~

### form表单

https://blog.csdn.net/qq_33616027/article/details/90290239

~~~vue
<template>
    <div>
        <el-form :model="dengmiQueryForm" ref="dengmiQueryForm" label-width="100px" class="demo-ruleForm" size="mini">
            <el-row>
                <el-col span="8">
                    <el-form-item label="谜面">
                        <el-input v-model="dengmiQueryForm.mimian"></el-input>
                    </el-form-item>
                </el-col>
                <el-col span="8">
                    <el-form-item label="谜目">
                        <el-input v-model="dengmiQueryForm.mimu"></el-input>
                    </el-form-item>
                </el-col>
                <el-col span="8">
                    <el-form-item label="谜格">
                        <el-input v-model="dengmiQueryForm.mige"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row>
                <el-col span="8">
                    <el-form-item label="谜底">
                        <el-input v-model="dengmiQueryForm.midi"></el-input>
                    </el-form-item>
                </el-col>
                <el-col span="8">
                    <el-form-item label="作者">
                        <el-input v-model="dengmiQueryForm.zuozhe"></el-input>
                    </el-form-item>
                </el-col>
                <el-col span="8">
                    <el-form-item label="谜底字数">
                        <el-input v-model="dengmiQueryForm.midiLength"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row>
                <el-col>
                    <el-button type="primary" @click="submitForm" icon="el-icon-search">查询</el-button>
                    <el-button type="warning" @click="resetForm" icon="el-icon-search" plain>重置</el-button>
                </el-col>
            </el-row>
        </el-form>
    </div>
</template>

<script>
    export default {
        name: "dengmiQuery",
        data() {
            return {
                dengmiQueryForm: {
                    mimian:'',
                    mimu:'',
                    mige:'',
                    midi:'',
                    zuozhe:'',
                    midiLength:''
                }
            };
        },
        methods: {
            submitForm(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        alert('submit!');
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                });
            },
            resetForm(formName) {
                this.$refs[formName].resetFields();
            }
        }
    }
</script>

<style scoped>
   
</style>
~~~

###  

### 方法和属性调用

方法和属性调用需要this,不能和java那样直接调用,本文件内的也不可以

### 放大镜

~~~vue
<el-input
                  v-model="form.propertry">
                  <i slot="suffix" class="el-icon-search"></i>
</el-input>
~~~

### 常用方法

**push()** 方法可向数组的末尾添加一个或多个元素，并返回新的长度。

**pop()** 方法用于删除并返回数组的最后一个元素。

**shift()** 方法用于把数组的第一个元素从其中删除，并返回第一个元素的值。

**unshift()** 方法可向数组的开头添加一个或更多元素，并返回新的长度。

**splice()** 方法向/从数组中添加/删除项目，然后返回被删除的项目。

**sort()** 方法用于对数组的元素进行排序。

**reverse()** 方法用于颠倒数组中元素的顺序。

**filter()** 方法创建一个新的数组，新数组中的元素是通过检查指定数组中符合条件的所有元素。

**concat()** 方法用于连接两个或多个数组。

**slice()** 方法可从已有的数组中返回选定的元素。

**split()** 方法用于把一个字符串分割成字符串数组

#### 实现表格增删行效果

1 增行

~~~vue
addRow(tableData){
	let emptyRow={"partCode":'',"partLocalDesc":'',"unit":'',"applyQty":'',"balance":'',"remark":'',
        __id: Math.floor(Math.random() * Date.now()),
      };
	tableData.push(emptyRow);
}
~~~

2 删行

方法1 **在<el-table>标签的环境**下通过scope.$index把下标传到行数中

~~~vue
<template>
...
	<el-table>
        ...
        <el-table-column>
            <template>
                // tableData是定义在data(){}里的数组
                <el-button @click="delCurrentRow(scope.$index,tableData)"></el-button>
			</template>
    	</el-table-column>
        ...
    </el-table>
...
</template>

delCurrentRow(index,tableData{
	tableData.splice(index,1);
}
~~~

方法2  直接传scope

~~~vue
<template>
...
	<el-table>
        ...
        <el-table-column>
            <template>
                // tableData是定义在data(){}里的数组
                <el-button @click="delCurrentRow(scope,tableData)"></el-button>
			</template>
    	</el-table-column>
        ...
    </el-table>
...
</template>

delRow(index,tableData{
	tableData.splice(index,1);
}
~~~

方法3 直接操作tableData数组

~~~vue
<template>
...
	<el-table>
        ...
        <el-table-column>
            <template>
                // tableData是定义在data(){}里的数组
                <el-button @click="delCurrentRow"></el-button>
			</template>
    	</el-table-column>
        ...
    </el-table>
...
</template>

delCurrentRow(index,tableData{
// multipleSelection在data(){}定义
	let ids= this.multipleSelection.map((item)=>{
	// addRow函数定义了_id属性
		return item._id;
	});
	let newTableData=this.tableData.filter((item)=>{
		return ids.includes(item._id)==false;
	});
	this.tableData=newTableData;
}
~~~

### props vs data

1 props和data的区别是props定义的属性只有接收父组件修改字段的值，data可以在vue实例里操作修改，即在vue文件中

2 当前组件作为**弹框**引入时，当弹框关闭做props里定义的属性就回复默认值

子组件中的data数据，不是通过父组件传递的是子组件私有的，是可读可写的。

子组件中的所有 props中的数据，都是通过父组件传递给子组件的，是只读的

### watch

**Vue.js 有一个方法 watch，它可以用来监测Vue实例上的数据变动**

~~~vue
<template>
  <div>
    <el-input v-model="demo"></el-input>
    {{value}}
  </div>
</template>
<script>
  export default {
    name: 'index',
    props:{
      prop1:{
          type:Boolean,
          default:function(){
              return false;
          }
      },
      prop2:{
          type:Object,
          default:function(){
              return null;
          }
      }
    },
    data() {
      return {
        demo: '',
        value: ''
      };
    },
    watch: {
       // 监听data函数李的变量
      demo(val) {
        this.value = this.demo;
      },
        // 可以监听props里定义的变量
      prop1:function(){
          
      }
       
    }
  };
</script>
~~~

### v-model

在<el-form>中:model变量绑定了一个在data()的变量，<el-form>标签的子标签的v-model指令绑定的属性要在:model绑定的变量中定义

例子:

~~~vue
<templte>
	<el-form :model="formData">
        <el-form-item>
            <el-input v-model="formData.userName" />
        </el-form-item>
        <el-form-item>
			<el-input v-model="formData.userCode" />
        </el-form-item>
    </el-form>
</templte>
<script>
    ...
	data(){
       return{
           formData:{
               userCode:null
               //没有定义userName，则<el-input v-model="formData.userName" />无法输入
           }
       } 
    }
    ...
</script>
~~~

### mounted

html加载完成后执行。执行顺序：子组件-父组件

### ref

https://blog.csdn.net/qq_15509267/article/details/88286695

1 本页面获取dom元素

2 获取子组件的data

3 调用子组件的方法

- **类型**：`Object`

- **只读**

- **详细**：

  一个对象，持有注册过 [`ref` 特性](https://cn.vuejs.org/v2/api/#ref) 的所有 DOM 元素和组件实例

  用法1 

  ~~~vue
  <base-input ref="usernameInput"></base-input>
  ~~~

  现在在你已经定义了这个 `ref` 的组件里，你可以使用：

  ```vue
  this.$refs.usernameInput
  ```

用法2

~~~vue
<input ref="input">
~~~

甚至可以通过其父级组件定义方法：

~~~vue
methods: {
  // 用来从父级组件聚焦输入框
  focus: function () {
    this.$refs.input.focus()
  }
}
~~~

**`$refs` 只会在组件渲染完成之后生效**

用法3

~~~vue
<template>
...
  <el-form  ref="form">
    
  </el-form>
...
</template>
<script>
	data(){
        return {
          form:"formObj"  
        };
    },
    methods:{
        clickQuery(){
            //  返回一个form对象
            let formObj=this.$ref[this.form];
            // 或者可以这么写
            let formObj2 = this.$ref["formObj"];
        }
    }
</script>

~~~

**ref和v-for在一起的情况**

**ref只能调用子组件的方法和data里的属性，不能调用子组件的子组件的方法和data属性，想要调子组件的子组件的方法和data属性,需要在当前第一个子组件中定义ref属性的值，然后在第一个子组件里调用第二个子组件的方法，然后在父组件中调用封装了第二个子组件方法的方法**

### Vuex



### vue cli3

https://cli.vuejs.org/zh/

### vue的基本语法

3 关闭

5 和props对象统计的model对象

~~~vue
model: {
        prop: "showSelectPop",
        event: "change",
    },
~~~



~~~vue
<template>
// html
</template>

<script>
import xxx from "path1";
import xxxx from "path2";
import xxxxx from "path3";
// 注意:建议export default后面的大括号加一个空格
export default {
    //  导出默认模块的名称
    name:"",
    components:{
        
    },
    //data是一个函数
    data(){
        
    },
    // props是对象
    props:{
        
    },
    beforeCreate(){
        
    },
    create(){
        
    },
    mounted(){
        
    },
    beforeUpdate(){
        
    },
    updated(){
        
    },
    beforeDestroy(){
        
    },
    destroyed(){
        
    },
    beforeMount(){
        
    },
    methods:{
        
    }
}
</script>

<style>
// css写在这里
</style>
~~~

### async/await

async/await用来发布异步请求，从服务端获取数据

promise是异步编程的一种解决方案，比传统的回到和事件更好用，promise是一个容器，里面保存某个未来才会有结果的事件，从语法的角度是一个对象

例子

~~~vue
<template>
</template>
<script>
	...
    methods:{
        async syncFun(){
            console.log("async eg");
            let awaitResult = await  awaitFun();
            ...
        }
        async syncFun2(){
            try{
                console.log("async eg2");
           		let awaitResult2 = await  awaitFun();
            }catch(e){
                ...
            }
        }
        
    }
    ...
</script>
~~~



### model vs props

https://blog.csdn.net/Qin_Shuo/article/details/82693919



### import

**import在编译解析阶段就查找对应的路径，如果写的路径不存在就编译报错，并且没有提示，只是说编译报错**



### 插槽

#### 1 匿名插槽

例子:

父组件

~~~vue
<template>
    <div>
        <h3>我是一个父组件</h3>
        <!--显示子组件，在child组件写入一个HTML模板，该模板会替换子组件的slot-->
        <child>
            <div>
                有位非常漂亮的女同事，有天起晚了没有时间化妆便急忙冲到公司。结果那天她被记旷工了……
            </div>
        </child>
    </div>
</template>
~~~

子组件

~~~vue
<template>
    <div>
        <h5>我是子组件</h5>
        <slot></slot>
    </div>
</template>
~~~

渲染结果

~~~vue
 <div>
        <h3>我是一个父组件</h3>
        <div>
            <h5>我是子组件</h5>
            <div>
                有位非常漂亮的女同事，有天起晚了没有时间化妆便急忙冲到公司。结果那天她被记旷工了……
            </div>
        </div>
 </div>
~~~

#### 2 具名插槽

例子:

父组件

~~~vue
<template>
    <div>
        <h3>我是一个父组件</h3>
        <!--显示子组件-->
        <child>
            <div slot="zhang">老张</div>
            <div slot="wang">老王</div>
            <div>老李</div>
        </child>
    </div>
</template>
~~~

子组件

~~~vue
<template>
    <div>
        <h5>我是子组件</h5>
        <!--具名插槽-->
        <slot name="zhang"></slot>
        <!--具名插槽-->  
        <slot name="wang"></slot>
        <!--匿名插槽-->
        <slot></slot>
    </div>
</template>
~~~

最终渲染的结果

~~~vue
<div>
    <h3>我是一个父组件</h3>
    <!--显示子组件-->
    <div>
        <h5>我是子组件</h5>
        <div>老张</div>
        <div>老王</div>
        <div>老李</div>
    </div>
</div>
~~~

#### 3作用域插槽

作用域插槽需要绑定数据



### v-on和$event

[https://cn.vuejs.org/v2/guide/events.html#%E5%86%85%E8%81%94%E5%A4%84%E7%90%86%E5%99%A8%E4%B8%AD%E7%9A%84%E6%96%B9%E6%B3%95](https://cn.vuejs.org/v2/guide/events.html#内联处理器中的方法)

#### 事件修饰符

Vue.js 为 `v-on` 提供了**事件修饰符**。之前提过，修饰符是由点开头的指令后缀来表示的

- `.stop`
- `.prevent`
- `.capture`
- `.self`
- `.once`
- `.passive`

~~~vue
<!-- 阻止单击事件继续传播 -->
<a v-on:click.stop="doThis"></a>

<!-- 提交事件不再重载页面 -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修饰符可以串联 -->
<a v-on:click.stop.prevent="doThat"></a>

<!-- 只有修饰符 -->
<form v-on:submit.prevent></form>

<!-- 添加事件监听器时使用事件捕获模式 -->
<!-- 即内部元素触发的事件先在此处理，然后才交由内部元素进行处理 -->
<div v-on:click.capture="doThis">...</div>

<!-- 只当在 event.target 是当前元素自身时触发处理函数 -->
<!-- 即事件不是从内部元素触发的 -->
<div v-on:click.self="doThat">...</div>
~~~

#### 按键码

为了在必要的情况下支持旧浏览器，Vue 提供了绝大多数常用的按键码的别名

- `.enter`
- `.tab`
- `.delete` (捕获“删除”和“退格”键)
- `.esc`
- `.space`
- `.up`
- `.down`
- `.left`
- `.right`

例子:

~~~vue
<input v-on:keyup.enter="submit">
~~~

