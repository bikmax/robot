*** Variables ***
# Login page
${LOGIN_USERNAME}           id=user-name
${LOGIN_PASSWORD}           id=password
${LOGIN_BUTTON}             id=login-button
${ERROR_BANNER}             css=.error-message-container

# Inventory page
${INVENTORY_LIST}           css=.inventory_list
${INVENTORY_ITEMS}          css=.inventory_item
${INVENTORY_ITEM_NAME}      css=.inventory_item_name
${INVENTORY_ITEM_PRICE}     css=.inventory_item_price
${INVENTORY_ITEM_IMG}       css=.inventory_item_img img

# Buttons/selectors
${ADD_TO_CART_BTN_XPATH}    xpath=(//button[contains(@id,'add-to-cart')])
${CART_LINK}                css=.shopping_cart_link
${CART_BADGE}               css=.shopping_cart_badge

# Product details
${PRODUCT_DESC}             css=.inventory_details_desc
${PRODUCT_IMG}              css=.inventory_details_img

# Checkout
${CHECKOUT_BTN}             id=checkout
${FIRST_NAME}               id=first-name
${LAST_NAME}                id=last-name
${POSTAL_CODE}              id=postal-code
${CONTINUE_BTN}             id=continue
${FINISH_BTN}               id=finish
${THANK_YOU_TEXT}           THANK YOU FOR YOUR ORDER
${SUMMARY_SUBTOTAL}         css=.summary_subtotal_label

# Menu
${MENU_BTN}                 id=react-burger-menu-btn
${LOGOUT_LINK}              id=logout_sidebar_link

# Misc
${FOOTER_COPY}              css=.footer_copy
${REMOVE_BTN_XPATH}    xpath=(//button[contains(@id,'remove')])