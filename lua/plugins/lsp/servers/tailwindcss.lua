local root_pattern = require("lspconfig.util").root_pattern

return {
  root_dir = root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts"),
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          "cn\\(([^)]*)\\)",
        },
      },
    },
  },
}
