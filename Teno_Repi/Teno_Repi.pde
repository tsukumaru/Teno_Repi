import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);

  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  video.start();
  loadPixels(); //windowのピクセルにpixels[]で参照できる
}

void draw() {
  // background(0);
  if(video.available()){
    video.read();
    video.loadPixels(); //captureしたカメラ画像のピクセルを取得

    opencv.loadImage(video);
   image(video, 0, 0);

    //colorMode(HSB);
    // image(video, 0, 0);
    //filter(BLUR); //パラメータ無しでガウシアンフィルタ
     for (int y = 0; y < video.height; ++y) {
       for (int x = 0; x < video.width; ++x) {
         toFleshColorBinarizationIm(video, x, y);
        
       }
     }
     updatePixels();
  // image(video, 0, 0);
    
  }
}

//肌色で2値化
void toFleshColorBinarizationIm(Capture video, int x, int y){
 int pixelColor = video.pixels[y*video.width + x];
 Rectangle[] faces = opencv.detect();
 int face_center = video.pixels[(faces[0].y + faces[0].height / 2) 
 * video.width + (faces[0].x + faces[0].width / 2)];

 float r = red(pixelColor);
 float g = green(pixelColor);
 float b = blue(pixelColor);
 if (red(face_center) - 10 <= r && r <= red(face_center) + 10 
  && green(face_center) - 10 <= g && g <= green(face_center) + 10
  && blue(face_center) - 10 <= b && b <= blue(face_center) + 10)
   pixels[y*video.width + x] = 0;
 else
   pixels[y*video.width + x] = 180;
}