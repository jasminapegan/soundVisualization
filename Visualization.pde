// zone spektra - kolikšen delež
private float specLow = 0.03f;  // 3%
private float specMid = 0.125f;  // 12.5%
private float specHi = 0.20f;   // 20%
// Ostalih 64% spektra ni uporabljenih - neslišni

// score points za zone
private float scoreLow = 0;
private float scoreMid = 0;
private float scoreHi = 0;
private float scoreGlobal = 0;

// Predhodna vrednost
private float oldScoreLow = scoreLow;
private float oldScoreMid = scoreMid;
private float oldScoreHi = scoreHi;

// Vrednost zmanjšanja
private float scoreDecreaseRate = 25;

// glavna frekvenca
private float freqLoudest;
private float freqMax;
private float[] freqs = new float[64];

private float[] beats = new float[32];


public float[] prevAmplitudes = new float[1024];

public class Visualization {
  float toolbarY;
  PApplet sketch;
  int idx;
  float speedBeats;
  float speed;
  
  public void settings() {}
  
  public void draw() {
      fft.forward(player.mix);
      
      beat.detect(player.mix);
      if (beat.isOnset()) {
        shift(beats);
        beats[beats.length-1] = player.position();
        this.speedBeats = max(3, avgDiff(beats)/30);
        if (Float.isNaN(this.speedBeats)) {
          this.speedBeats = 3;
        }
        println(speedBeats);
      }

      oldScoreLow = scoreLow;
      oldScoreMid = scoreMid;
      oldScoreHi = scoreHi;

      scoreLow = 0;
      scoreMid = 0;
      scoreHi = 0;

      freqLoudest = 0;
      freqMax = 0;

      for (int i = 0; i < fft.specSize() * specLow; i++) {
          scoreLow += fft.getBand(i);
          if (freqLoudest < fft.getBand(i)) {
            freqLoudest = fft.getBand(i);
            freqMax = fft.indexToFreq(i);
          }
          
          shift(freqs);
          freqs[freqs.length-1] = freqMax;
          
          shift(prevAmplitudes);
          prevAmplitudes[prevAmplitudes.length-1] = fft.getBand(i);
          speed = max(speedBeats/40, avg(prevAmplitudes));
      }
      
      //shift(prevAmplitudes);
      //prevAmplitudes[prevAmplitudes.length-1] = player.mix.level();
      //speed = max(speedBeats, avg(prevAmplitudes));
      //println(speed);

      for (int i = (int) (fft.specSize() * specLow); i < fft.specSize() * specMid; i++) {
          scoreMid += fft.getBand(i);
      }

      for (int i = (int) (fft.specSize() * specMid); i < fft.specSize() * specHi; i++) {
          scoreHi += fft.getBand(i); 
      }

      if (oldScoreLow > scoreLow) {
          scoreLow = oldScoreLow - scoreDecreaseRate;
      }

      if (oldScoreMid > scoreMid) {
          scoreMid = oldScoreMid - scoreDecreaseRate;
      }

      if (oldScoreHi > scoreHi) {
          scoreHi = oldScoreHi - scoreDecreaseRate;
      }
 
      scoreGlobal = 0.66f * scoreLow + 0.8f * scoreMid + 1f * scoreHi;

      // actually start drawing
      if (idx == properties.firstVis) {
        sketch.background(scoreLow / 100, scoreMid / 100, scoreHi / 100);
        toolbar.display(false);
      }
      
  }
}


public class Circles extends Visualization {
  Circle[] circles;
  int nCircles;
  
  Circles(int nCircles, float toolbarY, PApplet sketch) {
      this.nCircles = nCircles;
      this.toolbarY = toolbarY;
      this.sketch = sketch;
      this.speed = 0;
      this.idx = 0;
      
      circles = new Circle[nCircles];
      for (int i=0; i < nCircles; i++) {
          circles[i] = new Circle(sketch, toolbarY);
      }
  }
  
  public void draw() {
      
      super.draw();
         
      float[] spec = new float[fft.specSize()];
      for (int i=0; i < fft.specSize(); i++) {
            spec[i] = fft.getBand(i);
      }
      for (int i = 0; i < nCircles; i++) {
          float bandValue = (speed/2 + fft.getBand(i) % 255)/2;
          
          if (circles[i] != null) {
              circles[i].display(bandValue, properties.tonality, this.speed); //((float)freqMaxIndex)/fft.specSize());
              //circles[i].display(player.mix.level(), properties.tonality, this.speed);
          } //<>//
      }
  } 
}


public class Histogram extends Visualization {
  Spectrum spectrum;
  
  Histogram(float toolbarY, PApplet sketch) {
      this.toolbarY = toolbarY;
      this.sketch = sketch;
      this.spectrum = new Spectrum(sketch, width/2, height/2, 200, height);
      this.idx = 1;
  }
  
  public void draw() {
    
      super.draw();
           
      float[] spec = new float[fft.specSize()];
      for (int i=0; i < fft.specSize(); i++) {
            spec[i] = fft.getBand(i);
      }
      spectrum.display(10*avg(spec), properties.tonality, spec);
      //spectrum.display(player.mix.level(), properties.tonality, spec);
  }
  
}

public class Tunnel extends Visualization {
  Wall[] walls;
  int nWalls;
  
  Tunnel(int nWalls, float toolbarY, PApplet sketch) {
      this.nWalls = nWalls;
      this.toolbarY = toolbarY;
      this.sketch = sketch;
      this.idx = 2;
      
      this.walls = new Wall[nWalls];
      
      // levi zidovi
      for (int i = 0; i < nWalls; i++) {
       walls[i] = new Wall(sketch);
      }
  }
  
  public void draw() {
    
      super.draw();
      
      for(int i = 0; i < nWalls; i++)
      {
          float intensity = (speed/2 + fft.getBand(i) % 255)/3;
          walls[i].display(intensity, properties.tonality, this.speed);
      }
      
  }
  
}
