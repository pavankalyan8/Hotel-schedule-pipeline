import time
import re
import pandas as pd
from datetime import date
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

from config import WIW_EMAIL, WIW_PASSWORD


def login_and_open_schedule():
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service)

    driver.get("https://appx.wheniwork.com")
    driver.maximize_window()
    time.sleep(3)

    # login
    email_input = driver.find_element(By.NAME, "email")
    password_input = driver.find_element(By.NAME, "password")

    email_input.send_keys(WIW_EMAIL)
    password_input.send_keys(WIW_PASSWORD)
    password_input.send_keys(Keys.RETURN)

    time.sleep(8)  # wait for redirect

    # go to team scheduler page
    driver.get("https://appx.wheniwork.com/scheduler")
    time.sleep(8)

    return driver


def scrape_visible_week(driver):
    records = []

    name_elems = driver.find_elements(By.CSS_SELECTOR, ".user-name")
    print(f"Found {len(name_elems)} employees")

    for name_el in name_elems:
        employee_name = name_el.text.strip()
        if not employee_name:
            continue

        # find ancestor "row" container
        row = name_el.find_element(
            By.XPATH,
            "./ancestor::div[contains(@class, 'row')][1]"
        )

        # DEBUG: what does this row contain?
        print("\n==============================")
        print("EMPLOYEE:", employee_name)
        print("ROW HTML (truncated):")
        print(row.get_attribute("outerHTML")[:400])  # first 400 chars only

        # find potential shift cells inside that row
        shift_cells = row.find_elements(By.CSS_SELECTOR, ".col-auto")
        print(f"  -> Found {len(shift_cells)} .col-auto cells in this row")

        for i, cell in enumerate(shift_cells[:10]):  # just first 10 for debug
            txt = cell.text.replace("\u00a0", " ").strip()
            print(f"    cell[{i}] text: '{txt}'")

    return records  # we’re not building records yet, just debugging



def main():
    driver = login_and_open_schedule()

    print("If needed, change the week in the UI, then let it run...")
    time.sleep(10)

    records = scrape_visible_week(driver)
    driver.quit()

    if not records:
        print("No records scraped. Check selectors.")
        return

    df = pd.DataFrame(records)
    today_str = date.today().strftime("%Y-%m-%d")

    csv_path = f"data_raw/schedule_raw_{today_str}.csv"
    xlsx_path = f"data_raw/schedule_raw_{today_str}.xlsx"

    df.to_csv(csv_path, index=False)
    df.to_excel(xlsx_path, index=False)

    print(f"Scraped {len(df)} rows")
    print(f"Saved to:\n  {csv_path}\n  {xlsx_path}")


if __name__ == "__main__":
    main()
