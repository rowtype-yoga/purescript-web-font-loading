export const createCanvasElementImpl = () => document.createElement("canvas")

export const setLetterSpacingImpl = (ctx, spacing) => {
  ctx.letterSpacing = spacing
}

export const setFontKerningImpl = (ctx, kerning) => {
  ctx.fontKerning = kerning
}
