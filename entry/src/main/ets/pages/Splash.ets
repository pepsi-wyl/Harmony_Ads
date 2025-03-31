import { common } from '@kit.AbilityKit';
import { advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdConf } from '../Ad/AdConf';
import { AdRequest } from '../Ad/AdRequest';
import { AdType } from '../Ad/AdType';
import { AdConstants } from '../common/AdConstants';
import { AppConstants } from '../common/AppConstants';
import { PagesConstants } from '../common/PagesConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { SplashAdFullContainer } from '../components/SplashAdFullContainer';
import { SplashAdHalfContainer } from '../components/SplashAdHalfContainer';
import { SplashView } from '../components/SplashView';
import { Logger } from '../util/Logger';

const TAG = 'Splash';

@Entry
@Component
export struct Splash {
  @StorageProp(AppConstants.HEIGHT_SYSTEM) systemHeight: number = 0;
  @StorageProp(AppConstants.HEIGHT_NAVIGATION) navigationHeight: number = 0;
  private context = getContext(this) as common.UIAbilityContext;
  private adRequest: AdRequest = new AdRequest(this.context);
  private adLoadType: number = 1; // 0 Image 1 Video
  private adShowType: number = 0; // 0 HALF  1 FULL
  @State private isShowAd: boolean = false;
  private ads: Array<advertising.Advertisement> = [];
  private adOptions: advertising.AdOptions = {};
  private adDisplayOptions: advertising.AdDisplayOptions = {};

  aboutToAppear() {
    Logger.info(`[${TAG}]`, 'aboutToAppear');
    try {
      this.adRequest.requestAd(
        this.adLoadType === 0 ? AdConf.splashAdImageAdReqParams : AdConf.splashAdVideoAdReqParams,
        AdConf.adOptions,
        AdConf.adDisplayOptions,
        (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
          if (!canIUse(AdConstants.HUAWEI_SYS_CAPABILITY_ADS)) {
            Logger.error(`[${TAG}]`, 'RequestAd HUAWEI_SYS_CAPABILITY_ADS is not supported on this device.');
            return
          }

          if (ads.length === 0 || ads[0].adType !== AdType.SPLASH_AD) {
            Logger.error(`[${TAG}]`, 'RequestAd Invalid AdType received');
            return
          }

          this.ads = ads
          this.adOptions = adOptions
          this.adDisplayOptions = adDisplayOptions
          this.isShowAd = true
        },
        (errorCode: number, errorMsg: string) => {
          Logger.error(`[${TAG}]`, `RequestAd fail code:${errorCode} msg:${errorMsg}`);
          router.pushUrl({ url: PagesConstants.INDEX });
          router.clear();
        },
        3000
      );
    } catch (error) {
      Logger.error(`${TAG}]`, `aboutToAppear catch err, code: ${error.code}, message: ${error.message}`);
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
    PageTransitionExit({ type: RouteType.None, duration: 0 })
  }

  build() {
    Stack() {
      SplashView()
      if (this.isShowAd) {
        if (this.adShowType === 0) {
          SplashAdHalfContainer({ ads: this.ads, adDisplayOptions: this.adDisplayOptions })
        } else {
          SplashAdFullContainer({ ads: this.ads, adDisplayOptions: this.adDisplayOptions })
        }
      }
    }
    .height(UICommonConstants.FULL_SIZE)
    .backgroundColor($r('app.color.start_window_background'))
  }
}