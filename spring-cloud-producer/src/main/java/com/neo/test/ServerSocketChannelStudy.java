package com.neo.test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Iterator;

/**
 * @author xukl
 * @date 2018/11/25
 */
public class ServerSocketChannelStudy {
    private static  String  filePath="D:"+File.separator+"resources"+File.separator+"file"+File.separator;

    public static void main(String[] args) throws IOException {
        // 1.获取通道
        ServerSocketChannel server   = ServerSocketChannel.open();

        // 2.切换成非阻塞模式
        server.configureBlocking(false);

        // 3. 绑定连接
        server.bind(new InetSocketAddress(6666));

        // 4. 获取选择器
        Selector selector = Selector.open();

        // 4.1将通道注册到选择器上，指定接收“监听通道”事件
        server.register(selector, SelectionKey.OP_ACCEPT);
        // 5. 轮训地获取选择器上已“就绪”的事件--->只要select()>0，说明已就绪
        int i=0;
        while (selector.select() > 0) {

            // 6. 获取当前选择器所有注册的“选择键”(已就绪的监听事件)
            Iterator<SelectionKey> iterator = selector.selectedKeys().iterator();

            // 7. 获取已“就绪”的事件，(不同的事件做不同的事)
            while (iterator.hasNext()) {
                SelectionKey selectionKey = iterator.next();
                i++;
                // 接收事件就绪
                if (selectionKey.isAcceptable()) {

                    // 8. 获取客户端的链接
                    SocketChannel client = server.accept();
//                    SocketChannel client= (SocketChannel) selectionKey.channel();

                    // 8.1 切换成非阻塞状态
                    int validOps = server.validOps();
                    int readStatus=SelectionKey.OP_READ;
                    Object attachment = selectionKey.attachment();
                    System.out.println("attachment:"+attachment);
                    client.configureBlocking(false);
                    // 8.2 注册到选择器上-->拿到客户端的连接为了读取通道的数据(监听读就绪事件)
                    client.register(selector, SelectionKey.OP_READ);
//                    client.finishConnect();
                    System.out.println("accept");
                } else if (selectionKey.isReadable()) { // 读事件就绪

                    System.out.println(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")) +"---read start");
                    // 9. 获取当前选择器读就绪状态的通道
                    SocketChannel client = (SocketChannel) selectionKey.channel();

                    client.configureBlocking(false);
                    Object attachment = selectionKey.attachment();

                    // 9.1读取数据
                    ByteBuffer buffer = ByteBuffer.allocate(1024);
//                    String fileName=selectionKey.attachment().toString();
                    FileOutputStream fos = new FileOutputStream(new File(filePath+File.separator+i+".docx"));;
                    FileChannel outChannel = fos.getChannel();
                    // 9.2得到文件通道，将客户端传递过来的图片写到本地项目下(写模式、没有则创建)
//                    FileChannel outChannel = FileChannel.open(Paths.get("D:\\software\\work\\人员简历模板3.docx"), StandardOpenOption.WRITE, StandardOpenOption.CREATE);
                    while (client.read(buffer) > 0) {
                        buffer.flip();
                        // 在读之前都要切换成读模式
                        while(buffer.hasRemaining()){
                            outChannel.write(buffer);
                        }
                        // 读完切换成写模式，能让管道继续读取文件的数据
                        buffer.clear();
                    }
                    outChannel.close();
                    selectionKey.cancel();
                    client.finishConnect();

//                    client.close();
                    System.out.println(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")) +"---read end");
                }
                // 10. 取消选择键(已经处理过的事件，就应该取消掉了)
                iterator.remove();
            }
        }
    }

}
