import processing.video.*;
// import java.awt.*;

Capture video;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);

  video.start();
  loadPixels(); //windowのピクセルにpixels[]で参照できる
}

void draw() {
  // background(0);
  if(video.available()){
    video.read();
    video.loadPixels(); //captureしたカメラ画像のピクセルを取得

    colorMode(HSB);
    // image(video, 0, 0);
    filter(BLUR, 6); //パラメータ無しでガウシアンフィルタ
    for (int y = 0; y < video.height; ++y) {
      for (int x = 0; x < video.width; ++x) {
        toFleshColorBinarizationIm(video, x, y);
       
      }
    }
    updatePixels();
  }
}

//肌色で2値化
void toFleshColorBinarizationIm(Capture video, int x, int y){
 int pixelColor = video.pixels[y*video.width + x];

 float h = hue(pixelColor);
 // float s = saturation(pixelColor);
 // float v = brightness(pixelColor);
 if (h >= 0.0 && h <= 30.0)
   pixels[y*video.width + x] = color(0);
  else
   pixels[y*video.width + x] = color(180);
}