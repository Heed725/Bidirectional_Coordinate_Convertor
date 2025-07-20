# 🌍 Bi-Directional Coordinate Converter: DMS ↔ Decimal Degrees

## Overview

The **Bi-Directional Coordinate Converter** is an interactive web application built with **R Shiny** that allows users to convert geographic coordinates between:

* **DMS (Degrees, Minutes, Seconds)** — commonly used in field data collection and navigation
* **Decimal Degrees (DD)** — the standard in GIS, remote sensing, and web mapping

This app supports **batch conversions** through CSV file uploads and includes a **live preview** and **download option** for converted data. Input format is auto-detected based on the uploaded file’s column names.

---

## ✨ Key Features

✅ Upload CSV files with coordinates in either **DMS** or **Decimal Degrees**
🔄 **Automatic detection** of input format and correct conversion direction
👀 Instant **live preview** of uploaded and converted coordinates
⬇️ **Download** results as a CSV file with both original and converted formats
🎨 Beautiful UI using the **Cerulean** theme from `shinythemes`
❤️ Beginner-friendly and easy to use — no GIS experience required!

---

## 🛠️ How It Works

* If your CSV includes columns named `Lat` and `Long`, they are treated as **DMS** and will be converted to **Decimal Degrees** (`Deci_Lat`, `Deci_Long`).
* If your CSV includes `Deci_Lat` and `Deci_Long`, they are treated as **Decimal Degrees** and converted to **DMS** (`Lat`, `Long`).
* If the required columns are not found, the app will display an informative message prompting correct formatting.

---

## 📦 Installation (For Local Use)

To run this app locally in RStudio:

```r
install.packages(c("shiny", "tidyverse", "shinythemes"))
```

Then open the app file and run it using `shiny::runApp()`.

---

## 🚀 Launch the App

👉 [**Try it live on shinyapps.io**](https://hemedlungo.shinyapps.io/Bidirectional/)

---

## 🙏 Credits

Special thanks to [@bwanamuki](https://github.com/bwanamuki), whose original R script served as the foundation for this application.

