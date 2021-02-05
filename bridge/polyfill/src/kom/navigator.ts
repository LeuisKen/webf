import { kraken } from './kraken';
import geolocation from '../modules/geolocation';
import connection from '../modules/connection';
import { vibrate } from '../modules/vibration';

export const navigator = {
  vibrate,
  connection,
  geolocation,
  // UA is read-only.
  get userAgent() {
    return kraken.userAgent;
  },
  get hardwareConcurrency() {
    const logicalProcessors = kraken.invokeModule('DeviceInfo', 'getHardwareConcurrency', );
    return parseInt(logicalProcessors);
  },
  getDeviceInfo() {
    return new Promise((resolve, reject) => {
      kraken.invokeModule('DeviceInfo', 'getDeviceInfo', '', (e, data) => {
        if (e) {
          return reject(e);
        }
        resolve(data);
      });
    });
  },
  clipboard: {
    readText() {
      return new Promise((resolve, reject) => {
        kraken.invokeModule('Clipboard', 'readText', '', (e, data) => {
          if (e) {
            return reject(e);
          }
          resolve(data);
        });
      });
    },
    writeText(text: string) {
      return new Promise((resolve, reject) => {
        kraken.invokeModule('Clipboard', 'writeText', String(text), (e, data) => {
          if (e) {
            return reject(e);
          }
          resolve(data);
        });
      });
    }
  }
}
