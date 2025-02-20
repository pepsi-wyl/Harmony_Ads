import { hilog } from '@kit.PerformanceAnalysisKit';

// Logger 常量
const LOGGER_DOMAIN: number = 0x8888;
const LOGGER_TAG: string = 'APP';

/**
 * Logger
 */
export class Logger {
  private static domain: number = LOGGER_DOMAIN;
  private static tag: string = LOGGER_TAG;
  private static format: string = '%{public}s, %{public}s';
  private static showLog: boolean = true;

  /**
   * 是否打印日志 该方法在Ability里调用
   * @param showLog
   */
  static setShowLog(showLog: boolean = true) {
    Logger.showLog = showLog
  }

  /**
   * 打印DEBUG级别日志
   * @param args
   */
  static debug(...args: string[]): void {
    if (Logger.showLog) {
      hilog.debug(Logger.domain, Logger.tag, Logger.format, args);
    }
  }

  /**
   * 打印INFO级别日志
   * @param args
   */
  static info(...args: string[]): void {
    if (Logger.showLog) {
      hilog.info(Logger.domain, Logger.tag, Logger.format, args);
    }
  }

  /**
   * 打印WARN级别日志
   * @param args
   */
  static warn(...args: string[]): void {
    if (Logger.showLog) {
      hilog.warn(Logger.domain, Logger.tag, Logger.format, args);
    }
  }

  /**
   * 打印ERROR级别日志
   * @param args
   */
  static error(...args: string[]): void {
    if (Logger.showLog) {
      hilog.error(Logger.domain, Logger.tag, Logger.format, args);
    }
  }

  /**
   * 打印FATAL级别日志
   * @param args
   */
  static fatal(...args: string[]): void {
    if (Logger.showLog) {
      hilog.fatal(Logger.domain, Logger.tag, Logger.format, args);
    }
  }
}