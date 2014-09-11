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
    for (int y = 0; y < video.height; ++y) {
      for (int x = 0; x < video.width; ++x) {
        // int pixelColor = video.pixels[y*video.width + x];

       // float h = hue(pixelColor);
       // float s = saturation(pixelColor);
       // float v = brightness(pixelColor);

       //  pixels[y*video.width + x] = color(h, s, v);
       medianFilter(video, x, y);
      }
    }
    updatePixels();
  }
}

void medianFilter(Capture video, int x, int y){
  if (x != 0 && y != 0 && x != video.width - 1 && y != video.height - 1) {
    float a[] = new float[9];
    a[0] = video.pixels[(y - 1) * video.width + (x - 1)];
    a[1] = video.pixels[(y - 1) * video.width + x];
    a[2] = video.pixels[(y - 1) * video.width + (x + 1)];
    a[3] = video.pixels[y * video.width + (x - 1)];
    a[4] = video.pixels[y * video.width + x];
    a[5] = video.pixels[y * video.width + (x + 1)];
    a[6] = video.pixels[(y + 1) * video.width + (x - 1)];
    a[7] = video.pixels[(y + 1) * video.width + x];
    a[8] = video.pixels[(y + 1) * video.width + (x + 1)];

    for (int i = 0; i < a.length - 1; ++i) {
      for (int j = i + 1; j < a.length; ++j) {
        if(a[i] > a[j]){
          float tmp = a[i];
          a[i] = a[j];
          a[j] = tmp;
        }
      }
    }
    set(x, y, color(a[4]));
  }
}