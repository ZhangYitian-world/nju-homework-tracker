# Local Screenshot Recognition

Static vendor files, without npm installation or a build step:

- Tesseract.js 7.0.0 browser bundle and worker, Apache-2.0. Source: https://github.com/naptha/tesseract.js
- Tesseract.js-core 7.0.0 WASM variants, Apache-2.0. Source: https://github.com/naptha/tesseract.js-core
- English and simplified Chinese LSTM integer models from the official `@tesseract.js-data/eng` and `@tesseract.js-data/chi_sim` packages, pinned `4.0.0_best_int` data directories (Tesseract language data, Apache-2.0). Download source: `https://cdn.jsdelivr.net/npm/@tesseract.js-data/LANGUAGE/4.0.0_best_int/LANGUAGE.traineddata.gz`.
- Bundles downloaded from their version-pinned official npm registry tarballs; no runtime CDN for OCR.

OCR executes in a browser worker. Uploaded screenshots are decoded to a local canvas, never sent to an OCR service or saved in the database. Only the user's confirmed timetable text is saved through the existing account's authenticated cloud API. Model files are downloaded from the same website and cached in browser IndexedDB by Tesseract.

Grid mode assumes regular weekday columns and regular period rows. Colored class blocks are segmented by background color; each crop is independently recognized. Manual bounds and visible weekday/period range controls allow different screenshots and cropped views. Plain screenshots and course detail pages can be tried with text mode; missing or uncertain fields require manual entry. No inferred full-semester repetition, missing course names, teachers, or passwords.
