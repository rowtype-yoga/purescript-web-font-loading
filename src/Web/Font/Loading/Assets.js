import { assets } from "virtual:web-font-loading-assets";

export const binaryAsset = key => () => {
  if (!Object.prototype.hasOwnProperty.call(assets, key)) throw new Error(`Unknown configured binary asset: ${key}`);
  const binary = atob(assets[key]);
  const bytes = new Uint8Array(binary.length);
  for (let index = 0; index < binary.length; index++) bytes[index] = binary.charCodeAt(index);
  return bytes.buffer;
};
