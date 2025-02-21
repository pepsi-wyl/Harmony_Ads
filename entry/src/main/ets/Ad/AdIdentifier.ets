import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { identifier } from '@kit.AdsKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AdConstants } from '../common/AdConstants';
import { Logger } from '../util/Logger';

let TAG = "AdIdentifier"

/**
 * 匿名设备标识符（Open Anonymous Device Identifier, OAID)
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V14/oaid-service-V14
 */
export class AdIdentifier {
  static OAID = ""

  static requestOAIDTrackingConsentPermissions(context: common.Context): void {
    try {
      // 如果OAID已存在，则无需请求
      if (AdIdentifier.OAID != "") {
        Logger.info(`[${TAG}]`, 'OAID already exists, no need to request permission.');
        return
      }

      // 请求权限,获取OAID
      abilityAccessCtrl
        .createAtManager()
        .requestPermissionsFromUser(context, [AdConstants.HUAWEI_PERMISSION_APP_TRACKING_CONSENT])
        .then((data) => {
          if (data.authResults[0] === 0) {
            Logger.info(`[${TAG}]`, 'succeeded in requesting permission');
            identifier.getOAID().then((data: string) => {
              AdIdentifier.OAID = data;
              Logger.info(`[${TAG}]`, `succeeded in getting adsIdentifierInfo by promise.`);
            }).catch((error: BusinessError) => {
              Logger.error(`[${TAG}]`, `getAdsIdentifierInfo failed, message: ${error.message}`);
            })
          } else {
            Logger.info(`[${TAG}]`, 'user rejected');
          }
        })
        .catch((err: BusinessError) => {
          Logger.error(`[${TAG}]`, `request permission failed, error: ${err.code} ${err.message}`);
        })
    } catch (err) {
      Logger.error(`[${TAG}]`, `catch err, code: ${err.code}, msg: ${err.message}`);
    }
  }
}