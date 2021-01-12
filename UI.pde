import ddf.minim.AudioPlayer;
import processing.core.PApplet;
import processing.core.PConstants;
import com.hamoid.*;

static final String[] visualizationString = new String[]{"Vizualizacija", "Visualization"};
static final String[] fileString = new String[]{"Datoteka", "File"};
static final String[] saveString = new String[]{"Shrani", "Save"};
static final String[] recordString = new String[]{"Snemaj", "Record"};
static final String[] tonalityString = new String[]{"Tonaliteta", "Tonality"};
static final String[] minorString = new String[]{"mol", "minor"};
static final String[] majorString = new String[]{"dur", "major"};
static final String[] brightnessString = new String[]{"Svetlost", "Brightness"};
static final String[] saturationString = new String[]{"Nasičenost", "Saturation"};
static final String[] fullscreenString = new String[]{"Povečaj", "Fullscreen"};
static final String[] contrastString = new String[]{"Kontrast", "Contrast"};
static final String[] pauseString = new String[]{"Prekini", "Pause"};
static final String[] resumeString = new String[]{"Nadaljuj", "Resume"};
static final String[] languageString = new String[]{"Jezik", "Language"};
static final String[] engString = new String[]{"Angleščina", "English"};
static final String[] siString = new String[]{"Slovenščina", "Slovene"};
static final String[][] visualizationNames = new String[][]{
       new String[]{"Krogi", "Circles"},
       new String[]{"Stolpci", "Histogram"},
       new String[]{"Tunel", "Tunnel"}
};

public static Properties properties = new Properties();

public static class Toolbar {
    float theight, r, g, b, a;
    PApplet sketch;
    Button[] buttons;
    AudioPlayer player;
    VideoExport recorder;
    boolean hide;

    Toolbar(float theight, float r, float g, float b, float a, PApplet sketch, AudioPlayer player, VideoExport videoRecorder) {
        this.theight = 3 * theight / 4;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.sketch = sketch;
        this.player = player;
        this.recorder = videoRecorder;
        this.hide = false;

        buttons = new Button[7];
        float dx = sketch.width / (buttons.length + 1f);
        float space = dx / (buttons.length + 1f);
        float x = space;

        // Vizualizacija
        buttons[0] = new VisualizationButton(x, sketch.height-theight, dx, theight, visualizationString,
                sketch, r, g, b, a);
                
        // Tonaliteta
        x += dx + space;
        buttons[1] = new TonalityButton(x, sketch.height-theight, dx, theight, tonalityString,
                sketch, r, g, b, a);

        // Shrani
        x += dx + space;
        buttons[2] = new SaveButton(x, sketch.height-theight, dx, theight, recordString,
                sketch, r, g, b, a);

        // Izbor pesmi
        x += dx + space;
        buttons[3] = new FileButton(x, sketch.height-theight, dx, theight, fileString,
                sketch, r, g, b, a);

        /*/ Svetlost
        x += dx + space;
        buttons[3] = new BrightnessButton(x, sketch.height-theight, dx, theight, brightnessString,
                sketch, r, g, b, a);

        // Nasičenost
        x += dx + space;
        buttons[4] = new SaturationButton(x, sketch.height-theight, dx, theight, saturationString,
                sketch, r, g, b, a);

        // Kontrast
        x += dx + space;
        buttons[5] = new ContrastButton(x, sketch.height-theight, dx, theight, contrastString,
                sketch, r, g, b, a);
        
        // Fullscreen
        x += dx + space;
        buttons[4] = new FullscreenButton(x, sketch.height-theight, dx, theight, fullscreenString,
                sketch, r, g, b, a);
                */
                
        // progress
        x += dx + space;
        buttons[4] = new ProgressButton(x, sketch.height-theight, dx, theight,
                sketch, r, g, b, a, player);

        // Pavza
        x += dx + space;
        buttons[5] = new PauseButton(x, sketch.height-theight, dx, theight, pauseString,
                sketch, r, g, b, a, player);

        // Jezik
        x += dx + space;
        buttons[6] = new LanguageButton(x, sketch.height-theight, dx, theight, languageString,
                sketch, r, g, b, a);
                
        
    }

    void display(boolean paused) {
        if (!hide) {
          for (Button button: buttons) {
              if (button != null) {
                  button.display(paused);
              }
          }
        }
    }

