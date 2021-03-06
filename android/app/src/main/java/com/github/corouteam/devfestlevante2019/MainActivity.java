package com.github.corouteam.devfestlevante2019;

import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import androidx.core.content.ContextCompat;

import android.view.View;
import android.view.WindowManager;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        int flags = getFlutterView().getSystemUiVisibility();
        flags |= View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        getFlutterView().setSystemUiVisibility(flags);
        this.getWindow().setStatusBarColor(Color.WHITE);
      }
  }

  public static void changeStatusBarColor(Activity act) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      act.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
      act.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
      act.getWindow().setStatusBarColor(Color.parseColor("#ffffff"));
    }

  }
}
