//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

function showShareIcons(title) {
  $("#shareIconsCount").jsSocials({
    shareIn: "popup",
    url: window.location.href,
    text: title,
    showCount: true,
    showLabel: false,
    shares: [
      "twitter",
      "facebook",
      "googleplus",
      "pinterest"
    ]
  });
}
