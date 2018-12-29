package com.neo.test;

import lombok.extern.slf4j.Slf4j;
import org.h2.tools.Server;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.Iterator;
import java.util.Set;

/**
 * @author xukl
 * @date 2018/11/21
 */
public class ServerSocketChannelTest {

    public static void main(String[] args) throws IOException {
        Selector selector = Selector.open();
        ServerSocketChannel server = ServerSocketChannel.open();
        InetSocketAddress address = new InetSocketAddress("192.168.100.60", 8081);
        server.bind(address);
        server.configureBlocking(false);
        int validOps = server.validOps();
        SelectionKey selectionKey = server.register(selector, validOps);

        int select = selector.select();
        //返回准备好通信的通道
        Set<SelectionKey> readyChannel = selector.selectedKeys();
        channelEvent(readyChannel, server);
    }

    private static void channelEvent(Set<SelectionKey> readyChannel, ServerSocketChannel server) {
        Iterator<SelectionKey> iterator = readyChannel.iterator();
        while (iterator.hasNext()) {
            SelectionKey selectionKey = iterator.next();
            if (selectionKey.isWritable()) {
                try {
                    write(server, selectionKey);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } else if (selectionKey.isReadable()) {
                try {
                    read(server, selectionKey);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } else if (selectionKey.isAcceptable()) {
                try {
                    acceotCon(server, selectionKey);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            iterator.remove();
        }
    }

    private static void write(ServerSocketChannel server, SelectionKey selectionKey) throws IOException {
//        SocketChannel channel = (SocketChannel) server.configureBlocking(false);
        SocketChannel channel = (SocketChannel) selectionKey.channel();
        FileInputStream fis = new FileInputStream(new File("D:\\software\\work\\人员简历模板.docx"));
        ReadableByteChannel readChannel = fis.getChannel();
        ByteBuffer buffer = ByteBuffer.allocate(1024);
        buffer.put(String.valueOf("你好，我的社保和公积金呢？").getBytes("UTF-8"));
        buffer.flip();
        channel.write(buffer);
        buffer.clear();
        readChannel.close();
        channel.close();
    }

    private static void read(ServerSocketChannel server, SelectionKey selectionKey) throws IOException {

        SocketChannel channel = (SocketChannel) selectionKey.channel();

        ByteBuffer buffer = ByteBuffer.allocate(1024);
        FileOutputStream fos = new FileOutputStream(new File("D:\\software\\work\\人员简历模板2.docx"), true);
        WritableByteChannel writableByteChannel = fos.getChannel();
        while (channel.read(buffer) > 0) {
            writableByteChannel.write(buffer);
        }
        channel.close();
        writableByteChannel.close();
    }

    private static void acceotCon(ServerSocketChannel server, SelectionKey selectionKey) throws IOException {
        SocketChannel client = (SocketChannel) selectionKey.channel();
        ByteBuffer buffer = ByteBuffer.allocate(1024);
        FileOutputStream fos = new FileOutputStream(new File("D:\\software\\work\\人员简历模板3.docx"));
        FileChannel channel = fos.getChannel();
        while (client.read(buffer) > 0) {
            buffer.flip();//翻转buffer,通道(channel)读取buffer的数据写入文件
            channel.write(buffer);
            buffer.clear();//清空buffer，让SocketChannel重新读取数据到buffer
        }
        InetSocketAddress remoteAddress = (InetSocketAddress) client.getRemoteAddress();
        System.out.println(remoteAddress.getHostString());
    }
}
