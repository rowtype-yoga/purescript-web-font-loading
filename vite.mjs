import { readFileSync } from "node:fs";
import { resolve } from "node:path";

export function fontLoadingAssets({ assets = {}, notices = {} } = {}) {
  const virtualId = "virtual:web-font-loading-assets";
  const resolvedId = `\0${virtualId}`;
  return {
    name: "web-font-loading-assets",
    resolveId(id) {
      if (id === virtualId) return resolvedId;
    },
    load(id) {
      if (id !== resolvedId) return;
      const entries = Object.entries(assets).map(([name, file]) => {
        const path = resolve(file);
        this.addWatchFile(path);
        return `[${JSON.stringify(name)}]: ${JSON.stringify(readFileSync(path).toString("base64"))}`;
      });
      return `export const assets = {${entries.join(",")}};`;
    },
    generateBundle(_, bundle) {
      const text = Object.entries(notices)
        .map(([name, file]) => {
          const path = resolve(file);
          this.addWatchFile(path);
          return `${name}\n${readFileSync(path, "utf8")}`;
        })
        .join("\n\n")
        .replaceAll("*/", "* /");
      if (!text) return;
      for (const file of Object.values(bundle)) {
        if (file.type === "chunk") file.code = `/*! Bundled third-party licenses\n${text}\n*/\n${file.code}`;
      }
    },
  };
}
