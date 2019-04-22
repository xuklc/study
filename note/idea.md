## idea

### maven

   当误点idea 的remvoe module或者build module时idea会删除该模块，如下图





解决办法:找到maven project,重新导入对应模块的pom.xml文件即可





###spring boot找不多主启动类

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