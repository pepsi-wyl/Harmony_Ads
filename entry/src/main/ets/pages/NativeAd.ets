import { AdComponent, advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { AdStatus } from '../Ad/AdStatus';
import { AppConstants } from '../common/AppConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { Utils } from '../util/Utils';

@Entry
@Component
struct NativeAd {
  @StorageProp(AppConstants.HEIGHT_SYSTEM) systemHeight: number = 0;
  @StorageProp(AppConstants.HEIGHT_NAVIGATION) navigationHeight: number = 0;
  private ads: Array<advertising.Advertisement> = [];
  private adDisplayOptions?: advertising.AdDisplayOptions;

  aboutToAppear() {
    const params: Record<string, Object> = router.getParams() as Record<string, Object>;
    if (params && params.ads as Array<advertising.Advertisement> && params.adDisplayOptions as advertising.AdDisplayOptions) {
      this.ads = params.ads as Array<advertising.Advertisement>;
      this.adDisplayOptions = params.adDisplayOptions as advertising.AdDisplayOptions;
    }
  }

  build() {
    Column() {
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.ads, (ad: advertising.Advertisement) => {
          ListItem() {
            AdComponent({
              ads: [ad],
              displayOptions: this.adDisplayOptions,
              interactionListener: {
                onStatusChanged: (status: string, ad: advertising.Advertisement, data: string) => {
                  switch (status) {
                    case AdStatus.AD_OPEN:
                      Utils.showToast('native ad open');
                      break;
                    case AdStatus.AD_CLICKED:
                      Utils.showToast('native ad click');
                      break;
                    case AdStatus.AD_CLOSED:
                      Utils.showToast('native ad close');
                      break;
                    default:
                  }
                }
              }
            }).width(UICommonConstants.FULL_SIZE).height(UICommonConstants.SIZE_50)
          }
        })
      }
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Off)
      .friction(0.6)
      .divider({
        strokeWidth: 2,
        color: Color.White,
        startMargin: 20,
        endMargin: 20
      })
      .edgeEffect(EdgeEffect.Spring)
      .width(UICommonConstants.FULL_SIZE)
      .height(UICommonConstants.FULL_SIZE)
    }
    .width(UICommonConstants.FULL_SIZE)
    .height(UICommonConstants.FULL_SIZE)
    .padding({ top: px2vp(this.systemHeight), bottom: 0 })
  }
}