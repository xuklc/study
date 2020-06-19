**当已经设定了width和height值的时候，padding和border不被包含在你定义的width和height之内，也就是说，你定义的width只负责content区域的宽度，如果想得到整个盒子宽度，需要再加上padding和border的厚度**

![](css.assets/%E5%85%83%E7%B4%A0%E8%BE%B9%E6%A1%86.png)

### margin-bottom

下外边距

| 值       | 描述                                                         |
| :------- | :----------------------------------------------------------- |
| auto     | 浏览器计算下外边距。                                         |
| *length* | 规定以具体单位计的下外边距值，比如像素、厘米等。默认值是 0px。 |
| *%*      | 规定基于父元素的宽度的百分比的下外边距。                     |
| inherit  | 规定应该从父元素继承下外边距。                               |

### elementUI

#### 分栏间隔

 Row 组件 提供 `gutter` 属性来指定每一栏之间的间隔，默认间隔为 0 

#### offset

 通过制定 col 组件的 `offset` 属性可以指定分栏偏移的栏数 

### &

 跟this的意思一样 

~~~css
.el-row {
    margin-bottom: 20px;
    &:last-child {
      margin-bottom: 0;
    }
  }
等同于
.el-row {
    margin-bottom: 20px;
    .el-row:last-child {
      margin-bottom: 0;
    }
  }
~~~

###  last-child 

 选择器用来匹配父元素中最后一个子元素 

### 居中



https://blog.csdn.net/mars2009/article/details/79683924

### css3计算高度/宽度

1 px

2 百分比

3、Viewport
  viewport：可视窗口，也就是浏览器。
  vw Viewport宽度， 1vw 等于viewport宽度的1%
  vh Viewport高度， 1vh 等于viewport高的的1%

4 Calc

使用“+”、“-”、“*” 和 “/”四则运算；
    >可以使用百分比、px、em、rem等单位；
    >可以混合使用各种单位进行计算；
    >表达式中有“+”和“-”时，其前后必须要有空格，如"widht: calc(12%+5em)"这种没有空格的写法是错误的；

**表达式中有“*”和“/”时，其前后可以没有空格，但建议留有空格**

例如 ：设置div元素的高度为当前窗口高度-100px
   div{
    height: calc(100vh - 100px);   
  }

### display

display:none;--此元素不会被显示

#### 元素选择器、

**多个元素选择器用逗号隔开**

#### *

通配选择器，该选择器可以匹配任何元素，就像是一个通配符

#### ~

~~~css
p~ul{
　　background:#ff0000;
}
// 为所有相同的父元素中位于 p 元素之后的所有 ul 元素设置背景
~~~

### box-sizing

https://blog.csdn.net/qq_26780317/article/details/80736514

未加入box-sizing前的模型

![](css.assets/%E5%85%83%E7%B4%A0%E8%BE%B9%E6%A1%86.png)

加入box-sizing

![](css.assets/box-sizing.png)

### Outline

一个框的outline是一个看起来像是边界但又不属于框模型的东西。它的行为和边界差不多，但是并不改变框的尺寸（更准确的说，轮廓被勾画于在框边界之外，外边距区域之内）



### {*rule !important}

使用!important的css定义是拥有最高的优先级的

### float

~~~css
.clearfix:after {
    visibility: hidden;
    display: block;
    font-size: 0;
    content: " ";
    clear: both;
    height: 0;
}
~~~

### clear

**对于CSS的清除浮动(clear)，一定要牢记：这个规则只能影响使用清除的元素本身，不能影响其他元素**

https://blog.csdn.net/qq_36595013/article/details/81810219



### height:100% vs height:inherit

https://www.cnblogs.com/qianxunpu/p/7991429.html

**百分比的高度在设定时需要根据这个元素的父元素容器的高度**。所以，如果你把一个`div`的高度设定为`height: 50%;`，而它的父元素的高度是100px，那么，这个div的高度应该是50px



**那么为什么height:100%不起作用？**

**当设计一个页面时，你在里面放置了一个`div`元素，你希望它占满整个窗口高度，最自然的做法，你会给这个`div`添加`height: 100%;`的css属性。然而，如果你要是设置宽度为`width: 100%;`，那这个元素的宽度会立刻扩展到窗口的整个横向宽度。高度也会这样吗？ ----不会**

 

**你需要理解浏览器是如何计算高度和宽度的。Web浏览器在计算有效宽度时会考虑浏览器窗口的打开宽度。如果你不给宽度设定任何缺省值，那浏览器会自动将页面内容平铺填满整个横向宽度。**

**但是高度的计算方式完全不一样。事实上，浏览器根本就不计算内容的高度，除非内容超出了视窗范围(**导致[滚动条](http://www.webhek.com/scrollbar)出现**)。或者你给整个页面设置一个绝对高度。否则，浏览器就会简单的让内容往下堆砌，页面的高度根本就无需考虑。**

**因为页面并没有缺省的高度值，所以，当你让一个元素的高度设定为百分比高度时，无法根据获取父元素的高度，也就无法计算自己的高度。换句话说，父元素的高度只是一个缺省值：`height: auto;`。当你要求浏览器根据这样一个缺省值来计算百分比高度时，只能得到`undefined`的结果。也就是一个null值，浏览器不会对这个值有任何的反应。**

 

**如果想让一个元素的百分比高度`height: 100%;`起作用，你需要给这个元素的所有父元素的高度设定一个有效值。换句话说，你需要这样做：**

~~~html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
       html,body{
         height:100%;
        }
        .container{
            height:100%;
            background-color: #669900;

        }
       .bar{
           height:50%;
           background-color: #eb7350;
       }
    </style>
</head>
<body>
<div class="container">
    <div class="bar"></div>
</div>

</body>
</html>
~~~

现在你给了这个div的高度为100%,它有两个父元素<body>和<html>。为了让你的div的百分比高度能起作用，你必须设定<body>和<html>的高度。

上面的例子会出现滚动条，那是因为，body有默认的**margin** 和**padding**值，设置一下就不会有滚动条了：

~~~css
 body{
            margin:0;
            padding:0;
        }
~~~

**在使用`height: 100%;`时需要注意的一些事项**

1、Margins 和 padding 会让你的页面出现滚动条，也许这是你不希望的。

2、如果你的元素实际高度大于你设定的百分比高度，那元素的高度会自动扩展。