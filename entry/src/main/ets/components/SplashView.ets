import { AppConstants } from '../common/AppConstants';
import { UICommonConstants } from '../common/UICommonConstants';

const TAG = "SplashView";

@Entry
@Component
export struct SplashView {
  @StorageProp(AppConstants.HEIGHT_SYSTEM) systemHeight: number = 0;
  @StorageProp(AppConstants.HEIGHT_NAVIGATION) navigationHeight: number = 0;
  @State name: string = '鲸鸿';
  @State title: string = '开屏广告';

  build() {
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
    }
    .width(UICommonConstants.FULL_SIZE)
    .height(UICommonConstants.FULL_SIZE)
    .justifyContent(FlexAlign.Center)
    .padding({ top: px2vp(this.systemHeight), bottom: px2vp(this.navigationHeight) })
  }
}