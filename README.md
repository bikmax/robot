# Robot Automation Project

This project demonstrates my **SDET skills** in building a maintainable and scalable automation framework using **Robot Framework**, **Python**, **Selenium/Appium**

It covers **Web UI**, **Mobile**, and **API** test automation with a clean structure, reusable components, includes AI-powered validation with OpenAI and GitLab CI/CD integration.

---

## Tech Stack
- [Robot Framework](https://robotframework.org/) — main automation framework  
- [Python 3.11+](https://www.python.org/) — scripting and custom libraries  
- [SeleniumLibrary](https://robotframework.org/SeleniumLibrary/) — web UI automation  
- [AppiumLibrary](http://serhatbolsu.github.io/robotframework-appiumlibrary/AppiumLibrary.html) — mobile app automation  
- [RequestsLibrary](https://marketsquare.github.io/robotframework-requests/) — API testing  
- Custom OpenAI Library — AI-powered validation of text and screenshots

---
### How to run: 
### Prerequisites
- Python 3.11+  
- For mobile tests: Node.js + Appium (or `npx appium`) and Android SDK / emulator or a physical Android device.  
- For web tests:  Chromedriver is handled by `webdriver-manager` (included in `requirements.txt`).
- For AI-powered tests: OPENAI_API_KEY must be set in environment variables (GitLab CI/CD Secret).

### Setup
**pip install -r requirements.txt**

Install Appium Server and launch with command:

**appium --address 127.0.0.1 --port 4724**  

Install [APK](https://github.com/bikmax/robot/blob/main/android/apk/ApiDemos-debug.apk) to your emulated device


---
### Features

- [Mobile UI tests (Appium / Android)](tests/ui_mobile/test_apidemos.robot)  
- Web UI tests (Selenium) [WIKI](tests/ui_web/test_wikipedia_languages.robot) |  [SAUCE](tests\ui_web\test_ai_saucedemo.robot)
- [API tests (RequestsLibrary)](tests/api/test_mockapi_users.robot)  
- [AI-powered Web UI tests (OpenAI)](tests/ui_web/test_ai_saucedemo.robot)



### Test Run Commands

```bash
Mobile:
robot -d results tests/ui_mobile/test_apidemos.robot

Web:
robot -d results tests/ui_web/test_wikipedia_languages.robot
robot -d results tests/ui_web/test_ai_saucedemo.robot

API:
robot -d results tests/api/test_mockapi_users.robot

AI-powered Web:
robot -d results tests/ui_web/test_ai_saucedemo.robot
```
