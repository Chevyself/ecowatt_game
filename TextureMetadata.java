import java.util.ArrayList;

/**
 * Loaded texture metadata.
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
 *   <li>mirror: whether the texture should be mirrored</li>
 *   <li>rotations: number of times the texture should be rotated 90 degrees clockwise</li>
 * </ul>
 */

public class TextureMetadata {
  private final String key;
  private final int x;
  private final int y;
  private final int rotations;
  private final boolean mirror;
  private final ArrayList<Vector2> animationOn;
  private final ArrayList<Vector2> animationOff;
  private final ArrayList<Vector2> animationStart;
  private final ArrayList<Vector2> animationEnd;
  private final boolean animationMirror;
  private final int animationSpeed;

  public TextureMetadata(String key, int x, int y, int rotations, boolean mirror, ArrayList<Vector2> animationOn, ArrayList<Vector2> animationOff, ArrayList<Vector2> animationStart, ArrayList<Vector2> animationEnd, boolean animationMirror, int animationSpeed) {
    this.key = key;
    this.x = x;
    this.y = y;
    this.rotations = rotations;
    this.mirror = mirror;
    this.animationOn = animationOn;
    this.animationOff = animationOff;
    this.animationStart = animationStart;
    this.animationEnd = animationEnd;
    this.animationMirror = animationMirror;
    this.animationSpeed = animationSpeed;
  }

  public String getKey() {
    return key;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public int getRotations() {
    return rotations;
  }

  public boolean isMirror() {
    return mirror;
  }

  public ArrayList<Vector2> getAnimationOn() {
    return animationOn;
  }

  public ArrayList<Vector2> getAnimationOff() {
    return animationOff;
  }

  public ArrayList<Vector2> getAnimationStart() {
    return animationStart;
  }

  public ArrayList<Vector2> getAnimationEnd() {
    return animationEnd;
  }

  public boolean isAnimationMirror() {
    return animationMirror;
  }

  public int getAnimationSpeed() {
    return animationSpeed;
  }
}
