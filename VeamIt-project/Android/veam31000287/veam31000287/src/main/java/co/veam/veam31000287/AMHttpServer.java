package co.veam.veam31000287;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.util.Log;

public class AMHttpServer extends Thread {
    static final String LF = System.getProperty("line.separator");
    static final int DEFAULT_PORT = 8800;
    static final int MAX_HEADER_SIZE = 16384;
    static final Pattern COMMAND = Pattern.compile("^(\\w+)\\s+(.+?)\\s+HTTP/([\\d.]+)$");
    ServerSocket serverSocket;
    boolean debug;
    
    private Context mContext ;
    
    AssetManager m_AssetManager ;
    private long mFileLength ;
    private long m_rangeOffset ;
    private long m_rangeOffsetEnd ;
    private String mPrivate = "E1A8C6A4BAF9ACF0EDDE4C36AFB6F72C00AE4D427F317313E452D4166B876507" ; // 目くらましダミー
    private String mFileName = "" ;
    
    private static final byte[] mStaticKey = {
    		(byte)0x4D,(byte)0xA7,(byte)0xFB,(byte)0x38,(byte)0xE9,(byte)0x67,(byte)0x96,(byte)0xB2,(byte)0xFD,(byte)0x07,(byte)0x5D,(byte)0x4C,(byte)0x25,(byte)0x0B,(byte)0x0A,(byte)0xBC,
    		(byte)0x69,(byte)0xAE,(byte)0x3C,(byte)0x05,(byte)0xC7,(byte)0x55,(byte)0x75,(byte)0x50,(byte)0xC7,(byte)0x62,(byte)0xCF,(byte)0xBE,(byte)0x34,(byte)0x59,(byte)0xBF,(byte)0xDC,
    		(byte)0x42,(byte)0x26,(byte)0xF0,(byte)0x37,(byte)0x94,(byte)0xBC,(byte)0x3B,(byte)0x97,(byte)0xEA,(byte)0x6C,(byte)0x65,(byte)0xBE,(byte)0xB8,(byte)0x1F,(byte)0xE1,(byte)0x9B,
    		(byte)0xE2,(byte)0xC8,(byte)0xCA,(byte)0x2A,(byte)0x01,(byte)0xA6,(byte)0x8D,(byte)0xFE,(byte)0x07,(byte)0x98,(byte)0x0B,(byte)0xCC,(byte)0x26,(byte)0x1F,(byte)0x1A,(byte)0x90,
    		(byte)0x02,(byte)0xDE,(byte)0xD1,(byte)0xED,(byte)0x20,(byte)0x2F,(byte)0xB0,(byte)0x34,(byte)0xD7,(byte)0x22,(byte)0xBA,(byte)0x6A,(byte)0xBB,(byte)0x7B,(byte)0xF3,(byte)0x4C,
    		(byte)0x71,(byte)0x71,(byte)0x18,(byte)0xD9,(byte)0xAD,(byte)0x3D,(byte)0x20,(byte)0x1F,(byte)0xEB,(byte)0xBF,(byte)0x87,(byte)0x43,(byte)0x92,(byte)0x55,(byte)0x4A,(byte)0x25,
    		(byte)0x19,(byte)0x08,(byte)0xBB,(byte)0x0F,(byte)0x08,(byte)0x8B,(byte)0x31,(byte)0xE2,(byte)0xCA,(byte)0x07,(byte)0x22,(byte)0xB7,(byte)0x10,(byte)0x6E,(byte)0x0E,(byte)0xF5,
    		(byte)0x8A,(byte)0x26,(byte)0x84,(byte)0x19,(byte)0xA3,(byte)0xEF,(byte)0xA6,(byte)0xB2,(byte)0x38,(byte)0x62,(byte)0x17,(byte)0x99,(byte)0xB7,(byte)0x9A,(byte)0xEB,(byte)0xF4,
    		(byte)0xBC,(byte)0x8F,(byte)0xE6,(byte)0x81,(byte)0xA9,(byte)0xD8,(byte)0x13,(byte)0xBD,(byte)0xBF,(byte)0x90,(byte)0x5B,(byte)0x54,(byte)0x77,(byte)0x6A,(byte)0xD9,(byte)0xFA,
    		(byte)0x09,(byte)0x4E,(byte)0x0F,(byte)0xB8,(byte)0xCE,(byte)0x6C,(byte)0xAB,(byte)0x51,(byte)0xC4,(byte)0xBB,(byte)0xA8,(byte)0x39,(byte)0x6C,(byte)0xE7,(byte)0xCE,(byte)0x5C,
    		(byte)0x0E,(byte)0x61,(byte)0x29,(byte)0xD8,(byte)0x34,(byte)0xD4,(byte)0x7A,(byte)0x22,(byte)0x7B,(byte)0x89,(byte)0xF5,(byte)0x22,(byte)0xC3,(byte)0xD9,(byte)0xE3,(byte)0xF8,
    		(byte)0x17,(byte)0xE5,(byte)0x30,(byte)0x3B,(byte)0xAA,(byte)0x52,(byte)0x2F,(byte)0x00,(byte)0xA1,(byte)0xCA,(byte)0x2C,(byte)0xD6,(byte)0x4B,(byte)0xDC,(byte)0x89,(byte)0x6F,
    		(byte)0x44,(byte)0x8C,(byte)0xB9,(byte)0x37,(byte)0xDB,(byte)0x3B,(byte)0xB8,(byte)0xAD,(byte)0x1F,(byte)0x71,(byte)0xC3,(byte)0x9F,(byte)0x6B,(byte)0xC6,(byte)0x6F,(byte)0xED,
    		(byte)0xCD,(byte)0x0C,(byte)0xCC,(byte)0xD9,(byte)0xD3,(byte)0x26,(byte)0x18,(byte)0x41,(byte)0x44,(byte)0x0B,(byte)0x7B,(byte)0xEF,(byte)0xBC,(byte)0x9E,(byte)0xD3,(byte)0xE0,
    		(byte)0x28,(byte)0xC3,(byte)0x39,(byte)0x86,(byte)0xD3,(byte)0xFF,(byte)0x07,(byte)0x30,(byte)0x15,(byte)0x8E,(byte)0x58,(byte)0x8D,(byte)0xED,(byte)0x92,(byte)0x29,(byte)0x3C,
    		(byte)0x7E,(byte)0xE6,(byte)0x35,(byte)0xCE,(byte)0xB5,(byte)0x4E,(byte)0x5E,(byte)0x11,(byte)0xC4,(byte)0x84,(byte)0xFB,(byte)0xC5,(byte)0x8A,(byte)0xEA,(byte)0x52,(byte)0xAA
    };
    
