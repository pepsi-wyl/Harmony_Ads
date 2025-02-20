import { common } from '@kit.AbilityKit';
import { advertising } from '@kit.AdsKit';
import { AdConstants } from '../common/AdConstants';
import { Logger } from '../util/Logger';
import { AdIdentifier } from './AdIdentifier';
import { AdLoadStatus } from './AdLoadStatus';

const TAG = 'AdRequest';

export class AdRequest {
  private context: common.UIAbilityContext;
  private requestAdStatus = AdLoadStatus.AD_LOAD_NORMAL;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  private requestTimeoutHandler(callback: () => void, requestTimeOutDuration: number): number {
    return setTimeout(() => {
      callback();
    }, requestTimeOutDuration);
  }

  public requestAd(
    adReqParams: advertising.AdRequestParams,
    adOptions: advertising.AdOptions,
    adDisplayOptions: advertising.AdDisplayOptions,
    successCallBack: (ads: Array<advertising.Advertisement>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => void,
    errorCallBack: (errorCode: number, errorMsg: string) => void,
    requestTimeOutDuration: number = AdConstants.TIME_OUT_DURATION,
  ): void {

    this.requestAdStatus = AdLoadStatus.AD_LOAD_NORMAL;

    const requestTimeoutId = this.requestTimeoutHandler(() => {
      Logger.error(`[${TAG}]`, `Ad loading timeout`);
      this.requestAdStatus = AdLoadStatus.AD_LOAD_TIMEOUT;
      errorCallBack(AdConstants.TIME_OUT_CODE, "Ad loading timeout");
    }, requestTimeOutDuration);

    AdIdentifier.requestOAIDTrackingConsentPermissions(this.context);
    adReqParams.oaid = AdIdentifier.OAID;

    const adLoaderListener: advertising.AdLoadListener = {
      onAdLoadFailure: (errorCode: number, errorMsg: string) => {
        clearTimeout(requestTimeoutId);
        if (this.requestAdStatus == AdLoadStatus.AD_LOAD_TIMEOUT) {
          return;
        }

        Logger.error(`[${TAG}]`, `request ad errorCode is: ${errorCode}, errorMsg is: ${errorMsg}`);
        this.requestAdStatus = AdLoadStatus.AD_LOAD_ERROR;
        errorCallBack(errorCode, errorMsg);
      },

      onAdLoadSuccess: (ads: Array<advertising.Advertisement>) => {
        clearTimeout(requestTimeoutId);
        if (this.requestAdStatus == AdLoadStatus.AD_LOAD_TIMEOUT) {
          return;
        }

        Logger.info(`[${TAG}]`, 'request ad succeeded!');
        this.requestAdStatus = AdLoadStatus.AD_LOAD_SUCCESS;
        successCallBack(ads, adOptions, adDisplayOptions);
      }
    };

    new advertising.AdLoader(this.context).loadAd(adReqParams, adOptions, adLoaderListener);

    this.requestAdStatus = AdLoadStatus.AD_LOAD_LOADING;
  }

  public requestAdWithMultiSlots(
    adReqParamsArr: advertising.AdRequestParams[],
    adOptions: advertising.AdOptions,
    adDisplayOptions: advertising.AdDisplayOptions,
    successCallBack: (ads: Map<string, Array<advertising.Advertisement>>, adOptions: advertising.AdOptions, adDisplayOptions: advertising.AdDisplayOptions) => void,
    errorCallBack: (errorCode: number, errorMsg: string) => void,
    requestTimeOutDuration: number = AdConstants.TIME_OUT_DURATION,
  ): void {

    this.requestAdStatus = AdLoadStatus.AD_LOAD_NORMAL;

    const requestTimeoutId = this.requestTimeoutHandler(() => {
      Logger.error(`[${TAG}]`, `Ad loading timeout`);
      this.requestAdStatus = AdLoadStatus.AD_LOAD_TIMEOUT;
      errorCallBack(AdConstants.TIME_OUT_CODE, "Ad loading timeout");
    }, requestTimeOutDuration);

    AdIdentifier.requestOAIDTrackingConsentPermissions(this.context);
    adReqParamsArr.forEach((adReqParams, index) => {
      adReqParams.oaid = AdIdentifier.OAID;
    })

    const adLoaderListener: advertising.MultiSlotsAdLoadListener = {
      onAdLoadFailure: (errorCode: number, errorMsg: string) => {
        clearTimeout(requestTimeoutId);
        if (this.requestAdStatus == AdLoadStatus.AD_LOAD_TIMEOUT) {
          return;
        }

        Logger.error(`[${TAG}]`, `request ad errorCode is: ${errorCode}, errorMsg is: ${errorMsg}`);
        this.requestAdStatus = AdLoadStatus.AD_LOAD_ERROR;
        errorCallBack(errorCode, errorMsg);
      },

      onAdLoadSuccess: (ads: Map<string, Array<advertising.Advertisement>>) => {
        clearTimeout(requestTimeoutId);
        if (this.requestAdStatus == AdLoadStatus.AD_LOAD_TIMEOUT) {
          return;
        }

        Logger.info(`[${TAG}]`, 'request ad succeeded!');
        this.requestAdStatus = AdLoadStatus.AD_LOAD_SUCCESS;
        successCallBack(ads, adOptions, adDisplayOptions);
      }
    };

    new advertising.AdLoader(this.context).loadAdWithMultiSlots(adReqParamsArr, adOptions, adLoaderListener);

    this.requestAdStatus = AdLoadStatus.AD_LOAD_LOADING;
  }
}