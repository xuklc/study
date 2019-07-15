### SSH免密登录

设置完SSH免密登录之后可以不用输密码，因为服务器已经有本地电脑的公钥，只有本地私钥才能解密，所以不用密码登录也是安全的。

**ssh-keygen -t rsa生成的公私钥文件和known_hosts不能移动，因为SSH密码登录时要读取私钥文件，才能登录**

### 常用命令

#### ssh-keygen

~~~shell
ssh-keygen -t -rsa
~~~

### rz和sz

yum install -y lrzsz

不存在sz，rz命令的话，通过这个安装下yum install -y lrzsz



### sudo

sudo是一个程序，普通用户可以使用它以超级用户或其他用户的身份执行命令，sudo用户的访问权限是由 /etc/sudoers文件控制

###  端口占用

netstat -aon|findstr 8080

结束进程

输入tasklist|findstr 2524命令，其中2524加英文双引号，按回车键就可以找到PID为2524的进程，如下图所示



### tail

tail  -fn100  catalina.log   查询日志尾部最后100行的日志,并且随文件;