    public void run() {
    	
	    	try{
		    	//System.out.println("before debug") ;
		        setDebug(true);
		        
		    	//System.out.println("before service") ;
		        service();
		        
		    	//System.out.println("before close") ;
		        close();
		        
		    	//System.out.println("after close") ;
	        }catch (IOException e){
	        	//System.out.println("WebServer error : " + e.getMessage()) ;
	        	
	        	StringWriter sw = null;
	            PrintWriter  pw = null;
	            
	            sw = new StringWriter();
	            pw = new PrintWriter(sw);
	            e.printStackTrace(pw);
	
	        }
    }


    /**
     * throw exception if request can not be handled
     */
    class BadRequestException extends RuntimeException {
        BadRequestException(String msg, String resp, int initCode) {
            super(msg);
            responseMessage = resp;
            statusCode = initCode;
        }
        BadRequestException(String msg, int initCode) {
            super(msg);
            responseMessage = msg;
            statusCode = initCode;
        }
        String responseMessage;
        int statusCode;
    }

    /**
     * request information
     */
    class Request {
        String method;
        String version;
        String path;
        String[] metadata;
        InputStream in;

        Request(Socket sock) throws IOException {
            // System.out.println("Before getInputStream()") ;
            in = sock.getInputStream();
            //System.out.println("Before header()") ;
            header();
            //System.out.println(this);
            m_rangeOffset = 0 ;
            m_rangeOffsetEnd = 0 ;
            for (int i = 0; i < metadata.length; i++) {
                //System.out.println(metadata[i]);
                // 10-26 18:30:59.475: INFO/System.out(1876): Range: bytes=9146716-26111121
                String headString = metadata[i].substring(0,5) ;
                //System.out.println(headString) ;
             
                if(headString.equals("Range")){
               	
                	int begin = metadata[i].indexOf('=') ;
                	int end = metadata[i].indexOf('-') ;
                	String offsetString1 =  metadata[i].substring(begin+1,end) ;
                	m_rangeOffset = Integer.parseInt(offsetString1) ;
                	
                	String offsetString2 ;
                	if(metadata[i].length() > (end + 1)){
                		offsetString2 =  metadata[i].substring(end+1) ;
                    	m_rangeOffsetEnd = Integer.parseInt(offsetString2) ; 
                	} else {
                		// Range: xx- の形式の場合最後まで
                    	m_rangeOffsetEnd = mFileLength - 1 ; 
                	}
                	
                	//System.out.println("RANGE DETECTED " + metadata[i]) ;
                	//System.out.println("RANGE INTVALUE " + m_rangeOffset + "-" + m_rangeOffsetEnd) ;
                }

            }
        }
        
