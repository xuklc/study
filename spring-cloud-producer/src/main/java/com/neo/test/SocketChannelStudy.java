package com.neo.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.net.InetSocketAddress;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Iterator;
import java.util.Set;

/**
 * @author xukl
 * @date 2018/11/25
 */
public class SocketChannelStudy {

    public static void main(String[] args) throws IOException {
        // 1. 获取通道
        SocketChannel socketChannel = SocketChannel.open(new InetSocketAddress("192.168.100.193", 8081));

        // 1.1切换成非阻塞模式
        socketChannel.configureBlocking(false);

        // 1.2获取选择器
        Selector selector = Selector.open();

        // 1.3将通道注册到选择器中，获取服务端返回的数据
        File file = new File("D:\\software\\work\\人员简历模板.docx");
        SelectionKey selectionKey = socketChannel.register(selector, SelectionKey.OP_READ, file.getName());
        FileInputStream fis = new FileInputStream(file);

        FileChannel fileChannel = fis.getChannel();

        // 2. 发送一张图片给服务端吧
//        FileChannel fileChannel = FileChannel.open(Paths.get("D:\\software\\work\\人员简历模板.docx"), StandardOpenOption.READ);

        // 3.要使用NIO，有了Channel，就必然要有Buffer，Buffer是与数据打交道的呢
        ByteBuffer buffer = ByteBuffer.allocate(1024);
        String fileName = file.getName();
        selectionKey.attach(fileName);
        // 4.读取本地文件(图片)，发送到服务器
        while (fileChannel.read(buffer) != -1) {

            // 在读之前都要切换成读模式
            buffer.flip();
            socketChannel.write(buffer);

//            socketChannel.setOption(SocketOption)
            // 读完切换成写模式，能让管道继续读取文件的数据
            buffer.clear();
        }
        fileChannel.close();
        socketChannel.finishConnect();
        socketChannel.close();


        System.out.println(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss:SSS")) + "---accept");
//        while(selector.select()>0){
//
//        }
        // 5. 轮训地获取选择器上已“就绪”的事件--->只要select()>0，说明已就绪
//        while (selector.select() > 0) {
//            // 6. 获取当前选择器所有注册的“选择键”(已就绪的监听事件)
//            Iterator<SelectionKey> iterator = selector.selectedKeys().iterator();
//
//            // 7. 获取已“就绪”的事件，(不同的事件做不同的事)
//            while (iterator.hasNext()) {
//
//                SelectionKey selectionKey = iterator.next();
//
//                // 8. 读事件就绪
//                if (selectionKey.isReadable()) {
//
//                    // 8.1得到对应的通道
//                    SocketChannel channel = (SocketChannel) selectionKey.channel();
//
//                    ByteBuffer responseBuffer = ByteBuffer.allocate(1024);
//
//                    // 9. 知道服务端要返回响应的数据给客户端，客户端在这里接收
//                    int readBytes = channel.read(responseBuffer);
//
//                    if (readBytes > 0) {
//                        // 切换读模式
//                        responseBuffer.flip();
//                        System.out.println(new String(responseBuffer.array(), 0, readBytes));
//                    }
//                }
//                // 10. 取消选择键(已经处理过的事件，就应该取消掉了)
//                iterator.remove();
//            }
//        }
    }
}
