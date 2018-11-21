package com.neo.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;

/**
 * @author xukl
 * @date 2018/11/21
 */
public class SocketChannelTest {

    public static void main(String[] args) throws IOException {
        Selector selector = Selector.open();
        SocketChannel client = SocketChannel.open();
        InetSocketAddress address = new InetSocketAddress("192.168.100.60",8081);
        int validOps = client.validOps();
        client.configureBlocking(false);
        SelectionKey register = client.register(selector, SelectionKey.OP_WRITE);
        client.connect(address);
        //设置成非阻塞模式
        client.configureBlocking(false);
//        client.bind();
        FileInputStream fos = new FileInputStream(new File("D:\\software\\work\\人员简历模板.docx"));
        ReadableByteChannel readChannel=fos.getChannel();
        ByteBuffer buffer  = ByteBuffer.allocate(1024);
        while(readChannel.read(buffer)>0){
            client.write(buffer);
        }
        readChannel.close();
        client.finishConnect();
    }

}