        void header() throws IOException {
            byte[] buff = new byte[2000];
            for (int i = 0; ; i++) {
                int c = in.read();
                if (c < 0) {
                    throw new BadRequestException("header too short:" +
                                              new String(buff, 0, i),
                                                      "header too short",
                                              HttpURLConnection.HTTP_BAD_REQUEST);
                }
                buff[i] = (byte)c;
                if (i > 3
                    && buff[i - 3] == '\r' && buff[i - 2] == '\n'
                    && buff[i - 1] == '\r' && buff[i] == '\n') {
                    createHeader(buff, i - 4);
                    break;
                } else if (i == buff.length - 1) {
                    if (i > MAX_HEADER_SIZE) {
                        throw new BadRequestException("header too long:" +
                                              new String(buff, 0, 256),
                                                      "header too long",
                                              HttpURLConnection.HTTP_BAD_REQUEST);
                    }
                    byte[] nbuff = new byte[buff.length * 2];
                    System.arraycopy(buff, 0, nbuff, 0, i + 1);
                    buff = nbuff;
                }
            }
        }
        
        void createHeader(byte[] buff, int len) {
            for (int i = 0; i < len; i++) {
                if (i > 2 && buff[i - 1] == '\r' && buff[i] == '\n') {
                    Matcher m = COMMAND.matcher(new String(buff, 0, i - 1));
                    if (m.matches()) {
                        method = m.group(1);
                        path = m.group(2);
                        version = m.group(3);
                    } else {
                        throw new BadRequestException(new String(buff, 0, i + 1),"header too long",HttpURLConnection.HTTP_BAD_REQUEST);
                    }
                    metadata = new String(buff, i + 1, len - i).split("\\r\\n");
                    break;
                }
            }
        }
        
        public String toString() {
            StringBuffer sb = new StringBuffer(super.toString()).append(LF);
            sb.append(method);
            sb.append(' ').append(path).append(" HTTP/").append(version);
            return sb.toString();
        }
    }

