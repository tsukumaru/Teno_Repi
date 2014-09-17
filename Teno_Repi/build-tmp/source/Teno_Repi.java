import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Teno_Repi extends PApplet {


// import java.awt.*;

Capture video;

public void setup() {
  size(640, 480);
  video = new Capture(this, width, height);

  video.start();
  loadPixels(); //window\u306e\u30d4\u30af\u30bb\u30eb\u306bpixels[]\u3067\u53c2\u7167\u3067\u304d\u308b
}

public void draw() {
  // background(0);
  if(video.available()){
    video.read();
    video.loadPixels(); //capture\u3057\u305f\u30ab\u30e1\u30e9\u753b\u50cf\u306e\u30d4\u30af\u30bb\u30eb\u3092\u53d6\u5f97

    colorMode(HSB);
    // image(video, 0, 0);
    filter(BLUR, 6); //\u30d1\u30e9\u30e1\u30fc\u30bf\u7121\u3057\u3067\u30ac\u30a6\u30b7\u30a2\u30f3\u30d5\u30a3\u30eb\u30bf
    for (int y = 0; y < video.height; ++y) {
      for (int x = 0; x < video.width; ++x) {
        toFleshColorBinarizationIm(video, x, y);
       
      }
    }
    updatePixels();
  }
}

//\u808c\u8272\u30672\u5024\u5316
public void toFleshColorBinarizationIm(Capture video, int x, int y){
 int pixelColor = video.pixels[y*video.width + x];

 float h = hue(pixelColor);
 float s = saturation(pixelColor);
 float v = brightness(pixelColor);
 if (h >= 0.0f && h <= 30.0f && s >= 30 && v >= 30)
   pixels[y*video.width + x] = 0;
  else
   pixels[y*video.width + x] = 180;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Teno_Repi" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
