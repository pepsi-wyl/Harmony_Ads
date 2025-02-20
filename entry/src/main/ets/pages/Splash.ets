import { common } from '@kit.AbilityKit';
import { advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdConf } from '../Ad/AdConf';
import { AdRequest } from '../Ad/AdRequest';
import { AdRoute } from '../Ad/AdRoute';
import { AdType } from '../Ad/AdType';
import { AppConstants } from '../common/AppConstants';
import { PagesConstants } from '../common/PagesConstants';
import { Logger } from '../util/Logger';

const TAG = 'Splash';

@Entry
@Component
export struct Splash {
  @StorageProp(AppConstants.HEIGHT_SYSTEM) systemHeight: number = 0;
  @StorageProp(AppConstants.HEIGHT_NAVIGATION) navigationHeight: number = 0;
  private context = getContext(this) as common.UIAbilityContext;
  private adRequest: AdRequest = new AdRequest(this.context);

  aboutToAppear() {
    try {
      // this.adRequest.requestAd(
      //   AdConf.splashAdVideoAdReqParams,
      //   AdConf.adOptions,
      //   AdConf.adDisplayOptions,
      //   (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
      //     // 保存请求到的广告内容用于展示
      //     if (canIUse('SystemCapability.Advertising.Ads')) {
      //       if (ads[0].adType === AdType.SPLASH_AD) {
      //         // 调用开屏广告展示页面
      //         if (ads[0]?.isFullScreen === true) {
      //           AdRoute.routePage(PagesConstants.SPLASH_FULL_SCREEN, ads, adOptions, adDisplayOptions);
      //         } else {
      //           AdRoute.routePage(PagesConstants.SPLASH_HALF_SCREEN, ads, adOptions, adDisplayOptions);
      //         }
      //
      //         router.clear();
      //       } else {
      //         Logger.info(`[${TAG}]`, 'error adType');
      //       }
      //     }
      //   },
      //   (errorCode: number, errorMsg: string) => {
      //     router.pushUrl({ url: PagesConstants.INDEX });
      //     router.clear();
      //   },
      //   5000
      // );
      this.adRequest.requestAd(
        AdConf.splashAdImageAdReqParams,
        AdConf.adOptions,
        AdConf.adDisplayOptions,
        (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => {
          // 保存请求到的广告内容用于展示
          if (canIUse('SystemCapability.Advertising.Ads')) {
            if (ads[0].adType === AdType.SPLASH_AD) {
              // 调用开屏广告展示页面
              // if (ads[0]?.isFullScreen === true) {
              //   AdRoute.routePage(PagesConstants.SPLASH_FULL_SCREEN, ads, adOptions, adDisplayOptions);
              // } else {
              //   AdRoute.routePage(PagesConstants.SPLASH_HALF_SCREEN, ads, adOptions, adDisplayOptions);
              // }
              AdRoute.routePage(PagesConstants.SPLASH_FULL_SCREEN, ads, adOptions, adDisplayOptions);
              router.clear();
            } else {
              Logger.info(`[${TAG}]`, 'error adType');
            }
          }
        },
        (errorCode: number, errorMsg: string) => {
          router.pushUrl({ url: PagesConstants.INDEX });
          router.clear();
        },
        5000
      );
    } catch (error) {
      Logger.error(`${TAG}]`, `catch err, code: ${error.code}, message: ${error.message}`);
    }
    Logger.info(`[${TAG}]`, 'aboutToAppear');
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
    PageTransitionExit({ type: RouteType.None, duration: 0 })
  }

  @State name: string = '鲸鸿'
  @State title: string = '开屏广告'

  build() {
    Stack() {
      Column() {
        Row() {
          Text(this.name)
            .fontSize(45)
            .fontWeight(FontWeight.Bold)
            .width(45)
          Text(this.title)
            .fontSize(20)
            .fontWeight(FontWeight.Normal)
            .width(25)
            .markAnchor({ x: -20, y: -80 })
        }
      }.width('100%')
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ top: px2vp(this.systemHeight), bottom: px2vp(this.navigationHeight) })
  }
}