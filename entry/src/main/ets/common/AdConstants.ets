/**
 * AdConstants
 */
export class AdConstants {
  static readonly TIME_OUT_CODE = 10001;
  static readonly TIME_OUT_DURATION = 3 * 1000;
  static readonly KEY_REWARD_DATA = "reward_ad_data";
  static readonly KEY_REWARD_STATUS = "reward_ad_status";
  static readonly KEY_INTERSTITIAL_STATUS = 'interstitial_ad_status';
  static readonly PPS_REWARD_STATUS_CHANGED = "com.huawei.hms.pps.action.PPS_REWARD_STATUS_CHANGED"
  static readonly PPS_INTERSTITIAL_STATUS_CHANGED = "com.huawei.hms.pps.action.PPS_INTERSTITIAL_STATUS_CHANGED";
  static readonly HUAWEI_HMS_ADS_SERVICE = "com.huawei.hms.adsservice";
  static readonly HUAWEI_PERMISSION_APP_TRACKING_CONSENT = "ohos.permission.APP_TRACKING_CONSENT";
  static readonly HUAWEI_SYS_CAPABILITY_ADS = "SystemCapability.Advertising.Ads"
}