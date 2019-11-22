## idea

### maven

   当误点idea 的remvoe module或者build module时idea会删除该模块，如下图





解决办法:找到maven project,重新导入对应模块的pom.xml文件即可





### spring boot找不多主启动类

报错如下:

Disconnected from the target VM, address: '127.0.0.1:65467', transport: 'socket'
错误: 找不到或无法加载主类

原因多种:

其中的一个原因:

idea 某个配置出来问题，导致maven 不能将java 源文件编译成class文件，然后jvm找不到主启动类的class文件

解决办法：使用maven的package命令打包



### beetsql



###runDashboard

找到 <component name="RunDashboard">，增加以下内容

~~~xml
<option name="configurationTypes">
    <set>
        <option value="SpringBootApplicationConfigurationType" />
    </set>
</option>

~~~



---------------------

### 3  lombok失败

在idea中，已经引入lombok依赖jar包和插件，但是还是编译报错，并且其他模块可以正常编译，有可能是**该模块某个地方编译出错**，但是idea的提示非常不友好，导致编译失败，然后提示找不到lombok生成的gettter和setter方法

解决办法:当编译失败时要认真的从头看到尾日志，检查是否有其他编译失败的信息提示，因为其他的编译失败会导致lombok也失效。

### 4 idea多线程调试

![idea多线程调试](D:\resources\study\note\images\idea多线程调试.png)

### 5 idea 配置文件过大

找到安装路径下有个属性文件，我的是在 D:\JetBrains\IntelliJ IDEA 9.0\bin 进入bin目录后找到属性文件：idea.properties 用记事本或者Editplus 将其打开，找到如下代码段：

```properties
# path to IDEA config folder. Make sure you're using forward slashes  idea.config.path=${user.home}/.IntelliJIdea90/config   
# path to IDEA system folder. Make sure you're using forward slashes  #idea.system.path=${user.home}/.IntelliJIdea90/system   # path to user installed plugins #folder. Make sure you're using forward slashes  idea.plugins.path=${user.home}/.IntelliJIdea90/config/plugins 
```

发现其中包含3个路径 idea.config.path和idea.system.path和idea.plugins.path   这个就是设置了文件的存放路径，那么我们将 ${user.home} 替换为我们自定义的路径就好了，替换 如：D:/JetBrains ，注意“/”的方向。我的修改后的如下：

```properties
# path to IDEA config folder. Make sure you're using forward slashes  idea.config.path=D:/JetBrains/.IntelliJIdea90/config   
# path to IDEA system folder. Make sure you're using forward slashes  #idea.system.path=D:/JetBrains/.IntelliJIdea90/system   
# path to user installed plugins folder. Make sure you're using forward slashes  idea.plugins.path=D:/JetBrains/.IntelliJIdea90/config/plugins 
```



### 快捷键

Ctrl+Alt+B　　跳转到方法实现处

Ctrl+Shift+左箭头　　上一个浏览的地方

Ctrl+Shift+右箭头　　下一个浏览的地方

Ctrl+Shift+E　　最近更改的文件

Shift+Click(鼠标左键单机)　　可以关闭文件

**Ctrl+Q　　显示注释文档 **

 F2 或 Shift+F2　　高亮错误或警告快速定位 

 Ctrl＋Alt+Shift＋N　　快速搜索函数 

ctrl+shift+alt+F7 搜索class文件被调用的地方

### 热部署

https://blog.csdn.net/qq_16148137/article/details/99694566