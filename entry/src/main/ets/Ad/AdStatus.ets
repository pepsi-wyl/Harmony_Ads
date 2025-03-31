/**
 * AdStatus
 */
export enum AdStatus {
  AD_LOAD = 'onAdLoad',
  AD_FAIL = 'onAdFail',
  AD_OPEN = 'onAdOpen',
  AD_CLICKED = 'onAdClick',
  AD_CLOSED = 'onAdClose',
  AD_REWARDED = 'onAdReward',
  AD_VIDEO_START = 'onVideoPlayBegin',
  AD_COMPLETED = 'onVideoPlayEnd',
  AD_PORTRAIT = 'onPortrait',
  AD_LANDSCAPE = 'onLandscape',
  AD_VIP_CLICKED = 'onVipClicked',
  AD_MEDIA_PROGRESS = 'onMediaProgress',
  AD_MEDIA_START = 'onMediaStart',
  AD_MEDIA_PAUSE = 'onMediaPause',
  AD_MEDIA_STOP = 'onMediaStop',
  AD_MEDIA_COMPLETE = 'onMediaComplete',
  AD_MEDIA_ERROR = 'onMediaError',
  AD_MEDIA_COUNTDOWN = 'onMediaCountdown',
}