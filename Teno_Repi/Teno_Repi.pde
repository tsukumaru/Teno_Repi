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
    filter(BLUR); //パラメータ無しでガウシアンフィルタ
    //明度で2値化
    toFleshColorBinarizationIm(video);
    distTransform(video);
   
    updatePixels();
  }
}

//肌色で2値化
void toFleshColorBinarizationIm(Capture video){
  for (int y = 0; y < video.height; ++y) {
    for (int x = 0; x < video.width; ++x) {
     int pixelColor = video.pixels[y*video.width + x];

     float h = hue(pixelColor);
     float s = saturation(pixelColor);
     float v = brightness(pixelColor);
     if (h >= 0.0 && h <= 30.0 && s >= 30 && v >= 30)
       video.pixels[y*video.width + x] = color(h, s, 100);
     else
      video.pixels[y*video.width + x] = color(h, s, 0);//color(59, 20, 50);
    }
  }
}

void distTransform(Capture video){
  for (int y = 0; y < video.height; ++y) {
      for (int x = 0; x < video.width; ++x) {
        //toFleshColorBinarizationIm(video, x, y);
        int index = y * video.width + x;
      
        //距離画像作成
        //左上から右下へ
        float min = brightness(video.pixels[index]);
        if (x - 1 >= 0) {
          min = min(min, brightness(video.pixels[y * video.width + (x-1)]) + 1);
        }
        if(y - 1 >= 0){
          min = min(min, brightness(video.pixels[(y-1) * video.width + x]) + 1);
        }
        pixels[index] = color(0, 0, min);

        //逆方向から
        int inv_x = video.width - 1 - x;
        int inv_y = video.height - 1 - y;
        int inv_index = inv_y * video.width + inv_x;
        min = brightness(video.pixels[inv_index]);
        if(inv_x + 1 <= video.width - 1){
          min = min(min, brightness(video.pixels[inv_y * video.width + (inv_x + 1)]) + 1);
        }
        if (inv_y + 1 <= video.height - 1){
          //println("x");
          min = min(min, brightness(video.pixels[(inv_y + 1) * video.height + inv_x]) + 1);
        }
        pixels[inv_index] = color(0, 0, min);
      }
    }
}