    /**
     * create instance of a HTTP server
     *
     * @param port port number
     */
    public AMHttpServer(Context context,int port,AssetManager assetManager,String fileName,String key) throws IOException {
    	//System.out.println("AMHttpServer::AMHttpServer") ;
    	mContext = context ;
    	mFileName = fileName ;
        m_AssetManager = assetManager ;
        AssetFileDescriptor afd = getAssetFileDescriptor() ;
        if(afd == null){
        	// アセットにない場合はSDカードから読む
        	FileInputStream fi = new FileInputStream(VeamUtil.getVeamPath(context) + "/" + mFileName) ;
	        //System.out.println("get length from SD " + VEAMUtil.getVeamPath(context) + "/" + mFileName) ;
	        mFileLength = fi.available() ;
	        fi.close() ;
	        fi = null ;
        } else {
        	mFileLength = afd.getLength() ;
        }
    	
    	mPrivate = "__PRIVATE_KEY__" ;
    	mPrivate = key ;
    	
        serverSocket = new ServerSocket();
        serverSocket.setReuseAddress(true);
        serverSocket.bind(new InetSocketAddress(port));
    }
    
    private AssetFileDescriptor getAssetFileDescriptor(){
        AssetFileDescriptor afd = null ;
        try {
        	afd = m_AssetManager.openFd(mFileName) ;
        } catch(FileNotFoundException e){
        } catch (IOException e) {
			//e.printStackTrace();
		}
        return afd ;
    }

    /**
     * toggle debug output setting
     * @param b output debug information to stdout if this value is set as true
     */
    public void setDebug(boolean b) {
        debug = b;
    }
    
    /**
     * stop server
     */
    public void close() {
		//System.out.println("close()");
        if (serverSocket == null) {
    		//VeamUtil.log("MyHttpServer", "point 1");
            return;
        }
        try {
    		//VeamUtil.log("MyHttpServer", "point 2");
            serverSocket.close();
    		//VeamUtil.log("MyHttpServer", "point 3");
            serverSocket = null;
    		//VeamUtil.log("MyHttpServer", "point 4");
        } catch (IOException e) {
            // ignore exception
    		//VeamUtil.log("MyHttpServer", "point 5");
        }
    }

    /**
     * start service
     * control is not back until "/quit" request issued or {@link #close} called
     */
    public void service() throws IOException {
        assert serverSocket != null;
        
       	for (Socket sock = accept(); sock != null; sock = accept()) {
            try {
            	//System.out.println("before new Request") ;
                //VeamUtil.log("debug", "before new Request") ;
                Request req = new Request(sock);
                if (req.path.equals("/quit")) {
                    response(200, "OK", sock.getOutputStream());
                    break;
                } else {
                	//System.out.println("before response") ;
                    //VeamUtil.log("debug","before response") ;
                    response(req, sock.getOutputStream());
                	//System.out.println("after response") ;
                    //VeamUtil.log("debug","after response") ;
                }
            } catch (BadRequestException e) {
                if (debug) {
                    e.printStackTrace();
                }
                response(sock.getOutputStream(), e);
            } finally {
            	//System.out.println("before sock.close") ;
                sock.close();
            	//System.out.println("after: sock.close") ;
            }
        }
    }

    /**
     * operate request from client
     */
    void response(Request req, OutputStream out) throws IOException {
        //System.out.println("response() start " + req.method) ;
        if (req.method.equals("GET")) {
            //System.out.println("method is GET") ;
        	
            //System.out.println("before AssetVideo") ;
    		responseAssetVideo(out) ;
            //System.out.println("after AssetVideo") ;
    		/*
        } else if (req.method.equals("HEAD")) {
        	AssetFileDescriptor afd = m_AssetManager.openFd("movie.dat") ;
            responseSuccess((int)afd.getLength(), "video/3gpp", out);
            */
        } else {
            throw new BadRequestException("unknown method:" + req.method,HttpURLConnection.HTTP_BAD_METHOD);
        }
    }

