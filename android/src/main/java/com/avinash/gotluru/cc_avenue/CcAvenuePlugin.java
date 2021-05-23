package com.avinash.gotluru.cc_avenue;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.avinash.gotluru.cc_avenue.Framework.WebViewActivity;
import com.avinash.gotluru.cc_avenue.Utility.AvenuesParams;

import org.jetbrains.annotations.NotNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * CcAvenuePlugin
 */
public class CcAvenuePlugin extends FlutterActivity implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Activity activity;
    public String accessCode, merchantId, currencyType, amount, orderId, rsaKeyUrl, redirectUrl, cancelUrl,transUrl;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "cc_avenue");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull @org.jetbrains.annotations.NotNull FlutterPlugin.FlutterPluginBinding binding) {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        }
        else if (call.method.equals("CC_Avenue")) {
            transUrl = call.argument("transUrl");
            rsaKeyUrl = call.argument("rsaKeyUrl");
            accessCode = call.argument("accessCode");
            merchantId = call.argument("merchantId");
            orderId = call.argument("orderId");
            currencyType = call.argument("currencyType");
            amount = call.argument("amount");
            cancelUrl = call.argument("cancelUrl");
            redirectUrl = call.argument("redirectUrl");
            cCAvenueInIt();
        } else {
            result.notImplemented();
        }
    }


    public void cCAvenueInIt(){
        Intent intent = new Intent(this.activity, WebViewActivity.class);
        intent.putExtra(AvenuesParams.ACCESS_CODE, accessCode);
        intent.putExtra(AvenuesParams.MERCHANT_ID, merchantId);
        intent.putExtra(AvenuesParams.ORDER_ID, orderId);
        intent.putExtra(AvenuesParams.CURRENCY,currencyType );
        intent.putExtra(AvenuesParams.AMOUNT, amount);
        intent.putExtra(AvenuesParams.REDIRECT_URL, redirectUrl);
        intent.putExtra(AvenuesParams.CANCEL_URL, cancelUrl);
        intent.putExtra(AvenuesParams.RSA_KEY_URL, rsaKeyUrl);
        intent.putExtra(AvenuesParams.TRANS_URL, transUrl);
        this.activity.startActivity(intent);
    }

    @Override
    public void onAttachedToActivity(@NonNull @NotNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull @NotNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
    }
}
