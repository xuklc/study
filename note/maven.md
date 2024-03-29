##maven

**关于spring cloud的依赖直接使用现有demo的不要去纠结**

### 1 引入jar

有些jar没有在pom.xml显式声明引入依赖是因为在pom.xml文件中声明的依赖已经在本身的pom.xml文件中声明，所以不再需要显式声明依赖，当多个jar依赖共同的jar版本不一样就会导致版本冲突，会出现例如找不到某个类，或者空指针等错误

### 2 mvn dependency:tree

分析依赖树

### 3 idea maven

###4 scope

1.compile：默认值 他表示被依赖项目需要参与当前项目的编译，还有后续的测试，运行周期也参与其中，是一个比较强的依赖。打包的时候通常需要包含进去

2.test：依赖项目仅仅参与测试相关的工作，包括测试代码的编译和执行，不会被打包，例如：junit

3.runtime：表示被依赖项目无需参与项目的编译，不过后期的测试和运行周期需要其参与。与compile相比，跳过了编译而已。例如JDBC驱动，适用运行和测试阶段

4.provided：打包的时候可以不用包进去，别的设施会提供。事实上该依赖理论上可以参与编译，测试，运行等周期。相当于compile，但是打包阶段做了exclude操作

5.system：从参与度来说，和provided相同，不过被依赖项不会从maven仓库下载，而是从本地文件系统拿。需要添加systemPath的属性来定义路径

6 import

###5 jar包不同版本冲突

**注意:有时候显示jar冲突，或者使用lombok插件，然后编译提示找不到getter和setter方法的，重启可以解决问题**

####分析依赖树命令

```shell
mvn dependency:tree -Dverbose
```

     #### 解析 jar 包依赖----依赖传递

如上所述，在 pom.xml 中引入 zookeeper jar 包依赖，当 Maven 解析该依赖时，需要引入的 jar 包不仅仅只有 zookeeper，还会有 zookeeper 内部依赖的 jar 包，还会有 zookeeper 内部依赖的 jar 包依赖的 jar 包......，依赖关系不断传递，直至没有依赖。
例如：上述 pom.xml 引入 zookeeper 依赖，实际引入的 jar 包有

#### 默认处理策略

- 最短路径优先
  Maven 面对 D1 和 D2 时，会默认选择最短路径的那个 jar 包，即 D2。E->F->D2 比 A->B->C->D1 路径短 1。
- 最先声明优先
  如果路径一样的话，举个例子： A->B->C1, E->F->C2 ，两个依赖路径长度都是 2，那么就选择最先声明。

---------------------

### 6 profile

maven的profile和spring boot一样，都可以定义多个配置，maven可以在配置文件中定义多个profile,然后在不同的环境激活指定的profile，我们可以使用多种方式激活profile

  #### 1 actvieByDefault

```xml
<profiles> 
    <profile> 
        <id>profileTest1</id> 
        <properties> 
            <hello>world</hello> 
        </properties> 
        <activation> 
            <activeByDefault>true</activeByDefault> 
        </activation> 
    </profile> 

    <profile> 
        <id>profileTest2</id> 
        <properties> 
            <hello>andy</hello> 
        </properties> 
    </profile> 
</profiles> 
```

   我们可以在profile中的activation元素中指定激活条件，当没有指定条件，然后指定activeByDefault为true的时候就表示当没有指定其他profile为激活状态时，该profile就默认会被激活。所以当我们调用mvn package的时候上面的profileTest1将会被激活，但是当我们使用mvn package –P profileTest2的时候将激活profileTest2，而这个时候profileTest1将不会被激活

#### 2  activeProfiles

在setting.xml中可以如下激活多个profile

```xml
<activeProfiles>
    <!-- alwaysActiveProfile 指profile的id -->
    <activeProfile>profileTest1</activeProfile>
    <activeProfile>profileTest2</activeProfile>
</activeProfiles>
```

#### 3 使用 -p 参数显式指定

   在打包时可以显式指定激活哪个profile

   mvc  package  -p  profileTest1

#### 4 查看当前激活的profile

mvn help :active-profiles

### 7 常用插件

```xml
<plugin>
    <artifactId>maven-clean-plugin</artifactId>
    <version>3.0.0</version>
</plugin>
<plugin>
    <artifactId>maven-resources-plugin</artifactId>
    <version>3.0.2</version>
</plugin>
<plugin>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.7.0</version>
</plugin>
<plugin>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>2.20.1</version>
</plugin>
<plugin>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.0.2</version>
</plugin>
<plugin>
    <artifactId>maven-install-plugin</artifactId>
    <version>2.5.2</version>
</plugin>
<plugin>
    <artifactId>maven-deploy-plugin</artifactId>
    <version>2.8.2</version>
</plugin>
```

### 8 仓库

仓库可以在项目的pom.xml文件中配置或者在setting.xml文件中配置

例子:

```xml
<repositories>
        <repository>
            <id>spring-milestones</id>
            <name>Spring Milestones</name>
            <url>https://repo.spring.io/milestone</url>
            <!--  <snapshots><enabled>false</enabled></snapshots>告诉Maven不要从这个仓库下载snapshot版本的构件 -->
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>
```