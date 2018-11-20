## idea

### maven

   当误点idea 的remvoe module或者build module时idea会删除该模块，如下图

![ideamodule](D:\software\resources\note\images\ideamodule.png)



解决办法:找到maven project,重新导入对应模块的pom.xml文件即可

![idea-pom](D:\software\resources\note\images\idea-pom.png)



###spring boot找不多主启动类

报错如下:

Disconnected from the target VM, address: '127.0.0.1:65467', transport: 'socket'
错误: 找不到或无法加载主类 cn.com.enersun.oa.submit.SubmitBootstrap

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
