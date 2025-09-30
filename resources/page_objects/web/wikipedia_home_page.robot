*** Variables ***
${WIKIPEDIA_URL}    https://www.wikipedia.org/

${EN_LINK}          css=a[id=js-link-box-en]
${FR_LINK}          css=a[id=js-link-box-fr]
${RU_LINK}          css=a[id=js-link-box-ru]

${EN_HEADER}        Welcome to Wikipedia
${FR_HEADER}        Bienvenue sur Wikipédia
${RU_HEADER}        Добро пожаловать

&{LANG_LINKS}
...    en=${EN_LINK}
...    fr=${FR_LINK}
...    ru=${RU_LINK}

&{LANG_HEADERS}
...    en=${EN_HEADER}
...    fr=${FR_HEADER}
...    ru=${RU_HEADER}
