import os
import sys
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from Screenshot import Screenshot
from functools import reduce

if __name__ == "__main__":
    os.chdir(os.getcwd())

    assert len(sys.argv) == 2, "Required parameter 'state' missing."

    state = sys.argv[1]

    assert state in ["before", "after"], "State must be either 'before' or 'after'."

    try:
        with open("urls.txt", mode = "rt", encoding = "UTF-8") as f:
            urls = f.readlines()
    except OSError as ex:
        print(ex)
        sys.exit(1)

    options = Options()
    options.add_argument("-headless")

    ob = Screenshot.Screenshot()
    driver = webdriver.Firefox(options = options)
    driver.set_window_size(1920, 1080)

    i = 1
    urls_len = len(urls)

    for url in urls:
        print(f"{i} of {urls_len}")

        url = url.strip()
        driver.get(url)

        img_dir = f"./{state}"
        img_name = str(reduce(lambda x, sum: x + sum, [ord(c) for c in url])) + ".png"

        img = ob.full_screenshot(driver,
                                 save_path = img_dir,
                                 image_name = img_name,
                                 is_load_at_runtime = True,
                                 load_wait_time = 3)

        with open("images.txt", mode = "at", encoding = "UTF-8") as f:
            f.write(f"{img_name} {url}\n")

        i += 1

    driver.quit()

    print("Done.")
    sys.exit(0)
