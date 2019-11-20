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