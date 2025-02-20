import { advertising } from '@kit.AdsKit';
import { router } from '@kit.ArkUI';
import { Logger } from '../util/Logger';

const  TAG = "AdRoute"

export class AdRoute {
  static async routePage(
    pageUri: string,
    ads: Array<advertising.Advertisement | null>,
    adOptions?: advertising.AdOptions,
    adDisplayOptions?: advertising.AdDisplayOptions) {
    let options: router.RouterOptions = {
      url: pageUri,
      params: {
        ads: ads,
        adOptions: adOptions || {},
        adDisplayOptions: adDisplayOptions || {},
      }
    }
    try {
      Logger.info(`[${TAG}]`, `AdRoute routePage is ${pageUri}`);
      router.pushUrl(options);
    } catch (error) {
      Logger.error(`[${TAG}]`, `AdRoute routePage fail callback, code: ${error.code}, msg: ${error.message}`);
    }
  }
}