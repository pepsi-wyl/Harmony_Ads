import { AdComponent, advertising } from '@kit.AdsKit';
import { router, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AdStatus } from '../Ad/AdStatus';
import { AppConstants } from '../common/AppConstants';
import { UICommonConstants } from '../common/UICommonConstants';
import { Logger } from '../util/Logger';
import { Utils } from '../util/Utils';

const TAG = "PlacementAd"

@Entry
@Component
struct PlacementAd {
  @StorageProp(AppConstants.HEIGHT_SYSTEM) systemHeight: number = 0;
  @StorageProp(AppConstants.HEIGHT_NAVIGATION) navigationHeight: number = 0;
  private ads: Array<advertising.Advertisement> = [];
  private adOptions?: advertising.AdOptions;
  private adDisplayOptions?: advertising.AdDisplayOptions;
  @State isPlayVideo: boolean = false;
  @State countDownTxt: string = '';
  private countDownTxtPlaceholder: string = '%d | %s';
  private portrait: boolean = true;
  private playedAdSize: number = 0;
  private controller: VideoController = new VideoController();
  private previewUris: Resource = $r('app.media.video_preview');
  private innerResource: Resource = $rawfile('videoTest.mp4');

  aboutToAppear() {
    const params: Record<string, Object> = router.getParams() as Record<string, Object>;
    if (params && params.ads as Array<advertising.Advertisement> && params.adOptions as advertising.AdOptions && params.adDisplayOptions as advertising.AdDisplayOptions) {
      this.ads = params.ads as Array<advertising.Advertisement>;
      this.adOptions = params.adOptions as advertising.AdOptions;
      this.adDisplayOptions = params.adDisplayOptions as advertising.AdDisplayOptions;
      this.initCountDownText();
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      AdComponent({
        ads: this.ads,
        displayOptions: this.adDisplayOptions,
        interactionListener: {
          onStatusChanged: (status: string, ad: advertising.Advertisement, data: string) => {
            switch (status) {
              case AdStatus.AD_PORTRAIT:
                Logger.info(`[${TAG}]]`, 'Status is onPortrait');
                this.setWindowPortrait();
                break;
              case AdStatus.AD_LANDSCAPE:
                Logger.info(`[${TAG}]]`, 'Status is onLandscape');
                this.setWindowLandscape();
                break;
              case AdStatus.AD_MEDIA_PROGRESS:
                Logger.info(`[${TAG}]]`, 'Status is onMediaProgress');
                break;
              case AdStatus.AD_MEDIA_START:
                Logger.info(`[${TAG}]]`, 'Status is onMediaStart');
                break;
              case AdStatus.AD_MEDIA_PAUSE:
                Logger.info(`[${TAG}]]`, 'Status is onMediaPause');
                break;
              case AdStatus.AD_MEDIA_STOP:
                Logger.info(`[${TAG}]]`, 'Status is onMediaStop');
                break;
              case AdStatus.AD_MEDIA_COMPLETE:
                Logger.info(`[${TAG}]]`, 'Status is onMediaComplete');
                this.playedAdSize++;
                if (this.playedAdSize === this.ads.length) {
                  this.isPlayVideo = true;
                }
                break;
              case AdStatus.AD_MEDIA_ERROR:
                Logger.error(`[${TAG}]]`, 'Status is onMediaError');
                break;
              case AdStatus.AD_MEDIA_COUNTDOWN:
                try {
                  Logger.info(`[${TAG}]]`, 'Status is onMediaCountdown');
                  const parseData: Record<string, number> = JSON.parse(JSON.stringify(data));
                  this.updateCountDownTxt(parseData.countdownTime);
                } catch (e) {
                  Logger.error(`[${TAG}]]`, `Failed to parse data, code: ${e.code}, msg: ${e.message}`);
                }
                break;
            }
          }
        }
      }).visibility(!this.isPlayVideo ? Visibility.Visible : Visibility.None).width(UICommonConstants.FULL_SIZE).aspectRatio(16 / 9)

      Row() {
        if (this.countDownTxt) {
          Text(this.countDownTxt.split('').join('\u200B'))
            .fontSize(12)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .lineHeight(12)
            .height(24)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .backgroundColor('#66000000')
            .border({ radius: 25 })
            .padding({
              left: 8,
              right: 8,
              top: 6,
              bottom: 6
            })
            .margin({ right: 16, top: 16 })
            .constraintSize({ minWidth: 60, maxWidth: 100 })
            .onClick((event: ClickEvent) => {
              Logger.info(`[${TAG}]]`, 'OnVipClicked, do something...');
            })
        }
      }
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.End)

      Video({
        src: this.innerResource,
        previewUri: this.previewUris,
        controller: this.controller
      })
        .visibility(this.isPlayVideo ? Visibility.Visible : Visibility.None)
        .autoPlay(this.isPlayVideo ? true : false)
        .controls(false)
        .width(UICommonConstants.FULL_SIZE)
        .aspectRatio(16 / 9)
    }
    .width(UICommonConstants.FULL_SIZE).height(UICommonConstants.FULL_SIZE).padding({ top: px2vp(this.systemHeight), bottom: px2vp(this.navigationHeight) })
  }

  /**
   * 设置竖屏或返回上一页
   */
  private setWindowPortrait() {
    Logger.info(`[${TAG}]]`, `Set WindowPortrait, portrait: ${this.portrait}`);
    if (!this.portrait) {
      window.getLastWindow(getContext(this), (err: BusinessError, win) => {
        win.setPreferredOrientation(window.Orientation.PORTRAIT)
      });
      this.portrait = true;
    } else {
      router.back();
    }
  }

  /**
   * 设置横屏（正向）
   */
  private setWindowLandscape() {
    Logger.info(`[${TAG}]]`, `Set WindowLandscape, portrait: ${this.portrait}`);
    if (this.portrait) {
      window.getLastWindow(getContext(this), (err: BusinessError, win) => {
        win.setPreferredOrientation(window.Orientation.LANDSCAPE)
      });
      this.portrait = false;
    }
  }

  private initCountDownText() {
    const decodeText = decodeURIComponent((this.adOptions?.placementAdCountDownDesc as string).replace(/\+/g, '%20'));
    if (!Utils.isBlank(decodeText)) {
      this.countDownTxtPlaceholder = this.countDownTxtPlaceholder.replace('%s', decodeText);
    } else {
      this.countDownTxtPlaceholder = '%d';
    }
  }

  private updateCountDownTxt(leftTime: number) {
    Logger.info(`[${TAG}]]`, `Show LeftTime: ${leftTime}`);
    this.countDownTxt = this.countDownTxtPlaceholder.replace('%d', leftTime + '');
  }
}