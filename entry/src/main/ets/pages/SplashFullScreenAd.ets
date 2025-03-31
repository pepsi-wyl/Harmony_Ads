import { AdComponent, advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdStatus } from '../Ad/AdStatus';
import { PagesConstants } from '../common/PagesConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { Utils } from '../util/Utils';

@Entry
@Component
export struct SplashFullScreenAd {
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
      }).width(UICommonConstants.FULL_SIZE).height(UICommonConstants.FULL_SIZE)
    }.width(UICommonConstants.FULL_SIZE).height(UICommonConstants.FULL_SIZE)
  }
}