import { AdComponent, advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdStatus } from '../Ad/AdStatus';
import { PagesConstants } from '../common/PagesConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { Logger } from '../util/Logger';

const TAG = "SplashAdFullContainer";

@Entry
@Component
export struct SplashAdFullContainer {
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
      }).width(UICommonConstants.FULL_SIZE).height(UICommonConstants.FULL_SIZE)
    }.width(UICommonConstants.FULL_SIZE).height(UICommonConstants.FULL_SIZE).justifyContent(FlexAlign.Center)
  }
}