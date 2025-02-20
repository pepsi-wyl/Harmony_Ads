import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { AdConstants } from '../common/AdConstants';
import { Logger } from '../util/Logger';
import { AdStatus } from './AdStatus';

const TAG = "InterstitialAdStatusHandler";

export interface RewardInfoInterface {
  rewardType: string;
  rewardAmount: number;
}

export class RewardAdStatusHandler {
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  public registerPPSReceiver(callback: (status: string, rewardInfo?: RewardInfoInterface) => void): void {
    if (this.subscriber) {
      this.unRegisterPPSReceiver();
    }

    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [AdConstants.PPS_REWARD_STATUS_CHANGED],
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

      commonEventManager.subscribe(this.subscriber, (err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventData) => {
        if (err) {
          Logger.error(`[${TAG}]`, `Subscribe error, code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(`[${TAG}]`, 'Subscribe data');
          const status: string = commonEventSubscriber?.parameters?.[AdConstants.KEY_REWARD_STATUS];
          if (callback) {
            callback(status, this.getRewardInfo(status, commonEventSubscriber));
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

  private getRewardInfo(status: string, commonEventSubscriber: commonEventManager.CommonEventData): RewardInfoInterface | undefined {
    switch (status) {
      case AdStatus.AD_REWARDED:
        const rewardData: Record<string, string | number> = commonEventSubscriber?.parameters?.[AdConstants.KEY_REWARD_DATA];
        const rewardType: string = rewardData?.rewardType as string;
        const rewardAmount: number = rewardData?.rewardAmount as number;
        return { rewardType, rewardAmount };
    }
    return undefined;
  }

  public unRegisterPPSReceiver(): void {
    commonEventManager.unsubscribe(this.subscriber, (err: BusinessError) => {
      if (err) {
        Logger.error(`[${TAG}]`, `Unsubscribe error, code: ${err.code}, message: ${err.message}`);
      } else {
        Logger.info(`[${TAG}]`, 'Succeeded in unsubscribing');
        this.subscriber = null;
      }
    });
  }
}