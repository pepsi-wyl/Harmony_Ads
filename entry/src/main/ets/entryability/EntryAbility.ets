import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AppConstants } from '../common/AppConstants';
import { PagesConstants } from '../common/PagesConstants';
import { Logger } from '../util/Logger';

let TAG = 'EntryAbility'

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(`[${TAG}]`, 'Ability onCreate');
  }

  onDestroy(): void {
    Logger.info(`[${TAG}]`, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(`[${TAG}]`, 'Ability onWindowStageCreate');

    windowStage.loadContent(PagesConstants.SPLASH, (err) => {
      if (err.code) {
        Logger.error(`[${TAG}]`, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info(`[${TAG}]`, 'Succeeded in loading the content.');

      // 获取应用主窗口
      let windowClass: window.Window = windowStage.getMainWindowSync();

      // 设置窗口全屏
      windowClass.setWindowLayoutFullScreen(true).then(() => {
        Logger.info(`[${TAG}]`, 'Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(`[${TAG}]`, 'Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });
      // 获取避让区域数据
      AppStorage.setOrCreate(AppConstants.HEIGHT_SYSTEM, windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height);
      AppStorage.setOrCreate(AppConstants.HEIGHT_NAVIGATION, windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height);
      // 注册监听函数，动态获取避让区域数据
      windowClass.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.setOrCreate(AppConstants.HEIGHT_SYSTEM, data.area.topRect.height);
        } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          AppStorage.setOrCreate(AppConstants.HEIGHT_NAVIGATION, data.area.bottomRect.height);
        }
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(`[${TAG}]`, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(`[${TAG}]`, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(`[${TAG}]`, 'Ability onBackground');
  }
}
