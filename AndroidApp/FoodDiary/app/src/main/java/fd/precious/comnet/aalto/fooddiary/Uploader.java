package fd.precious.comnet.aalto.fooddiary;

import android.os.AsyncTask;
import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.File;

public class Uploader  {

    public static String TAG = "Uploader";

    public static void uploadImage(String imagePath) {
        Uploader up = new Uploader();
        PostImage post = up.new PostImage();
        post.execute(imagePath);
    }

    public class PostImage extends AsyncTask<String, Integer, Integer> {
        protected Integer doInBackground(String... imagePath) {
            Log.i(TAG,"Sending photo...");
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httppost = new HttpPost("http://precious4.research.netlab.hut.fi/users/new");

            MultipartEntity mpEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
            if (imagePath != null) {
                File file = new File(imagePath[0]);
                Log.d("EDIT USER PROFILE", "UPLOAD: file length = " + file.length());
                Log.d("EDIT USER PROFILE", "UPLOAD: file exist = " + file.exists());
                mpEntity.addPart("avatar", new FileBody(file, "application/octet"));
            }
            httppost.setEntity(mpEntity);
            try {
                HttpResponse response = httpclient.execute(httppost);
                Log.i(TAG,"Server response: "+response.toString());
            }catch (Exception e){
                Log.e(TAG, " ",e);
            }
            return 0;
        }

        protected void onProgressUpdate(Integer... progress) {
        }

        protected void onPostExecute(Long result) {
        }
    }
}
