import { AdComponent, advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdStatus } from '../Ad/AdStatus';
import { PagesConstants } from '../common/PagesConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { Utils } from '../util/Utils';

@Entry
@Component
export struct SplashHalfScreenAd {
  private ads: Array<advertising.Advertisement> = [];
  private adDisplayOptions?: advertising.AdDisplayOptions;

  aboutToAppear() {
    const params: Record<string, Object> = router.getParams() as Record<string, Object>;
    if (params && params.ads as Array<advertising.Advertisement> && params.adDisplayOptions as advertising.AdDisplayOptions) {
      this.ads = params.ads as Array<advertising.Advertisement>;
      this.adDisplayOptions = params.adDisplayOptions as advertising.AdDisplayOptions;
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
    PageTransitionExit({ type: RouteType.None, duration: 0 })
  }

  build() {
    Column() {
      AdComponent({
        ads: this.ads,
        displayOptions: this.adDisplayOptions,
        interactionListener: {
          onStatusChanged: (status: string, ad: advertising.Advertisement, data: string) => {
            switch (status) {
              case AdStatus.AD_OPEN:
                Utils.showToast('splash ad open');
                break;
              case AdStatus.AD_CLICKED:
                Utils.showToast('splash ad click');
                break;
              case AdStatus.AD_CLOSED:
                Utils.showToast('splash ad close');
                router.clear();
                router.replaceUrl({
                  url: PagesConstants.INDEX,
                })
                break;
            }
          }
        }
      }).width(UICommonConstants.FULL_SIZE).height(UICommonConstants.SIZE_87)

      Column({}) {
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