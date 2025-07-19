# 🌍 Bi-Directional Coordinate Converter: DMS ↔ Decimal Degrees

## Overview

The **Bi-Directional Coordinate Converter** is an interactive web application built using R and the Shiny framework. This app is designed to help users convert geographic coordinates between two common formats:

- **DMS (Degrees, Minutes, Seconds)** format — commonly used in navigation and field data collection.
- **Decimal Degrees (DD)** format — widely used in GIS, remote sensing, and web mapping applications.

The app supports batch conversions from uploaded CSV files and allows users to preview and download the converted coordinates. It automatically detects the input format based on the uploaded file's column names and performs the correct transformation.

---

## ✨ Features

- ✅ Upload CSV files with either DMS or Decimal Degree coordinates
- 🔄 Automatically detects coordinate format and performs the correct conversion
- ⬇️ Download the output as a CSV file with both original and converted columns
- 👀 Live preview of converted data inside the app
- 🎨 Styled using the **Cerulean** theme from `shinythemes`
- ❤️ Easy to use and beginner-friendly interface

---

## 🖥️ How the App Works

The application performs conversions based on the following logic:

- If the uploaded file contains columns named `Lat` and `Long`, they are assumed to be in **DMS format**, and will be converted to **Decimal Degrees**. The result will be added as new columns `Deci_Lat` and `Deci_Long`.

- If the uploaded file contains columns named `Deci_Lat` and `Deci_Long`, they are assumed to be in **Decimal Degrees**, and will be converted to **DMS format**. The result will be added as new columns `Lat` and `Long`.

If neither column pair is found, the app will throw an informative error asking for the correct column names.

---

## 🔧 Installation

To run this app locally, make sure you have R installed along with the required packages. You can install them using:

```r
install.packages(c("shiny", "tidyverse", "shinythemes"))

```

[Open the app on Posit Connect](https://connect.posit.cloud/hemedlungo/content/01980590-072b-9fdc-2627-61d99f4caa85)

full credit:@Bwanamuki
