import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Paths;
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
    boolean completeWithMirror = Boolean.parseBoolean(properties.getProperty("completeWithMirror", "false"));
    int[] animationOn = parseAnimation(properties.getProperty("animationOn"));
    int[] animationOff = parseAnimation(properties.getProperty("animationOff"));
    int[] animationStart = parseAnimation(properties.getProperty("animationStart"));
    int[] animationEnd = parseAnimation(properties.getProperty("animationEnd"));
    int animationSpeed = Integer.parseInt(properties.getProperty("animationSpeed", "0"));
    return new TextureMetadata(key, x, y, rotations, completeWithMirror, animationOn, animationOff, animationStart, animationEnd, animationSpeed);
  }

  private int[] parseAnimation(String animation) {
    if (animation == null) {
      return new int[0];
    }
    String[] frames = animation.split(";");
    int[] result = new int[frames.length * 2];
    for (int i = 0; i < frames.length; i++) {
      String[] coordinates = frames[i].split(",");
      result[i * 2] = Integer.parseInt(coordinates[0]);
      result[i * 2 + 1] = Integer.parseInt(coordinates[1]);
    }
    return result;
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
