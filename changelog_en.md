v9.0.0

**🔧 Core Refactoring (backend)**  
• All shared logic from the webroot shell scripts (compile.sh, clean.sh, profile.sh, update.sh) has been extracted into a new common file `webroot/lib.sh`: logging, localization (`t()`), parsing of numeric values, sorting packages by size, splitting into workers, profile compilation/reset, and writing statistics. Code duplication between the scripts has been eliminated.  
• The standalone binary `system/bin/deop` (run via `su -c deop`) was rewritten in the same style, but it does **not** source the shared `lib.sh` — some of the logic (parsing, process splitting, compilation) is duplicated inside it rather than reused.  
• The number of parallel processes is now clamped to the range 1–25 via `clamp_parts()` (in v8 the CLI menu limited it to 1–10, while the web compilation scripts had no limit at all).  
• Added a reusable `has_internet()` function for connection checks instead of inline `ping` calls scattered in different places.

**🐛 Fixes in update.sh**  
• Previously `UPDATE_URL` was requested twice (once for version, once for zipUrl) — now a single JSON response is reused for both fields.  
• Previously the `$ZIP_FILE` was created empty before the download, so the check `[ -f "$ZIP_FILE" ]` could succeed even if the download completely failed. Now the file is deleted beforehand, and after the download the check is `[ -s "$ZIP_FILE" ]` (not just existence, but non-zero size) — this also catches interrupted downloads that leave a 0-byte file.  
• Explicit internet check (`has_internet`) added at the beginning with a localized error message.  
• Early check added to ensure the JSON was actually received (wget did not return empty content).

**🌐 Webroot backend (oresty.conf)**  
• New endpoint `/dex_optimizer/stats` — calculates statistics on the server side (Lua) and returns ready-made JSON: number of optimized apps, number of runs, speed gain (speedGain, % relative to previous compilation runs), percentage of successful dex compilations (dexPct), and an array of points for the chart (up to the last 30 compilation runs).  
• New endpoint `/dex_optimizer/last_run_time` — returns the timestamp of the last run from `stats.txt`.  
• New endpoint `/dex_optimizer/update` — starts `update.sh` via a POST request directly from the web interface (previously updates could only be started manually or on a schedule).  
• Handling of a missing log file fixed: previously an `io.open` error “No such file” returned 500; now it correctly returns 204 No Content.

**🎨 Web interface (webroot)**  
• Removed dependencies on Chart.js, chartjs-adapter-date-fns, chartjs-plugin-zoom, and Hammer.js (4 files). The statistics chart is now drawn by a lightweight custom function `drawChart()` — simple bar chart without third-party libraries, which noticeably reduces the size of the webroot.  
• `index.html`, `script.js`, and `styles.css` have been substantially rewritten (hundreds of changed lines) to support the new chart logic, server-side statistics endpoints, and UI/theme refinements.  
• The module update button/logic now calls the new `/dex_optimizer/update` endpoint instead of the previous method.

**📦 Other**  
• `webroot/oresty.conf`: unnecessary indentation removed from the root location block for `.sh` scripts (cosmetic change, does not affect behaviour).
