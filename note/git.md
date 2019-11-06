### git log

当屏幕放不下提交的日志时，按空格键翻页

git log   --pretty=oneline

![gitLog](./note\images\gitLog.png)

git log -oneline

![gitLog2](F:\workspace\idea\study\study\note\images\gitLog2.png)

git reflog





### git log翻页

![gitLog翻页](F:\workspace\idea\study\study\note\images\gitLog翻页.png)



### git版本库

![git版本库](F:\workspace\idea\study\study\note\images\git版本库.jpg)

图中我们可以看出此时 "HEAD" 实际是指向 master 分支的一个"游标"。所以图示的命令中出现 HEAD 的地方可以用 master 来替换。

图中的 objects 标识的区域为 Git 的对象库，实际位于 "**.git/objects**" 目录下，里面包含了**创建的各种对象及内容**。

当对工作区修改（或新增）的文件执行 "**git add**" 命令时，**暂存区的目录树被更新**，同时**工作区修改（或新增）的文件内容**被**写入到对象库**中的一个**新的对象**中，而该**对象的ID**被记录在**暂存区的文件索引**中。

当执行提交操作（**git commit**）时，**暂存区的目录树写到版本库（对象库）**中，master 分支会做相应的更新。即 master 指向的目录树就是提交时暂存区的目录树。

当执行 "git reset HEAD" 命令时，暂存区的目录树会被重写，被 master 分支指向的目录树所替换，但是工作区不受影响。

当执行 "git rm --cached <file>" 命令时，会直接从暂存区删除文件，工作区则不做出改变。

当执行 "git checkout ." 或者 "git checkout -- <file>" 命令时，会用暂存区全部或指定的文件替换工作区的文件。这个操作很危险，会清除工作区中未添加到暂存区的改动。

当执行 "git checkout HEAD ." 或者 "git checkout HEAD <file>" 命令时，会用 HEAD 指向的 master 分支中的全部或者部分文件替换暂存区和以及工作区中的文件。这个命令也是极具危险性的，因为不但会清除工作区中未提交的改动，也会清除暂存区中未提交的改动

### ssh-keygen

**不能有空格**

### 忽略文件

#### 1 忽略还没有纳入版本管理的文件

直接把要忽略文件添加到.gitgnore

####2 已经纳入版本管理

已经纳入版本管理的文件仅仅是编辑.gitgnore是无效的，**原因是.gitignore只能忽略那些原来没有被追踪的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。那么解决方法就是先把本地缓存删除（改变成未被追踪状态），然后再提交**

例子1

![gitgnore](D:\resources\study\note\images\gitgnore.png)

例子2 

![gitgnore2](D:\resources\study\note\images\gitgnore2.png)



#### 3 忽略加入版本管理的某一类文件

![git忽略加入版本控制的某一类文件](D:\resources\study\note\images\git忽略加入版本控制的某一类文件.png)

###不同平台换行符

https://www.jianshu.com/p/450cd21b36a4

```shell
git config --global core.autocrlf true
```



**windows平台开发如下设置**

```shell
git config --global core.autocrlf false
```



### SVN解决冲突

https://blog.csdn.net/l18848956739/article/details/83268489

![](D:\note\note\images\SVNconflict.png)

合并一般分为4种情况：

保留”我的修改”,舍弃”别人的修改”。鼠标右键点击Mine框的相应行，点击”Use this text block”。

舍弃”我的修改”,保留”别人的修改”。鼠标右键点击Theirs框的相应行，点击”Use this text block”。

同时保留”我的修改”和”别人的修改”，并将”我的修改”放在前面。鼠标右键点击Mine框的相应行，点击”Use text block from mine before theirs”。

同时保留”我的修改”和”别人的修改”，并将”别人的修改”放在前面。鼠标右键点击Mine框的相应行，点击”Use text block from theirs before mine”。

合并完成，Ctrl+S存盘，退出。

然后，在资源管理器中，选择冲突文件，鼠标右键菜单选择”Resolved”,标记冲突已解决。系统会自动删除因冲突而新建的文件。此时，就可以继续进行commit操作了



### git合并某次提交到某个分支

语法 git cherry-pick commitid

~~~shell
git checkout master
git cherry-pick ee3c72
git push
~~~

