package co.veam.veam31000287;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;


import android.util.Log;

public class HttpMultipartRequest {
	private static final String BOUNDARY = "----------V2ymHFg03ehbqgZCaKO6jy";
	private String url;
	private List<String> postData;
	private String imageName;
	private String imagePath;

	public HttpMultipartRequest(String url, List<String> postData,String imageName, String imagePath) {
		this.url = url;
		this.postData = postData;
		this.imageName = imageName;
		this.imagePath = imagePath;
	}

	public String send(byte[] imageBytes) {
		URLConnection conn = null;
		String res = null;
		try {
			conn = new URL(url).openConnection();
			conn.setRequestProperty("Content-Type","multipart/form-data; boundary=" + BOUNDARY);
			// User Agentの設定はAndroid1.6の場合のみ必要
			conn.setRequestProperty("User-Agent", "Android");
			// HTTP POSTのための設定
			((HttpURLConnection) conn).setRequestMethod("POST");
			conn.setDoOutput(true);
			// HTTP接続開始
			conn.connect();
			// send post data

			OutputStream os = conn.getOutputStream();
			String boundaryMessage = createBoundaryMessage(imagePath) ;
			//VeamUtil.log("debug","boundaryMessage:"+boundaryMessage) ;
			os.write(boundaryMessage.getBytes());
			//VeamUtil.log("debug","first:"+imageBytes[0]) ;
			os.write(imageBytes);
			String endBoundary = "\r\n--" + BOUNDARY + "--\r\n";
			os.write(endBoundary.getBytes());
			os.close();
			// get response
			InputStream is = conn.getInputStream();
			res = convertToString(is);
		} catch (Exception e) {
			//VeamUtil.log("HttpMultipartRequest:", e.getMessage());
		} finally {
			if (conn != null)
				((HttpURLConnection) conn).disconnect();
		}
		return res;
	}

	private String createBoundaryMessage(String fileName) {
		StringBuffer res = new StringBuffer("--").append(BOUNDARY).append(
				"\r\n");
		for (String nv : postData) {
			//VeamUtil.log("debug","nv " + nv) ;
			String[] pair = nv.split("=",2) ;
			//VeamUtil.log("debug","pair.length " + pair.length) ;
			
			if(pair.length == 2){
				//VeamUtil.log("debug","param " + pair[0] + ":" + pair[1]) ;
				res.append("Content-Disposition: form-data; name=\"")
						.append(pair[0]).append("\"\r\n").append("\r\n")
						.append(pair[1]).append("\r\n").append("--")
						.append(BOUNDARY).append("\r\n");
			}
		}
		String[] fileChunks = fileName.split("\\.");
		String fileType = "image/" + fileChunks[fileChunks.length - 1];
		res.append("Content-Disposition: form-data; name=\"").append(imageName)
				.append("\"; filename=\"").append(fileName).append("\"\r\n")
				.append("Content-Type: ").append(fileType).append("\r\n\r\n");
		return res.toString();
	}

	/*
	private byte[] getImageBytes(File file) {
		byte[] b = new byte[10];
		FileInputStream fis = null;
		ByteArrayOutputStream bo = new ByteArrayOutputStream();
		try {
			fis = new FileInputStream(file);
			while (fis.read(b) > 0) {
				bo.write(b);
			}
		} catch (FileNotFoundException e) {
			VeamUtil.log("HttpMultipartRequest:", e.getMessage());
		} catch (IOException e) {
			VeamUtil.log("HttpMultipartRequest:", e.getMessage());
		} finally {
			try {
				bo.close();
			} catch (IOException e) {
			}
			if (fis != null)
				try {
					fis.close();
				} catch (IOException e) {
				}
		}
		return bo.toByteArray();
	}
	*/

	private String convertToString(InputStream stream) {
		InputStreamReader streamReader = null;
		BufferedReader bufferReader = null;
		try {
			streamReader = new InputStreamReader(stream, "UTF-8");
			bufferReader = new BufferedReader(streamReader);
			StringBuilder builder = new StringBuilder();
			for (String line = null; (line = bufferReader.readLine()) != null;) {
				builder.append(line).append("\n");
			}
			return builder.toString();
		} catch (UnsupportedEncodingException e) {
			Log.e("HttpMultipartRequest:", e.getMessage());
		} catch (IOException e) {
			Log.e("HttpMultipartRequest:", e.toString());
		} finally {
			try {
				stream.close();
				if (bufferReader != null)
					bufferReader.close();
			} catch (IOException e) {
				//
			}
		}
		return null;
	}

}
