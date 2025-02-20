import { advertising } from '@kit.AdsKit'
import { AdType } from './AdType'

export class AdConf {
  static adOptions: advertising.AdOptions = {
    totalDuration: 30, // 在AdOptions中添加totalDuration参数，用于设置贴片广告展示时长（贴片广告必填）
    placementAdCountDownDesc: encodeURI('VIP免广告'), // 在AdOptions中添加placementAdCountDownDesc参数，设置贴片广告倒计时文案（可选，填写了则展示文案，不填写则只展示倒计时）
    nonPersonalizedAd: 1, // 设置是否请求非个性化广告
    allowMobileTraffic: 0, // 是否允许流量下载  0不允许 1允许，不设置以广告主设置为准
    tagForChildProtection: -1, // 是否希望根据 COPPA 的规定将您的内容视为面向儿童的内容，: -1默认值，不确定 0不希望 1希望
    tagForUnderAgeOfPromise: -1, // 是否希望按适合未达到法定承诺年龄的欧洲经济区 (EEA) 用户的方式处理该广告请求 -1默认值，不确定 0不希望 1希望
    adContentClassification: 'A', // 设置广告内容分级上限: W: 3+,所有受众 PI: 7+,家长指导 J:12+,青少年 A: 16+/18+，成人受众
  }
  static adDisplayOptions: advertising.AdDisplayOptions = {
    mute: true, // 是否静音，默认不静音
    refreshTime: 30000, // 广告轮播的时间间隔，单位ms，取值范围[30000, 120000]
  }
  static splashAdVideoAdReqParams: advertising.AdRequestParams = {
    adId: 'testd7c5cewoj6',
    adType: AdType.SPLASH_AD,
    adCount: 1
  }
  static splashAdImageAdReqParams: advertising.AdRequestParams = {
    adId: 'testq6zq98hecj',
    adType: AdType.SPLASH_AD,
    adCount: 1
  }
  static bannerAdReqParams: advertising.AdRequestParams = {
    adId: 'testw6vs28auh3',
    adType: AdType.BANNER_AD,
    adCount: 1,
    adWidth: 360,
    adHeight: 57,
  }
  static nativeAdVideoAdReqParams: advertising.AdRequestParams = {
    adId: 'testu7m3hc4gvm',
    adType: AdType.NATIVE_AD,
    adCount: 1,
    enableDirectReturnVideoAd: true,
  }
  static nativeAdVideoAdReqParamsArr: advertising.AdRequestParams[] = [{
    adId: 'testy63txaom86',
    adType: AdType.NATIVE_AD,
    adCount: 1,
    enableDirectReturnVideoAd: true,
  }, {
    adId: 'testu7m3hc4gvm',
    adType: AdType.NATIVE_AD,
    adCount: 1,
    enableDirectReturnVideoAd: true,
  }, {
    adId: 'testb65czjivt9',
    adType: AdType.NATIVE_AD,
    adCount: 1,
    enableDirectReturnVideoAd: true,
  }, {
    adId: 'testr6w14o0hqz',
    adType: AdType.NATIVE_AD,
    adCount: 1,
    enableDirectReturnVideoAd: true,
  }]
  static rewardAdRequestParam: advertising.AdRequestParams = {
    adType: AdType.REWARD_AD,
    adId: 'testx9dtjwj8hp',
  };
  static interstitialAdRequestParam: advertising.AdRequestParams = {
    adType: AdType.INTERSTITIAL_AD,
    adId: 'testb4znbuh3n2',
  };
  static placementAdRequestParam: advertising.AdRequestParams = {
    adType: AdType.PLACEMENT_AD,
    adId: 'testy3cglm3pj0',
    isPreload: false,
  };
}