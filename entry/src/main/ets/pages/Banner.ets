import { common } from '@kit.AbilityKit';
import { advertising, AutoAdComponent } from '@kit.AdsKit';
import { AdConf } from '../Ad/AdConf';
import { AdIdentifier } from '../Ad/AdIdentifier';
import { AdStatus } from '../Ad/AdStatus';
import { AppConstants } from '../common/AppConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { Logger } from '../util/Logger';

const TAG = "Banner"

@Entry
@Component
struct Banner {
  @StorageProp(AppConstants.HEIGHT_SYSTEM) systemHeight: number = 0;
  @StorageProp(AppConstants.HEIGHT_NAVIGATION) navigationHeight: number = 0;
  private context = getContext(this) as common.UIAbilityContext;
  @State visibilityState: Visibility = Visibility.Visible;
  private ratio: number = 1;

  aboutToAppear() {
    AdIdentifier.requestOAIDTrackingConsentPermissions(this.context)

    this.visibilityState = Visibility.Visible;
    this.ratio = (AdConf.bannerAdReqParams.adWidth!!) / (AdConf.bannerAdReqParams.adHeight!!);
  }

  build() {
    RelativeContainer() {
      if (AdIdentifier.OAID != "") {
        Row() {
          AutoAdComponent({
            adParam: AdConf.bannerAdReqParams,
            adOptions: AdConf.adOptions,
            displayOptions: AdConf.adDisplayOptions,
            interactionListener: {
              onStatusChanged: (status: string, ad: advertising.Advertisement, data: string) => {
                Logger.info(`[${TAG}]`, `status is ${status}`);
                switch (status) {
                  case AdStatus.AD_OPEN:
                    Logger.info(`[${TAG}]`, 'Status is onAdOpen');
                    break;
                  case AdStatus.AD_CLICKED:
                    Logger.info(`[${TAG}]`, 'Status is onAdClick');
                    break;
                  case AdStatus.AD_CLOSED:
                    Logger.info(`[${TAG}]`, 'Status is onAdClose');
                    this.visibilityState = Visibility.None;
                    break;
                  case AdStatus.AD_LOAD:
                    Logger.info(`[${TAG}]`, 'Status is onAdLoad');
                    break;
                  case AdStatus.AD_FAIL:
                    Logger.error(`[${TAG}]`, 'Status is onAdFail')
                    this.visibilityState = Visibility.None;
                    break;
                }
              }
            }
          })
        }
        .aspectRatio(this.ratio)
        .visibility(this.visibilityState)
        .id("Banner")
        .width(UICommonConstants.FULL_SIZE)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      }
    }
    .height(UICommonConstants.FULL_SIZE)
    .width(UICommonConstants.FULL_SIZE)
    .padding({ top: px2vp(this.systemHeight), bottom: 0 })
  }
}