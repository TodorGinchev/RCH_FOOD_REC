package fd.precious.comnet.aalto.fooddiary;

import android.app.Activity;
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.TextView;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

public class Uploader  {

    public static String TAG = "Uploader";
    public static Context upContext;

    public static void uploadImage(String imagePath, Context mContext) {
        upContext = mContext;
        Uploader up = new Uploader();
        PostImage post = up.new PostImage();
        post.execute(imagePath);
    }


    private class PostImage extends AsyncTask<String, String, Integer> {
        protected Integer doInBackground(String... imagePath) {
            Log.i(TAG,"Sending photo...");
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httppost = new HttpPost("http://precious4.research.netlab.hut.fi/test");
            //for the image
            MultipartEntity mpEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
            if (imagePath != null) {
                File file = new File(imagePath[0]);
                Log.d("EDIT USER PROFILE", "UPLOAD: file length = " + file.length());
                if(file.length()==0)
                    return 0; //Do not upload the photo if there is an error with the file
                Log.d("EDIT USER PROFILE", "UPLOAD: file exist = " + file.exists());
                mpEntity.addPart("image", new FileBody(file, "application/octet"));
            }
            httppost.setEntity(mpEntity);
            //for the JSON
//            JSONObject json = new JSONObject();
//            JSONObject jsonObj = new JSONObject(); //Object data
//            StringEntity se;
//            try {
//                jsonObj.put("name_of_food", "food recognition test");
//                json.put("foodrec", jsonObj);
//                Log.i(TAG,json.toString());
//                se = new StringEntity(json.toString());
//                se.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
//                httppost.setEntity(se);
//            }catch (Exception e){
//                Log.e(TAG, " ",e);
//            }

            try {
                HttpResponse response = httpclient.execute(httppost);

                //Convert response to readable text
                BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
                StringBuilder builder = new StringBuilder();
                String str = "";

                while ((str = rd.readLine()) != null) {
                    builder.append(str);
                }

                String text = builder.toString();
                //Format server response
                text=text.replace("\\","");
                text=text.substring(1,text.length()-1);
                Log.i(TAG,"Server response: "+text);
                String [] progress = new String[1];
                progress[0]=text;
                publishProgress(progress);

            }catch (Exception e){
                Log.e(TAG, " ",e);
            }
            return 0;
        }

        protected void onProgressUpdate(String... progress) {
            TextView txt = (TextView)((Activity)upContext).findViewById(R.id.textView);
            txt.setText(progress[0]);
        }

        protected void onPostExecute(Long result) {

        }
    }
}
