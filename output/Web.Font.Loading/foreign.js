const fonts = () =>
  typeof document !== "undefined" && document.fonts ? document.fonts : null

export const loadFontImpl = (font) => {
  const f = fonts()
  return f ? f.load(font).then(() => {}) : Promise.resolve()
}

export const fontsReadyImpl = () => {
  const f = fonts()
  return f ? f.ready.then(() => {}) : Promise.resolve()
}
