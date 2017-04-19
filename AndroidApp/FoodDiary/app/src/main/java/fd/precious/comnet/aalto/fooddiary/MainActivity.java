package fd.precious.comnet.aalto.fooddiary;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.content.FileProvider;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

//Follow this tutorial if you need to implement changes: https://developer.android.com/training/camera/photobasics.html
public class MainActivity extends AppCompatActivity {
    public static final String TAG = "MainActivity";
    public static Context mContext;
    public Uri photoURI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mContext=this;

    }

    // Code for taking a photo
    static final int REQUEST_TAKE_PHOTO  = 1;
    public void dispatchTakePictureIntent(View v) {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

        // Ensure that there's a camera activity to handle the intent
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            // Create the File where the photo should go
            File photoFile = null;
            try {
                photoFile = createImageFile();
            } catch (IOException ex) {
                // Error occurred while creating the File
            //TODO...
            }
            // Continue only if the File was successfully created
            if (photoFile != null) {
                photoURI = FileProvider.getUriForFile(this,
                        "com.example.android.fileprovider",
                        photoFile);
                //Solve data access issue with Galaxy Gear smartwatch
                List<ResolveInfo> resInfoList = mContext.getPackageManager().queryIntentActivities(takePictureIntent, PackageManager.MATCH_DEFAULT_ONLY);
                for (ResolveInfo resolveInfo : resInfoList) {
                    String packageName = resolveInfo.activityInfo.packageName;
                    mContext.grantUriPermission(packageName, photoURI, Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
                }
                //End data access issue with Galaxy Gear smartwatch
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO);
            }
        }
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_TAKE_PHOTO) {
            if (resultCode == RESULT_OK) {
                // Image captured and saved to fileUri specified in the Intent
                Log.i(TAG,"Photo located at "+mCurrentPhotoPath);
                Uploader.uploadImage(mCurrentPhotoPath, mContext);
            } else if (resultCode == RESULT_CANCELED) {
                // User cancelled the image capture
            } else {
                // Image capture failed, advise user
            }
        }
    }

    //Code for storing the photo once it has been taken by the Camera app
    String mCurrentPhotoPath;

    private File createImageFile() throws IOException {
        // Create an image file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "PRECIOUS_JPEG_" + timeStamp + "_";
        File ext_storage = Environment.getExternalStorageDirectory();
        String extPath = ext_storage.getPath();
        File storageDir = new File(extPath+"/precious");//REMEMBER TO CHANGE res/xml/file.paths.xml to ynchronize both implementations
        File image = File.createTempFile(
                imageFileName,  /* prefix */
                ".jpg",         /* suffix */
                storageDir      /* directory */
        );

        // Save a file: path for use with ACTION_VIEW intents
        mCurrentPhotoPath = image.getAbsolutePath();

        return image;
    }

}