    void onClick(float mx, float my) {
        if (!hide) {
            for (Button button: buttons) {
                if (button != null) {
                    button.onClick(mx, my);
                }
            }
        }
    }
    
    void recalculate(float w, float h) {
        float dx = w / (buttons.length + 1f);
        float space = dx / (buttons.length + 1f);
        
        float x = space;

        for (Button button: buttons) {
          if (button != null) {
            button.recalculate(x, h-2*theight, dx);
            
            if (button.menu != null) {
                button.menu.recalculate(x, h-2*theight, dx);
            }
            
            x += dx + space;
          }
        }
    }
}

public static class Dropdown {
  float x, y, dx, dy;
  float r, g, b, a;
  Button[] options;
  PApplet sketch;
  int option;
  boolean show;
  boolean[] optionList;
  
  Dropdown() {
    this.x = 0;
    this.y = 0;
    this.dx = 0;
    this.dy = 0;
    this.r = 0;
    this.g = 0;
    this.b = 0;
    this.a = 0;
    this.options = null;
    this.sketch = null;
    option = 0;
    optionList = null;
    show = false;
  }
  
  Dropdown(float x, float y, float dx, float dy, float r, float g, float b, float a, String[][] textOptions, PApplet sketch) {
      this.x = x;
      this.y = y;
      this.dx = dx;
      this.dy = dy;
      this.r = r;
      this.g = g;
      this.b = b;
      this.a = a;
      this.options = new Button[textOptions.length];
      this.sketch = sketch;
      this.option = 0;
      this.show = false;

      float space = dy / 10;      
      float y0 = y - dy - space;
      
      for (int i=0; i < textOptions.length; i++) {
          options[i] = new Button(x, y0, dx, dy, textOptions[i], sketch, r, g, b, a);
          y0 -= dy + space;
      }
      
      options[option].clicked = true;
  }
  
  public void onClick(float mx, float my) {    
    if (this.show) {
      
      for (int i=0; i < options.length; i++) {
          options[option].onClick(mx, my);
          
          if (options[i] != null) {
            
              boolean clickedBefore = options[i].clicked;
              options[i].onClick(mx, my);
              
              if (!clickedBefore && options[i].clicked) {
                  this.option = i;
              } else {
                  options[i].clicked = false;
              }
          }
      }
      
      for (int i=0; i < options.length; i++) {
        if (i != this.option) {
          options[i].clicked = false;
        }
      }
      
      options[this.option].clicked = true;
      
    }
  }
  
  public void display(boolean paused) {
    if (this.show) {
      for (Button button: options) {
          if (button != null) {
              button.display(paused);
          }
      }
    }
  }
  
  public void recalculate(float x, float h, float dx) {
      float space = dy / 10;      
      float y0 = h - dy - space;
      

      for (Button button: options) {
          if (button != null) {
            button.recalculate(x, y0, dx);
          }
          y0 -= dy + space;
      }
  }
}

public static class MultiDropdown extends Dropdown {
   
   MultiDropdown(float x, float y, float dx, float dy, float r, float g, float b, float a, String[][] textOptions, PApplet sketch) {
      this.x = x;
      this.y = y;
      this.dx = dx;
      this.dy = dy;
      this.r = r;
      this.g = g;
      this.b = b;
      this.a = a;
      this.options = new Button[textOptions.length];
      this.sketch = sketch;
      this.optionList = new boolean[textOptions.length];
      this.optionList[0] = true;
      this.show = false;

      float space = dy / 10;      
      float y0 = y - dy - space;
      
      for (int i=0; i < options.length; i++) {
          options[i] = new Button(x, y0, dx, dy, textOptions[i], sketch, r, g, b, a);
          y0 -= dy + space;
          options[i].clicked = optionList[i];
      }
  }
  
  @Override
  public void onClick(float mx, float my) {
    if (this.show) {

      boolean foundFirst = false;
      for (int i=0; i < options.length; i++) {
          if (options[i] != null) {
              options[i].onClick(mx, my);
              this.optionList[i] = options[i].clicked;
              
              if (!foundFirst && options[i].clicked) {
                this.option = i;
                foundFirst = true;
              }
          }
      }
      
      options[this.option].clicked = true;
    }
  }
}

public static class Button {
    float x, y, dx, dy;
    float r, g, b, a;
    String[] text;
    PApplet sketch;
    boolean clicked;
    Dropdown menu;

