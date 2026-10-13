const fonts = () =>
  globalThis.fonts || (typeof document !== "undefined" ? document.fonts : null);

export const loadFontImpl = (font) => {
  const f = fonts()
  return f ? f.load(font).then(() => {}) : Promise.resolve()
}

export const fontsReadyImpl = () => {
  const f = fonts()
  return f ? f.ready.then(() => {}) : Promise.resolve()
}

export const hasFontSet = () => fonts() != null;
export const checkFont = font => () => fonts().check(font);
export const supportsFontFace = () => typeof FontFace === "function";
export const newFontFaceImpl = family => source => descriptors => () =>
  new FontFace(family, source, descriptors);
export const loadFontFaceImpl = face => () => face.load().then(() => {});
export const addFontFace = face => () => { fonts().add(face); };