    /**
     * return specified file content
     */
    void responseAssetVideo(OutputStream out) throws IOException {
    	AssetFileDescriptor afd = getAssetFileDescriptor() ;
    	long afdStartOffset ;
        FileInputStream fi = null ;
    	
    	if(afd == null){
	    	afdStartOffset = 0 ;
	        fi = new FileInputStream(VeamUtil.getVeamPath(mContext) + "/" + mFileName) ;
	      //System.out.println("from SD " + VEAMUtil.getVeamPath(mContext) + "/" + mFileName) ;
    	} else {
	    	afdStartOffset = afd.getStartOffset() ;
	        fi = new FileInputStream(afd.getFileDescriptor()) ;
    	}
    	
    	long fileLength = mFileLength ;
    	long currentPosi = 0 ;
    	long endLength = fileLength ;
    	if(m_rangeOffsetEnd > 0){
    		endLength = m_rangeOffsetEnd + 1 ;
    		//System.out.println("endLength="+endLength) ;
    	}
    	
		responseSuccess((int)mFileLength, "video/3gpp", out);
		
        // System.out.println("rest=" + fi.available() + " length=" + afd.getLength()) ;
        BufferedInputStream bi = new BufferedInputStream(fi,327680);
        
        

        bi.skip((int)afdStartOffset) ;
        
        // range が8192の倍数で無い場合は8192の倍数の個所に設定して読み込み＆復号を行う。
        // resは指定された場所からの値を返す
        int rangeDifference = (int)m_rangeOffset % 8192 ;
        //System.out.println("rangeDifference=" + rangeDifference) ;
        
        long startOffset = m_rangeOffset - rangeDifference ;
        bi.skip(startOffset) ;
        currentPosi += startOffset ; 
        
        //System.out.println("asset offset = " + afd.getStartOffset() + "  range offset = " + m_rangeOffset) ;
        
        
        byte[] readBuf = new byte[8192] ;
        int readLen = 0 ;
        boolean lastFlag = false ;
        boolean isTail = false ;
        try {
        	while(((readLen = bi.read(readBuf)) > 0) && !lastFlag){
        		//System.out.println("read" + (int)readBuf[0] + "," + (int)readBuf[1]) ;
                //VeamUtil.log("debug","read") ;
        		currentPosi += readLen ;
        		//System.out.println("currentPosi=" + currentPosi + " fileLength=" + fileLength) ;
        		//System.out.println("readLen=" + readLen + " rangeDifference=" + rangeDifference + " readLen=" + readLen) ;
        		if(endLength <= currentPosi){

        			//System.out.println("Last") ;
        			lastFlag = true ;
        			readLen -= (currentPosi - endLength) ;
            		if(fileLength <= currentPosi){
            			// ファイルの最後のブロック
            			isTail = true ;
            		}
        		}
        		
        		if(!isTail){
        			if((((int)(currentPosi / 8192)) % 4) == 1){
	        			//byte[] result = SimpleCrypto.decrypt("024A8E799CE55DC9158FB8594FDB95FB", readBuf) ;
	        			byte[] result = SimpleCrypto.decrypt(mPrivate, readBuf) ;
	            		//System.out.println("result.length" + result.length) ;
	            		//System.out.println(String.format("POS=%08X:%02X %02X",currentPosi-8192,result[0],result[1])) ;
	        			out.write(result,rangeDifference,readLen-rangeDifference);
        			} else {
        				for(int i = 0 ; i < readLen ; i++){
        					readBuf[i] ^= mStaticKey[i%256] ^ (i >> 5);
        				}
	            		//System.out.println(String.format("POS=%08X:%02X %02X",currentPosi-8192,readBuf[0],readBuf[1])) ;
        				//System.out.println("readLen="+readLen) ;
    	                out.write(readBuf,rangeDifference,readLen-rangeDifference);
        			}
        		} else {
        			//System.out.println("isTail") ;
	        		// XOR
	        		for(int i = 0 ; i < readLen ; i++){
	        			readBuf[i] ^= 0xC5 ;
	        		}
	        		//System.out.println("rangeDifference=" + rangeDifference + " readLen=" + readLen) ;
	                out.write(readBuf,rangeDifference,readLen-rangeDifference);
	                //System.out.println("last readLen=" + readLen) ;
        		}
        		
        		// rangeの差は初回のみ影響するので次回のループからは影響なし
        		rangeDifference = 0 ;
            }
        }catch(java.net.SocketException e){
        	//System.out.println("SocketException") ;
            bi.close();
            fi.close();
            if(afd != null){
            	afd.close() ;
            }
        }catch(Exception e){
            //System.out.println("ERROR:" + e.getMessage());
            bi.close();
            fi.close();
            if(afd != null){
            	afd.close() ;
            }
        } finally {
        	//System.out.println("bi.close") ;
            bi.close();
            fi.close();
            if(afd != null){
            	afd.close() ;
            }
        }
        
        //System.out.println("response out   write="+writeCount) ;
    }
    