    Button() {
        this.x = 0f;
        this.y = 0f;
        this.dx = 0f;
        this.dy = 0f;
        this.r = 0f;
        this.g = 0f;
        this.b = 0f;
        this.a = 0f;
        this.text = null;
        this.sketch = null;
        this.menu = null;
    }

    Button(float x, float y, float dx, float dy, String[] text, PApplet sketch, float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        this.menu = null;
    }

    void display(boolean paused) {
        sketch.colorMode(RGB);
        sketch.noStroke();
        
        if (paused) {
          sketch.fill(0);
          sketch.rect(this.x, this.y, this.dx, this.dy);
        }
        
        if (this.clicked) {
            sketch.fill(250-r, 250-g, 250-b, a);
        } else {
            sketch.fill(r, g, b, a);
        }
        sketch.rect(this.x, this.y, this.dx, this.dy);
        
        if (this.clicked) {
            sketch.fill(255-r/3, 255-g/3, 255-b/3);
        } else {
            sketch.fill(r, g, b);
        }
        sketch.textMode(CENTER);
        sketch.text(this.text[properties.language], this.x+10, this.y + this.dy*0.9);//, this.dx, this.dy);
    }

    boolean mouseOver(float mx, float my) {
        return (mx >= this.x && this.x + this.dx >= mx &&
                my >= this.y && this.y + this.dy >= my);
    }

    void onClick(float mx, float my) {
        if (this.mouseOver(mx, my)) {
            this.clicked = !this.clicked;
        }
    }
    
    void recalculate(float x, float h, float dx) {
        this.x = x;
        this.y = h;
        this.dx = dx;
    }
}

public static class VisualizationButton extends Button {    
    VisualizationButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                        float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        this.menu = new MultiDropdown(x, y, dx, dy, r, g, b, a, visualizationNames, sketch);
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            menu.show = true;
        }
        menu.show = this.clicked;
        if (this.clicked) {
            menu.onClick(mx, my);
        }
        properties.visualization = menu.optionList;
        properties.firstVis = this.menu.option;
    }
    
    @Override
    void display(boolean paused) {
        super.display(paused);
        menu.display(paused);
    }
}

public static class SaveButton extends Button {
    boolean recording;
  
    SaveButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
               float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        this.recording = false;
    }
    
    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            if (this.clicked) {
              try {
                videoRecorder.startMovie();
                this.recording = true;
                this.text = saveString;
              } catch (Exception e) {
                e.printStackTrace();
              }
            } else {
              try {
                videoRecorder.endMovie();
                this.recording = false;
                this.text = recordString;
              } catch (Exception e) {
                e.printStackTrace();
              }
            }
            properties.recording = this.recording;
        }
    }
}

public static class TonalityButton extends Button {  
    TonalityButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                   float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        
        String[][] options = new String[][]{majorString, minorString};
        this.menu = new Dropdown(x, y, dx, dy, r, g, b, a, options, sketch);
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            menu.show = true;
        }
        menu.show = this.clicked;
        if (this.clicked) {
            menu.onClick(mx, my);
        }
        properties.tonality = menu.option == 0;
    }
    
    @Override
    void display(boolean paused) {
        super.display(paused);
        menu.display(paused);
    }
}

public static class BrightnessButton extends Button {
    int brightness;
  
    BrightnessButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                     float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        this.brightness = 100;
        properties.brightness = this.brightness;
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            System.out.println("brightness");
        }
    }
}

public static class SaturationButton extends Button {
    int saturation;
  
    SaturationButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                     float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        this.saturation = 100;
        properties.saturation = this.saturation;
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            System.out.println("saturation");
        }
    }
}

public static class ContrastButton extends Button {
     int contrast;
  
    ContrastButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                   float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        this.contrast = 100;
        properties.contrast = this.contrast;
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            System.out.println("contrast");
            properties.contrast = this.contrast;
        }
    }
}

public static class FullscreenButton extends Button {
  
    FullscreenButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                     float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            sketch.fullScreen();
        }
    }
}

public static class PauseButton extends Button {

    AudioPlayer player;
    boolean paused;

    PauseButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                float r, float g, float b, float a, AudioPlayer player) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        this.player = player;
        this.paused = false;
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            if (this.clicked) {
                this.text = resumeString;
                player.pause();
                this.paused = true;
            } else {
                player.play();
                this.paused = false;
                this.text = pauseString;
            }
            properties.paused = this.paused;
        }
    }
}


public static class FileButton extends Button {  
    String[] filenames = null;
    
    FileButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        /*filenames = listFileNames(sketch.dataPath("SoundVisualization"));
        println(filenames);
        String[][] textOptions = new String[filenames.length][2];
        for (int i=0; i<filenames.length; i++) {
          textOptions[i][0] = filenames[i];
          textOptions[i][1] = filenames[i];
        }
        this.menu = new Dropdown(x, y, dx, dy, r, g, b, a, textOptions, sketch);*/
    }
    // This function returns all the files in a directory as an array of Strings  
    String[] listFileNames(String dir) {
      File file = new File(dir);
      if (file.isDirectory()) {
        String names[] = file.list();
        return names;
      } else {
        // If it's not a directory
        return null;
      }
    }
    
    @Override
    void onClick(float mx, float my) {
        
        super.onClick(mx, my);
        
        /*if (this.mouseOver(mx, my)) {
            menu.show = true;
        }*/
        
        //menu.show = this.clicked;
        if (this.clicked) {
            //menu.onClick(mx, my);
            sketch.selectInput("Select file to play:", "fileSelected");
            this.clicked = false;
        }
        //properties.song = filenames[menu.option];
    }
    
    /*@Override
    void display() {
      super.display();
      menu.display();
    }*/
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    properties.song = selection.getAbsolutePath();
  }
}

public static class LanguageButton extends Button {  
    LanguageButton(float x, float y, float dx, float dy, String[] text, PApplet sketch,
                float r, float g, float b, float a) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.text = text;
        this.sketch = sketch;
        
        String[][] textOptions = new String[][]{siString, engString};
        this.menu = new Dropdown(x, y, dx, dy, r, g, b, a, textOptions, sketch);
    }

    @Override
    void onClick(float mx, float my) {
        super.onClick(mx, my);
        if (this.mouseOver(mx, my)) {
            menu.show = true;
        }
        menu.show = this.clicked;
        if (this.clicked) {
            menu.onClick(mx, my);
        }
        properties.language = menu.option;
    }
    
    @Override
    void display(boolean paused) {
      super.display(paused);
      menu.display(paused);
    }
}

public static class ProgressButton extends Button {  
  
    AudioPlayer player;
    float d;
  
    ProgressButton(float x, float y, float dx, float dy, PApplet sketch,
                float r, float g, float b, float a, AudioPlayer player) {
        this.x = x;
        this.y = y;
        this.dx = dx;
        this.dy = dy;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.sketch = sketch;
        this.player = player;
        this.d = this.dy/4;
    }

    @Override
    void onClick(float mx, float my) {
        if (this.mouseOver(mx, my)) {
            player.cue(ceil(player.length() * (mx - this.x - this.d) / (this.dx - 2*this.d)));
            properties.resetVis = true;
        }
    }
    
    @Override
    void display(boolean paused) {
        sketch.colorMode(RGB);
        //sketch.noStroke();
        sketch.stroke(10);
        
        if (paused) {
          sketch.fill(0);
          sketch.rect(this.x, this.y, this.dx, this.dy);
        }
        
        sketch.fill(r, g, b, a);
        sketch.rect(this.x, this.y, this.dx, this.dy);
        
        sketch.fill(255-r/3, 255-g/3, 255-b/3);
        sketch.stroke(255-r/3, 255-g/3, 255-b/3);
        sketch.line(this.x+this.d, this.y+this.dy/2, this.x-this.d+this.dx, this.y+this.dy/2);
        sketch.ellipse(this.x + this.d + (dx-2*this.d) * player.position() / (float) player.length(),
                this.y+this.dy/2, d, d);
        
    }
}

public static class Properties {
  int brightness, saturation, contrast, language, firstVis;
  boolean tonality, paused, recording, resetVis;
  boolean[] visualization;
  String song;
  
  Properties() {
    this.visualization = new boolean[]{true, false, false};
    this.firstVis = 0;
    this.tonality = true;
    this.brightness = 0;
    this.saturation = 0;
    this.contrast = 0;
    this.language = 0;
    this.paused = false;
    this.recording = false;
    this.song = null;
    this.resetVis = false;
  }
}
