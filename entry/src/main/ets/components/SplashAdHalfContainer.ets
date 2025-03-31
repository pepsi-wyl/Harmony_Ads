import { AdComponent, advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdStatus } from '../Ad/AdStatus';
import { PagesConstants } from '../common/PagesConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { Logger } from '../util/Logger';

const TAG = "SplashAdHalfContainer";

@Entry
@Component
export struct SplashAdHalfContainer {
  ads?: Array<advertising.Advertisement>;
  adDisplayOptions?: advertising.AdDisplayOptions;

  build() {
    Column() {
      AdComponent({
        ads: this.ads,
        displayOptions: this.adDisplayOptions,
        interactionListener: {
          onStatusChanged: (status: string, ad: advertising.Advertisement, data: string) => {
            switch (status) {
              case AdStatus.AD_OPEN:
                Logger.debug(`[${TAG}]`, 'splash ad open');
                break;
              case AdStatus.AD_CLICKED:
                Logger.debug(`[${TAG}]`, 'splash ad click');
                break;
              case AdStatus.AD_CLOSED:
                Logger.debug(`[${TAG}]`, 'splash ad close');
                router.clear();
                router.replaceUrl({
                  url: PagesConstants.INDEX,
                })
                break;
            }
          }
        }
      }).width(UICommonConstants.FULL_SIZE).height(UICommonConstants.SIZE_87)

      Column() {
        Row() {
          Image($r('app.media.app_icon'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
          Text($r('app.string.app_name'))
            .fontColor($r('app.color.half_screen_splash_text_color'))
            .fontSize(16)
            .width(50)
            .height(21)
        }
        .margin({ bottom: 8 })

        Column() {
          Text($r('app.string.copyright'))
            .fontColor($r('app.color.half_screen_splash_text_color'))
            .fontSize(9)
            .height(15)
        }
      }
      .margin({
        top: 29,
        left: 16,
        right: 16
      })
    }.width(UICommonConstants.FULL_SIZE).height(UICommonConstants.FULL_SIZE)
  }
}