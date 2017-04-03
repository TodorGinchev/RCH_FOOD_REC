package fd.precious.comnet.aalto.fooddiary;

import android.util.Log;

import org.apache.http.HttpEntity;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class Uploader {

    public void uploadImage(String imagePath) {
        String boundary = "*************";
        MultipartEntityBuilder builder = MultipartEntityBuilder.create();
        builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
        FileBody fileBody = new FileBody(new File(imagePath));//pass your image path to make a file
        builder.addPart("profile_image", fileBody);
        //TODO uncomment next line if JSON API is used
        // builder.addPart("data", new StringBody(jsonObject.toString(), ContentType.TEXT_PLAIN));//pass our jsonObject  here
        HttpEntity entity = builder.build();

        URL url = null;

        try {
            url = new URL("precious4.research.netlab.hut.fi");
            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.setConnectTimeout(10000);
            urlConnection.setReadTimeout(10000);
            urlConnection.setDoOutput(true);
            urlConnection.setRequestMethod("POST");
            urlConnection.addRequestProperty("Content-length", entity.getContentLength() + "");
            urlConnection.addRequestProperty(entity.getContentType().getName(), entity.getContentType().getValue());
            OutputStream os = urlConnection.getOutputStream();
            entity.writeTo(urlConnection.getOutputStream());
            os.close();
            urlConnection.connect();
            InputStream inputStream = urlConnection.getInputStream();
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
            String s = "";
            StringBuilder stringBuilder = new StringBuilder("");
            while ((s = bufferedReader.readLine()) != null) {
                stringBuilder.append(s);
            }
            String serverResponseMessage = stringBuilder.toString();
        }
        catch (Exception e){
            Log.e("TAG", " ",e);
        }
    }
}
