export const createCanvasElementImpl = () => document.createElement("canvas")

export const setLetterSpacingImpl = (ctx, spacing) => {
  ctx.letterSpacing = spacing
}

export const setFontKerningImpl = (ctx, kerning) => {
  ctx.fontKerning = kerning
}

export const createOffscreenCanvasImpl = (width, height) =>
  new OffscreenCanvas(width, height)

export const supportsOffscreenCanvas = () => typeof OffscreenCanvas === "function"

export const supportsCanvasElement = () =>
  typeof document !== "undefined" && typeof document.createElement === "function"

export const isOffscreenCanvas = canvas => () =>
  typeof OffscreenCanvas === "function" && canvas instanceof OffscreenCanvas

export const getContext2DNullable = canvas => () => canvas.getContext("2d")

export const contextCanvas = ctx => () => ctx.canvas

export const resetContext = ctx => () => {
  if (typeof ctx.reset === "function") {
    ctx.reset()
  } else {
    ctx.setTransform(1, 0, 0, 1, 0, 0)
    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height)
  }
}

export const measureTextInkImpl = (ctx, text) => {
  const metrics = ctx.measureText(text)
  return {
    width: metrics.width,
    ascent: metrics.actualBoundingBoxAscent ?? NaN,
    descent: metrics.actualBoundingBoxDescent ?? NaN
  }
}

export const clipWithRuleImpl = (ctx, rule) => ctx.clip(rule)

export const setFilterImpl = (ctx, filter) => {
  ctx.filter = filter
}

export const createPatternNullableImpl = ctx => source => repeat => () =>
  ctx.createPattern(source, repeat)

export const setPatternTransformImpl = (pattern, transform) => {
  if (typeof pattern.setTransform !== "function") return false
  pattern.setTransform(transform)
  return true
}
