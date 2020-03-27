### icon

~~~html
// slot属性必填,否则icon属性不生效
<el-button icon="el-icon-search" slot="append"></el-button>
~~~

### <el-card 



###  <el-dialog

https://blog.csdn.net/mr_javascript/article/details/80888681

弹框出现遮罩层的解决办法:

 :modal="false"属性取消遮罩层或者添加append-to-body属性 

###  slot-scope="scope" 



### <el-table

**内置scope对象,score对象有row属性，row对象通过$index来获取当前表格当前行的下标**

**注意,scope对象要在<el-table标签下传参才有效**

例子

~~~vue
<template>
	<el-form>
    	<el-form-item>
            <el-table>
                ...
                <el-table-column>
					<template>
                        <!--scope对象只有在<el-table>环境下才有效  -->
                        <el-button @click="deleteRow(scope.$index)"></el-button>
					</template>
    			</el-table-column>
				<el-table-column prop="xxx" :label="列名">
                    <template>
						//属性绑定是scope.row.fieldName来进行属性绑定
						<el-input v-model="scope.row.fieldName" />
                    </template>
				</el-table-column>
                ...
    		</el-table>
    	</el-form-item>
	</el-form>
</template>
<script>
    export default {
        ...
        data(){
        	return {
        		...
    		}
    	},
        method:{
            // index是deleteRow函数的形参
            deleteRow(index){
                ...
            }
        }
    }
</script>
~~~

### :的作用

element ui组件:就会把属性当做一个变量来处理

例子:

~~~vue
...
// 这里直接显示$t('messge')
<el-table label="$t('messge')"></el-table>
// :label相当于一个变量，可以读取messge变量
<el-table :label="$t('messge')"></el-table>
...

~~~

### div/img的宽度自适应

设置width的值是百分比，div的高度作为父级元素，高度由子元素撑开



### <el-select

在element-ui中，需求可输入下拉。

设置filterable为true，设置为可搜索，但是当鼠标离开的时候输入框会被置空。

因为没有找到匹配项。可通过blur事件重设当前值

~~~vue
<el-select v-model="value" filterable placeholder="请选择" @blur="selectBlur"></el-select>

data() {
	return {
		value: ''
	}
},
methods: {
	searchBlur(e) {
		this.value = e.target.value
	}
}
~~~

