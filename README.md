# comp-url2img

Take full page screenshots of web-pages before and after applying the desired changes and compare them against each other.

# Installation

1. Install [Python](https://www.python.org/downloads/windows/)
    1. Install Selenium - `pip install selenium`
    1. Install Selenium-Screenshot - `pip install Selenium-Screenshot`
1. Download and unzip [geckodriver](https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-win32.zip)
1. Install [ImageMagick](https://imagemagick.org/script/download.php)

Make sure Python, geckodriver and ImageMagick executables are added to the `PATH`.

# Taking screenshots

1. Fill in `urls.txt`
1. `run_before.bat`
1. Make desired changes
1. `run_after.bat`

# Comparing screenshots

Run `run_compare.bat`

# Result file

Result file location: `<script directory>\result.txt`

Result file format: `<comparison result> <file name>`

Comparison results:
- 0 - files are similar
- 1 - files are dissimilar
- 2 - there was a problem comparing files

# Notes

By default both `run_before.bat` and `run_after.bat` will not empty 'before' and 'after' directories respectively.  
`--reset` should be passed as second argument to `take_screenshots.bat` to perform a clean run.

Firefox is launched in the headless mode.

URLs are represented as integers (see images.txt).
