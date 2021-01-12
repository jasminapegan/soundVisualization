import processing.core.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import com.hamoid.*;

public AudioPlayer player;
public Minim minim;
public FFT fft;
public BeatDetect beat;
public static VideoExport videoRecorder;


// višina orodne vrstice
public float toolbarY = 20;
public  Toolbar toolbar;
private boolean stopPrev = false;

private int w = 950;
private int h = 550;
private boolean hideToolbar = false;
 
private Visualization[] visualizations;
private String song;

public void settings() {
    size(w, h, P3D);

    visualizations = new Visualization[]{
      new Circles(25, toolbarY, this),
      new Histogram(toolbarY, this),
      new Tunnel(25, toolbarY, this)
    };

    if (properties.song != null) {
      song = properties.song;
    } else {
      song = "song.mp3";
      properties.song = song;
    }
    minim = new Minim(this);
    try {
      player = minim.loadFile(song);
    } catch (Exception  e) {}
    beat = new BeatDetect(); //player.bufferSize(), player.sampleRate());
    fft = new FFT(player.bufferSize(), player.sampleRate());
    player.play();
}


public void setup() {
    surface.setResizable(true);
    //beat.setSensitivity(100);
       
    videoRecorder = new VideoExport(this, String.format("%s_%s.mp4",
                    visualizationString[properties.language], formatFilename(song)));
    
    surface.setTitle(formatFilename(song));
    PFont font = createFont("Lucida Console", 12);
    textFont(font);
    toolbar = new Toolbar(toolbarY, 100, 240, 250, 60, this, player, videoRecorder);
}

public void draw() {
    if (width < 840) {
      surface.setSize(840, width);
    }
    if (height < 200) {
      surface.setSize(200, height);
    }
    
    if (properties.resetVis) {
      visualizations = new Visualization[]{
          new Circles(25, toolbarY, this),
          new Histogram(toolbarY, this),
          new Tunnel(25, toolbarY, this)
        };
      properties.resetVis = false;
    }
    
    String songBefore = song;
    
    resized();

    if (!stopPrev) {
       for (int i=0; i<properties.visualization.length; i++) {
         if (properties.visualization[i]) {
            visualizations[i].draw();
         }
       }
    } else {
        toolbar.display(true);
    }
    
    song = properties.song;
    if (songBefore != song) {
      restart();
    }
    
    stopPrev = properties.paused;
    
    if (properties.recording) {
      videoRecorder.saveFrame();
    }
    
}

public void restart() {
  song = properties.song;
  player = null;
  minim.stop();
  minim = null;
  settings();
  setup();
}


@Override
public void mousePressed() {
    super.mousePressed();
    toolbar.onClick(this.mouseX, this.mouseY);
}

@Override
public void keyReleased() {    
    super.keyReleased();
    if (key == 'h') {
        hideToolbar = !hideToolbar;
        toolbar.hide = hideToolbar;
    }
    else if (keyCode == RIGHT) {
        player.cue(player.position() + 8000);
    }
    else if (keyCode == LEFT) {
        player.cue(player.position() - 8000);
    }
    
    
}

public void resized() {
  if (w != width || h != height) {
    w = width;
    h = height;
    toolbar.recalculate(w, h);
  }
}

String formatFilename(String f) {
  String fname = f;
  while (fname.indexOf("/") != -1) {
    fname = fname.substring(fname.indexOf("/")+1, fname.length());
  }  
  while (fname.indexOf("\\") != -1) {
    fname = fname.substring(fname.indexOf("\\")+1, fname.length());
  }
  if (fname.substring(fname.length()-4, fname.length()).equals(".mp3")) {
    fname = fname.substring(0, fname.length() - 4);
   }
   return fname;
}
