import { common } from '@kit.AbilityKit';
import { advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdConf } from '../Ad/AdConf';
import { AdRequest } from '../Ad/AdRequest';
import { AdRoute } from '../Ad/AdRoute';
import { AdStatus } from '../Ad/AdStatus';
import { InterstitialAdStatusHandler } from '../Ad/InterstitialAdStatusHandler';
import { RewardAdStatusHandler, RewardInfoInterface } from '../Ad/RewardAdStatusHandler';
import { AppConstants } from '../common/AppConstants';
import { PagesConstants } from '../common/PagesConstants';
import { Logger } from '../util/Logger';
import { Utils } from '../util/Utils';

const TAG = "Index"

@Entry
@Component
struct Index {
  @StorageProp(AppConstants.HEIGHT_SYSTEM) systemHeight: number = 0;
  @StorageProp(AppConstants.HEIGHT_NAVIGATION) navigationHeight: number = 0;
  private context = getContext(this) as common.UIAbilityContext;
  private adRequest: AdRequest = new AdRequest(this.context);
  private rewardAdStatusHandler: RewardAdStatusHandler = new RewardAdStatusHandler();
  private interstitialAdStatusHandler: InterstitialAdStatusHandler = new InterstitialAdStatusHandler();

  build() {
    RelativeContainer() {
      Column() {
        Button('BANNER_AD')
          .onClick(() => {
            router.pushUrl({ url: PagesConstants.BANNER })
          }).margin({ top: 15 })

        Button('NATIVE_AD')
          .onClick(() => {
            // this.adRequest.requestAd(
            //   AdConf.nativeAdVideoAdReqParams,
            //   AdConf.adOptions,
            //   AdConf.adDisplayOptions,
            //   (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
            //     AdRoute.routePage(PagesConstants.NATIVE_AD, ads, adOptions, adDisplayOptions);
            //   },
            //   (errorCode: number, errorMsg: string) => {
            //     Utils.showToast('NATIVE_AD load fail')
            //   },
            //   1000
            // )

            this.adRequest.requestAdWithMultiSlots(
              AdConf.nativeAdVideoAdReqParamsArr,
              AdConf.adOptions,
              AdConf.adDisplayOptions,
              (ads: Map<string, Array<advertising.Advertisement>>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
                let adsArr: Array<advertising.Advertisement> = [];
                ads.forEach((adsArray) => adsArr.push(...adsArray));
                AdRoute.routePage(PagesConstants.NATIVE_AD, adsArr, adOptions, adDisplayOptions);
              },
              (errorCode: number, errorMsg: string) => {
                Utils.showToast('NATIVE_AD load fail')
              },
              1000
            )
          }).margin({ top: 15 })

        Button('REWARD_AD')
          .onClick(() => {
            this.adRequest.requestAd(
              AdConf.rewardAdRequestParam,
              AdConf.adOptions,
              AdConf.adDisplayOptions,
              (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
                this.rewardAdStatusHandler.registerPPSReceiver(
                  (status: string, rewardInfo?: RewardInfoInterface) => {
                    switch (status) {
                      case AdStatus.AD_OPEN:
                        Logger.info(`[${TAG}]`, 'onAdOpen');
                        break;
                      case AdStatus.AD_CLICKED:
                        Logger.info(`[${TAG}]`, 'onAdClick');
                        break;
                      case AdStatus.AD_CLOSED:
                        Logger.info(`[${TAG}]`, 'onAdClose');
                        break;
                      case AdStatus.AD_REWARDED:
                        Logger.info(`[${TAG}]`, `onAdReward, rewardType: ${rewardInfo?.rewardType}, rewardAmount: ${rewardInfo?.rewardAmount}`);
                        break;
                      case AdStatus.AD_VIDEO_START:
                        Logger.info(`[${TAG}]`, 'onAdVideoStart');
                        break;
                      case AdStatus.AD_COMPLETED:
                        Logger.info(`[${TAG}]`, 'onAdCompleted');
                        break;
                    }
                  }
                )
                advertising.showAd(ads[0], adDisplayOptions, this.context);
              },
              (errorCode: number, errorMsg: string) => {
                Utils.showToast('REWARD_AD load fail')
              },
              1000
            )
          }).margin({ top: 15 })

        Button('INTERSTITIAL_AD')
          .onClick(() => {
            this.adRequest.requestAd(
              AdConf.interstitialAdRequestParam,
              AdConf.adOptions,
              AdConf.adDisplayOptions,
              (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
                this.interstitialAdStatusHandler.registerPPSReceiver(
                  (status: string) => {
                    switch (status) {
                      case AdStatus.AD_OPEN:
                        Logger.info(`[${TAG}]`, 'onAdOpen');
                        break;
                      case AdStatus.AD_CLICKED:
                        Logger.info(`[${TAG}]`, 'onAdClick');
                        break;
                      case AdStatus.AD_CLOSED:
                        Logger.info(`[${TAG}]`, 'onAdClose');
                        break;
                      case AdStatus.AD_VIDEO_START:
                        Logger.info(`[${TAG}]`, 'onAdVideoStart');
                        break;
                      case AdStatus.AD_COMPLETED:
                        Logger.info(`[${TAG}]`, 'onAdCompleted');
                        break;
                    }
                  }
                )
                advertising.showAd(ads[0], adDisplayOptions, this.context);
              },
              (errorCode: number, errorMsg: string) => {
                Utils.showToast('INTERSTITIAL_AD load fail')
              },
              1000
            )
          }).margin({ top: 15 })

        Button('PLACEMENT_AD')
          .onClick(() => {
            this.adRequest.requestAd(
              AdConf.placementAdRequestParam,
              AdConf.adOptions,
              AdConf.adDisplayOptions,
              (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
                AdRoute.routePage(PagesConstants.PLACEMENT_AD, ads, adOptions, adDisplayOptions);
              },
              (errorCode: number, errorMsg: string) => {
                Utils.showToast('PLACEMENT_AD load fail')
              },
              1000
            )
          }).margin({ top: 15 })
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
    .padding({ top: px2vp(this.systemHeight), bottom: px2vp(this.navigationHeight) })
  }
}