    /**
     * return specified file content
     */
    void response(File f, OutputStream out) throws IOException {
        responseSuccess((int)f.length(), "text/html", out);
        BufferedInputStream bi = new BufferedInputStream(new FileInputStream(f));
        try {
            for (int c = bi.read(); c >= 0; c = bi.read()) {
                out.write(c);
            }
        } finally {
            bi.close();
        }
    }

    /**
     * return specified text
     */
    void response(String htmlString, OutputStream out) throws IOException {
        responseSuccess((int)htmlString.length(), "text/html", out);
        try {
        	out.write(htmlString.getBytes());
        } finally {
        }
    }

    /**
     * return ok to client
     * @param len content length
     * @param type mime type of content
     */
    void responseSuccess(int len, String type, OutputStream out) throws IOException {
        PrintWriter prn = new PrintWriter(out);

        if(m_rangeOffset == 0){
	       	prn.print("HTTP/1.1 200 OK\r\n");
	        prn.print("Connection: close\r\n");
	        prn.print("Content-Length: ");
	        prn.print(len);
	        prn.print("\r\n");
	        prn.print("Content-Type: ");
	        prn.print(type);
        } else {
        	prn.print("HTTP/1.1 206 Partial Content\r\n");
	        prn.print("Connection: close\r\n");
	        prn.print("Accept-Ranges: bytes\r\n") ;
	        prn.print("Content-Length: ");
	        prn.print(m_rangeOffsetEnd-m_rangeOffset+1);
	        prn.print("\r\n");

            prn.print("Content-Range: bytes ");
            prn.print(m_rangeOffset);
            prn.print("-");
            prn.print(m_rangeOffsetEnd) ;
            prn.print("/");
            prn.print(len) ;
            prn.print("\r\n");

	        prn.print("Content-Type: ");
	        prn.print(type);
	        
	        //System.out.println("Content-Length: "+(m_rangeOffsetEnd-m_rangeOffset+1)+" Content-Range: "+m_rangeOffset+"-"+(m_rangeOffsetEnd)+"/"+len) ;
		        
        }
        prn.print("\r\n\r\n");
        prn.flush();
    }

    /**
     * return error to client
     */
    void response(OutputStream out, BadRequestException e) throws IOException {
        response(e.statusCode, e.responseMessage, out);
    }

    /**
     * return only header to client
     * @param stat status code
     * @param msg status message
     */
    void response(int stat, String msg, OutputStream out) throws IOException {
        PrintWriter prn = new PrintWriter(out);
        prn.print("HTTP/1.1 ");
        prn.print(stat);
        prn.print(" ");
        prn.print(msg);
        prn.print("\r\n\r\n");
        prn.flush();
    }

    /**
     * receive request
     */
    Socket accept() throws IOException {
        try {
        	//System.out.println("accept") ;
        	if(serverSocket != null){
        		return serverSocket.accept();
        	}
        } catch (SocketException e) {
            //System.out.println("done");
        }
        return null;
    }

}
