import { Prompt } from '@kit.ArkUI';

/**
 * Utils
 */
export class Utils {
  /**
   * showToast
   */
  static showToast(message: string) {
    Prompt.showToast({
      message,
      duration: 1000
    });
  }

  /**
   * isBlank
   */
  static isBlank(str: string): boolean {
    if (str === null || str === undefined) {
      return true;
    }
    if (typeof str === 'string') {
      return str.trim().length === 0;
    }
    return false;
  }
}