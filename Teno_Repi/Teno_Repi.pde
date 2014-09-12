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
         int pixelColor = video.pixels[y*video.width + x];

        float h = hue(pixelColor);
        float s = saturation(pixelColor);
        float v = brightness(pixelColor);

        pixels[y*video.width + x] = color(h, s, v);
        
      }
    }
    updatePixels();
    filter(BLUR);
  }
}
