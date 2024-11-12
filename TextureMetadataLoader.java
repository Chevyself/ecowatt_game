import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Optional;
import java.util.Properties;

/**
 * Loader for texture metadata. Textures are located in './data/tiles.png'. Metadata is right next to it in './data/metadata/texture_name.properties'.
 * <p>
 * Required fields:
 * <ul>
 *   <li>key: Name of the texture</li>
 *   <li>x: x coordinate of the texture in the texture atlas</li>
 *   <li>y: y coordinate of the texture in the texture atlas</li>
 * </ul>
 * Optional animation fields:
 * <ul>
 *   Any animation (prefixed by 'animation') is an array of coordinates separated by commas ',' each separated by a semicolon ';'.
 *   For example, 'animationOn: 0,0;1,0;2,0' would be the first three frames of an animation.
 *   <li>animationOn: Animation when the object is on (looped)</li>
 *   <li>animationOff: Animation when the object is off (looped)</li>
 *   <li>animationStart: Animation when the object is starting</li>
 *   <li>animationEnd: Animation when the object is ending</li>
 *   Prefix rule does not apply to the following fields:
 *   <li>animationMirror: whether the animation should be the mirror of the declared frames</li>
 *   <li>animationSpeed: Speed of the animation (measurement to be defined)</li>
 * </ul>
 * <ul>
 *   <li>completeWithMirror: If true the texture should be mirrored on the x-axis</li>
 *   <li>rotations: number of times the texture should be rotated 90 degrees clockwise</li>
 * </ul>
 */
public class TextureMetadataLoader {

  private final HashMap<String, TextureMetadata> metadata = new HashMap<>();
  private boolean loaded = false;

  private void readMetadata(String path) {
    File metadataDir = new File(path);
    readMetadata(metadataDir);
  }

  private void readMetadata(File metadataDir) {
    if (!metadataDir.exists() || !metadataDir.isDirectory()) {
      System.err.println("Metadata directory not found. at: " + metadataDir.getAbsolutePath());
      return;
    }
    File[] files = metadataDir.listFiles();
    if (files == null) {
      System.err.println("No metadata files found.");
      return;
    }
    for (File file : files) {
      if (file.isFile() && file.getName().endsWith(".properties")) {
        loadTextureMetadata(file).ifPresent(textureMetadata -> {
          String key = textureMetadata.getKey();
          if (metadata.containsKey(key)) {
            System.err.println("Duplicate texture metadata for key: " + key);
          } else {
            metadata.put(key, textureMetadata);
          }
        });
      }
      if (file.isDirectory()) {
        readMetadata(file);
      }
    }
  }

  private Optional<TextureMetadata> loadTextureMetadata(File propertiesFile) {
    TextureMetadata metadata = null;
    try (FileReader reader = new FileReader(propertiesFile)) {
      Properties properties = new Properties();
      properties.load(reader);
      metadata = metadataFromProperties(properties);
    } catch (IOException | IllegalArgumentException e) {
      e.printStackTrace();
    }
    return Optional.ofNullable(metadata);
  }

  private TextureMetadata metadataFromProperties(Properties properties) {
    String key = properties.getProperty("key").replace(" ", "_");
    int x = Integer.parseInt(properties.getProperty("x"));
    int y = Integer.parseInt(properties.getProperty("y"));
    int rotations = Integer.parseInt(properties.getProperty("rotations", "0"));
    boolean mirror = Boolean.parseBoolean(properties.getProperty("mirror", "false"));
    ArrayList<Vector2> animationOn = parseAnimation(properties.getProperty("animationOn"));
    ArrayList<Vector2> animationOff = parseAnimation(properties.getProperty("animationOff"));
    ArrayList<Vector2> animationStart = parseAnimation(properties.getProperty("animationStart"));
    ArrayList<Vector2> animationEnd = parseAnimation(properties.getProperty("animationEnd"));
    boolean animationMirror = Boolean.parseBoolean(properties.getProperty("animationMirror", "false"));
    int animationSpeed = Integer.parseInt(properties.getProperty("animationSpeed", "0"));
    return new TextureMetadata(key, x, y, rotations, mirror, animationOn, animationOff, animationStart, animationEnd, animationMirror, animationSpeed);
  }

  private ArrayList<Vector2> parseAnimation(String animation) {
    if (animation == null) {
      return new ArrayList<>();
    }
    String[] frames = animation.split(";");
    ArrayList<Vector2> animationFrames = new ArrayList<>();
    for (String frame : frames) {
      String[] coordinates = frame.split(",");
      int x = Integer.parseInt(coordinates[0]);
      int y = Integer.parseInt(coordinates[1]);
      animationFrames.add(new Vector2(x, y));
    }
    return animationFrames;
  }

  public HashMap<String, TextureMetadata> load(String path) {
    if (loaded) {
      return metadata;
    }
    readMetadata(path);
    metadata.keySet().forEach(key -> {
      System.out.println("Loaded metadata for: " + key);
    });
    loaded = true;
    return metadata;
  }
}
