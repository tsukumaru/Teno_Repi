import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 
import gab.opencv.*; 
import java.util.ArrayList; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Teno_Repi extends PApplet {





Capture video;
OpenCV opcv;

public void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  opcv = new OpenCV(this, width, height);

  video.start();
  loadPixels(); //window\u306e\u30d4\u30af\u30bb\u30eb\u306bpixels[]\u3067\u53c2\u7167\u3067\u304d\u308b
}

public void draw() {
  // background(0);
  if(video.available()){
    video.read();
    video.loadPixels(); //capture\u3057\u305f\u30ab\u30e1\u30e9\u753b\u50cf\u306e\u30d4\u30af\u30bb\u30eb\u3092\u53d6\u5f97
    image(video, 0, 0);

    colorMode(HSB);
    filter(BLUR); //\u30d1\u30e9\u30e1\u30fc\u30bf\u7121\u3057\u3067\u30ac\u30a6\u30b7\u30a2\u30f3\u30d5\u30a3\u30eb\u30bf
    //\u660e\u5ea6\u30672\u5024\u5316
    toFleshColorBinarizationIm(video);
    //video.filter(DILATE); //\u81a8\u5f35\u51e6\u7406
    distTransform(video);
    findHandContour(video);
    updatePixels();
  }
}

//\u808c\u8272\u30672\u5024\u5316
public void toFleshColorBinarizationIm(Capture video){
  for (int y = 0; y < video.height; ++y) {
    for (int x = 0; x < video.width; ++x) {
     int pixelColor = video.pixels[y*video.width + x];

     float h = hue(pixelColor);
     float s = saturation(pixelColor);
     float v = brightness(pixelColor);
      if (h >= 0 && h <= 15 && s >= 30 && v >= 30){//default 0<=h<=30,s>=30,v>=30
        video.pixels[y*video.width + x] = color(h, s, 100);
        // pixels[y * video.width + x] = color(3, 81, 50);
      }
      else{
        video.pixels[y*video.width + x] = color(h, s, 0);//color(59, 20, 50);
        // pixels[y * video.width + x] = color(3, 81, 50);
      }
    }
  }
}

//\u8ddd\u96e2\u5909\u63db\u753b\u50cf\u4f5c\u6210
public void distTransform(Capture video){
  for (int y = 0; y < video.height; ++y) {
    for (int x = 0; x < video.width; ++x) {
      //toFleshColorBinarizationIm(video, x, y);
      int index = y * video.width + x;

      //\u8ddd\u96e2\u753b\u50cf\u4f5c\u6210
      //\u5de6\u4e0a\u304b\u3089\u53f3\u4e0b\u3078
      float min = brightness(video.pixels[index]);
      if (x - 1 >= 0)
        min = min(min, brightness(video.pixels[y * video.width + (x-1)]) + 1);
      if(y - 1 >= 0)
        min = min(min, brightness(video.pixels[(y-1) * video.width + x]) + 1);
      video.pixels[index] = color(0, 0, min);
      // pixels[index] = color(0, 0, min * 10);
    }
  }
  //\u9006\u65b9\u5411\u304b\u3089
  for (int y = 0; y < video.height; ++y) {
    for (int x = 0; x < video.width; ++x) {
      int inv_x = video.width - 1 - x;
      int inv_y = video.height - 1 - y;
      int inv_index = inv_y * video.width + inv_x;
      float min = brightness(video.pixels[inv_index]);
      if(inv_x + 1 <= video.width - 1)
        min = min(min, brightness(video.pixels[inv_y * video.width + (inv_x + 1)]) + 1);
      if (inv_y + 1 <= video.height - 1)
        min = min(min, brightness(video.pixels[(inv_y + 1) * video.height + inv_x]) + 1);
      video.pixels[inv_index] = color(0, 0, min);
      // pixels[inv_index] = color(0, 0, min * 10);
    }
  }
}

//\u624b\u306e\u8f2a\u90ed\u3092\u6c42\u3081\u308b
public void findHandContour(Capture video){
  opcv.loadImage(video);
  ArrayList<Contour> contours = new ArrayList(opcv.findContours(false, true));

  Contour hand = contours.get(0);
  ArrayList<PVector> handVectors = hand.getPoints();
  for (int i = 0; i < handVectors.size(); ++i) {
    PVector hv = handVectors.get(i);
    int handIndex = PApplet.parseInt(hv.y * video.width + hv.x);
    pixels[handIndex] = color(0, 0, 0);
  }
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
