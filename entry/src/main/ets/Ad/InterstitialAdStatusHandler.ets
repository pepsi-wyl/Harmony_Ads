import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { AdConstants } from '../common/AdConstants';
import { Logger } from '../util/Logger';
import { AdStatus } from './AdStatus';

const TAG = "InterstitialAdStatusHandler";

export class InterstitialAdStatusHandler {
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  public registerPPSReceiver(callback: (status: string) => void): void {
    if (this.subscriber) {
      this.unRegisterPPSReceiver();
    }

    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [AdConstants.PPS_INTERSTITIAL_STATUS_CHANGED],
      publisherBundleName: AdConstants.HUAWEI_HMS_ADS_SERVICE,
    };

    commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
      if (err) {
        Logger.error(`[${TAG}]`, `CreateSubscriber error, ${err.code}, message: ${err.message}}`);
        return;
      }

      Logger.info(`[${TAG}]`, 'Succeeded in creating subscriber');
      this.subscriber = commonEventSubscriber;

      if (!this.subscriber) {
        Logger.warn(`[${TAG}]`, 'Need to create subscriber');
        return;
      }

      commonEventManager.subscribe(this.subscriber, (err: BusinessError, commonEventData: commonEventManager.CommonEventData) => {
        if (err) {
          Logger.error(`[${TAG}]`, `Subscribe error, ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(`[${TAG}]`, 'Succeeded subscribing data');
          const status: string = commonEventData?.parameters?.[AdConstants.KEY_INTERSTITIAL_STATUS];

          if (callback) {
            callback(status);
          }
          switch (status) {
            case AdStatus.AD_CLOSED:
              Logger.info(`[${TAG}]`, 'onAdClose');
              this.unRegisterPPSReceiver();
              break;
          }
        }
      });
    });
  }

  public unRegisterPPSReceiver(): void {
    commonEventManager.unsubscribe(this.subscriber, (err: BusinessError) => {
      if (err) {
        Logger.error(`[${TAG}]`, `Unsubscribe error, ${err.code}, message: ${err.message}}`);
      } else {
        Logger.info(`[${TAG}]`, 'Succeeded in unsubscribing');
        this.subscriber = null;
      }
    });
  }
}