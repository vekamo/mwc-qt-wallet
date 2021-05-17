package mw.mwc.wallet;

import java.io.File;
import android.net.Uri;
import android.content.Intent;
import android.provider.DocumentsContract;


public class QmlHelper
{
    // Type values:  .cfg -> text/plain     - it doesn't work this way.
    //  text/plain
    //  text/*
    public static Intent buildOpenFileIntent(String pickerInitialUri, String type ) {
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType(type);

        // Optionally, specify a URI for the file that should appear in the
        // system file picker when it loads.
        if ( pickerInitialUri!=null && !pickerInitialUri.isEmpty()) {
            intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, Uri.parse(pickerInitialUri));
        }

        return intent;
    }

    // pickerInitialUri path where to create the file. Expected it to be Download directory
    // filename - file name that we want to save data in.
    // type - mime type, similar to what buildOpenFileIntent has
    public static Intent buildCreateFileIntent(String pickerInitialUri, String type, String filename ) {
            Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
            intent.addCategory(Intent.CATEGORY_OPENABLE);
            intent.setType(type);
            intent.putExtra(Intent.EXTRA_TITLE, filename);

            // Optionally, specify a URI for the file that should appear in the
            // system file picker when it loads.
            if ( pickerInitialUri!=null && !pickerInitialUri.isEmpty()) {
                intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, Uri.parse(pickerInitialUri));
            }

            return intent;
    }


}